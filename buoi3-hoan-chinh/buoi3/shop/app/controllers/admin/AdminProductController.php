<?php
class AdminProductController extends AdminController {
    public function index(): void {
        $sql="SELECT p.*,c.name category_name,pi.file_name image,(SELECT COUNT(*) FROM product_images x WHERE x.product_id=p.id) image_count
              FROM products p JOIN categories c ON c.id=p.category_id
              LEFT JOIN product_images pi ON pi.product_id=p.id AND pi.is_primary=1 ORDER BY p.created_at DESC";
        $this->adminView('admin/product/index',['pageTitle'=>'Quản lý sản phẩm','products'=>Database::getInstance()->query($sql)->fetchAll()]);
    }
    public function add(): void {
        if($_SERVER['REQUEST_METHOD']==='POST') {
            verify_csrf($_POST['csrf_token']??'');
            [$data,$errors]=$this->validate($_POST,null);
            if($errors) { flash('error',implode(' | ',$errors)); $this->redirect('admin/product/add'); }
            $id=Product::insert($data);
            $uploaded=$this->handleUploadedImages($id,$data['name']);
            if($uploaded>0) {
                flash('success','Đã thêm sản phẩm và tải lên '.$uploaded.' ảnh thành công.');
            } else {
                flash('success','Đã thêm sản phẩm. Bạn có thể tải thêm ảnh bên dưới.');
            }
            $this->redirect('admin/product/edit/'.$id);
        }
        $this->adminView('admin/product/form',['pageTitle'=>'Thêm sản phẩm','product'=>null,'categories'=>Category::all('name ASC'),'images'=>[]]);
    }
    public function edit($id): void {
        $p=Product::find((int)$id); if(!$p) { flash('error','Không tìm thấy sản phẩm.'); $this->redirect('admin/product'); }
        if($_SERVER['REQUEST_METHOD']==='POST') {
            verify_csrf($_POST['csrf_token']??'');
            [$data,$errors]=$this->validate($_POST,(int)$id);
            if($errors) { flash('error',implode(' | ',$errors)); $this->redirect('admin/product/edit/'.$id); }
            Product::update((int)$id,$data);
            $uploaded=$this->handleUploadedImages((int)$id,$data['name']);
            $msg='Đã cập nhật sản phẩm.';
            if($uploaded>0) $msg.=' Đã tải lên thêm '.$uploaded.' ảnh.';
            flash('success',$msg);
            $this->redirect('admin/product/edit/'.$id);
        }
        $this->adminView('admin/product/form',['pageTitle'=>'Sửa sản phẩm','product'=>$p,'categories'=>Category::all('name ASC'),'images'=>ProductImage::forProduct((int)$id)]);
    }
    public function delete(): void {
        verify_csrf($_POST['csrf_token']??''); $id=(int)($_POST['id']??0);
        ProductImage::deleteAllForProduct($id); Product::delete($id); flash('success','Đã xóa sản phẩm và ảnh liên quan.'); $this->redirect('admin/product');
    }
    private function handleUploadedImages(int $pid, string $defaultAlt): int {
        $f=$_FILES['images']??[];
        if(empty($f['name'])||!is_array($f['name'])) return 0;
        $files=[];
        foreach($f['name'] as $i=>$name) {
            if(($f['error'][$i]??UPLOAD_ERR_NO_FILE)!==UPLOAD_ERR_NO_FILE) {
                $files[]=['name'=>$name,'type'=>$f['type'][$i]??'','tmp_name'=>$f['tmp_name'][$i]??'','error'=>$f['error'][$i]??UPLOAD_ERR_NO_FILE,'size'=>$f['size'][$i]??0];
            }
        }
        if(!$files) return 0;
        $count=ProductImage::countForProduct($pid);
        $uploaded=0;
        foreach($files as $file) {
            if($count>=UPLOAD_MAX_IMAGES) break;
            $errors=ImageService::validate($file);
            if($errors) { flash('error',e($file['name']).': '.e(implode(' ',$errors))); continue; }
            try {
                $saved=ImageService::processAndSave($file);
                $primary=$count===0?1:0;
                ProductImage::insert([
                    'product_id'=>$pid,
                    'file_name'=>$saved['file_name'],
                    'original_name'=>$saved['original_name'],
                    'alt_text'=>$defaultAlt,
                    'is_primary'=>$primary,
                    'sort_order'=>ProductImage::nextSortOrder($pid)
                ]);
                $count++;
                $uploaded++;
            } catch(Throwable $ex) {
                error_log($ex->getMessage());
                flash('error',e($file['name']).': lỗi xử lý ảnh.');
            }
        }
        return $uploaded;
    }
    private function validate(array $in,?int $exclude): array {
        $errors=[]; $name=trim($in['name']??''); $sku=trim($in['sku']??''); $cat=(int)($in['category_id']??0);
        $price=(float)($in['price']??0); $stock=(int)($in['stock']??0);
        if($name==='') $errors[]='Tên sản phẩm không được để trống.';
        if($sku==='') $errors[]='SKU không được để trống.'; elseif(Product::skuExists($sku,$exclude)) $errors[]='SKU đã tồn tại.';
        if(!$cat||!Category::find($cat)) $errors[]='Danh mục không hợp lệ.';
        if($price<=0) $errors[]='Giá phải lớn hơn 0.'; if($stock<0) $errors[]='Tồn kho không được âm.';
        return [[ 'category_id'=>$cat,'sku'=>$sku,'name'=>$name,'brand'=>trim($in['brand']??''),'description'=>trim($in['description']??''),'price'=>$price,'stock'=>$stock,'is_featured'=>isset($in['is_featured'])?1:0,'status'=>in_array($in['status']??'',['active','inactive'],true)?$in['status']:'active' ],$errors];
    }
}
