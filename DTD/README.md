# DTD TỔNG HỢP HỆ THỐNG HÀNG KHÔNG

## Tổng quan
Thư mục `DTD/` chứa các file DTD cho hệ thống hàng không với kiểu trình bày thống nhất.

## Files chính:

### 1. **UnifiedAirlineSystem.dtd** - DTD tổng hợp
- Gộp tất cả 9 module hệ thống hàng không
- Kiểu trình bày thống nhất với format chuẩn
- Định nghĩa đầy đủ các elements và attributes

### 2. **AirlineData.xml** - Dữ liệu thật
- File XML sử dụng DTD tổng hợp
- Dữ liệu thực tế với 5 khách hàng, 5 chuyến bay
- Tất cả mối quan hệ dữ liệu được đảm bảo

## Cấu trúc DTD thống nhất:

### **Format chuẩn:**
```dtd
<!-- ========================================== -->
<!-- MODULE X: TÊN MODULE -->
<!-- ========================================== -->
<!ELEMENT DanhSachX (X+)>
<!ELEMENT X (field1, field2, field3?)>
<!ELEMENT field1 (#PCDATA)>
<!ELEMENT field2 (#PCDATA)>
<!ELEMENT field3 (#PCDATA)>
```

### **Các module được gộp:**

#### 1. **Hệ thống Sân bay và Tuyến bay**
- `Airports` - Quản lý sân bay
- `Routes` - Quản lý tuyến bay  
- `Flights` - Quản lý chuyến bay

#### 2. **Hệ thống Hành khách**
- `DanhSachHanhKhach` - Danh sách hành khách
- `HanhKhach` - Thông tin cá nhân

#### 3. **Hệ thống Tài khoản**
- `DanhSachTaiKhoan` - Danh sách tài khoản
- `TaiKhoan` - Thông tin đăng nhập

#### 4. **Hệ thống Đặt chỗ**
- `DanhSachDatCho` - Danh sách đặt chỗ
- `DatCho` - Chi tiết đặt chỗ

#### 5. **Hệ thống Ký gửi Hành lý**
- `DanhSachKiGui` - Danh sách ký gửi
- `KiGui` - Chi tiết ký gửi

#### 6. **Hệ thống Hộ chiếu**
- `HoChieus` - Danh sách hộ chiếu
- `HoChieu` - Thông tin hộ chiếu

#### 7. **Hệ thống Loại vé**
- `LoaiVes` - Danh sách loại vé
- `LoaiVe` - Chi tiết loại vé

#### 8. **Hệ thống Chi tiết vé**
- `ChiTietVes` - Danh sách chi tiết vé
- `ChiTietVe` - Thông tin vé

#### 9. **Hệ thống Thông tin Hành khách**
- `ThongTinHanhKhachs` - Danh sách thông tin
- `ThongTinHanhKhach` - Chi tiết thông tin

## Cách sử dụng:

### **Với XML file:**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE UnifiedAirlineSystem SYSTEM "UnifiedAirlineSystem.dtd">
<UnifiedAirlineSystem xmlns="http://example.com/airline">
  <!-- Nội dung XML -->
</UnifiedAirlineSystem>
```

### **Cấu trúc root element:**
```xml
<UnifiedAirlineSystem>
  <Airports>...</Airports>
  <Routes>...</Routes>
  <Flights>...</Flights>
  <DanhSachHanhKhach>...</DanhSachHanhKhach>
  <DanhSachTaiKhoan>...</DanhSachTaiKhoan>
  <DanhSachDatCho>...</DanhSachDatCho>
  <DanhSachKiGui>...</DanhSachKiGui>
  <HoChieus>...</HoChieus>
  <LoaiVes>...</LoaiVes>
  <ChiTietVes>...</ChiTietVes>
  <ThongTinHanhKhachs>...</ThongTinHanhKhachs>
</UnifiedAirlineSystem>
```

## Dữ liệu mẫu trong AirlineData.xml:

### **Sân bay:** 5 sân bay (SGN, HAN, DAD, NRT, SIN)
### **Tuyến bay:** 5 tuyến bay kết nối các sân bay
### **Chuyến bay:** 5 chuyến bay (501-505)
### **Hành khách:** 5 khách hàng (101-105)
### **Tài khoản:** 5 tài khoản tương ứng
### **Đặt chỗ:** 5 đặt chỗ với trạng thái khác nhau
### **Ký gửi:** 5 ký gửi hành lý
### **Hộ chiếu:** 5 hộ chiếu tương ứng
### **Loại vé:** 5 loại vé (Economy/Business)
### **Chi tiết vé:** 5 chi tiết vé
### **Thông tin:** 5 thông tin hành khách

## Mối quan hệ dữ liệu:

- **TAIKHOAN.MaHK** → **HANHKHACH.MaHK**
- **DATCHO.MaTK** → **TAIKHOAN.MaTK**
- **DATCHO.MaChuyenBay** → **FLIGHTS.MaChuyenBay**
- **DATCHO.MaKiGui** → **KIGUI.MaKG**
- **CHITIETVE.MaVe** → **LOAIVE.MaVe**
- **CHITIETVE.MaDatCho** → **DATCHO.MaDC**
- **CHITIETVE.MaHK** → **HANHKHACH.MaHK**
- **THONGTINHANHKHACH.SoHoChieu** → **HOCHIEU.SoHoChieu**
- **THONGTINHANHKHACH.MaVe** → **CHITIETVE.MaVe**

## Lưu ý quan trọng:

### **Hạn chế của DTD:**
1. **Không hỗ trợ kiểu dữ liệu mạnh** - Tất cả đều là `#PCDATA`
2. **Không có ràng buộc pattern** - Không kiểm tra format
3. **Không có khóa chính/ngoại** - Không đảm bảo tính toàn vẹn
4. **Không hỗ trợ namespace** - Chỉ có một namespace duy nhất

### **Khuyến nghị:**
- **Sử dụng XSD** thay vì DTD để có kiểm tra chặt chẽ hơn
- **Validate dữ liệu** bằng các công cụ bên ngoài
- **Đảm bảo tính nhất quán** thông qua logic ứng dụng

## Files liên quan:
- `UnifiedAirlineSystem.dtd` - DTD tổng hợp
- `AirlineData.xml` - Dữ liệu thật với DTD
- `../CombinedAirlineSystem.xsd` - Schema XSD tương ứng
- `../CombinedAirlineSystem.xml` - File XML với XSD validation