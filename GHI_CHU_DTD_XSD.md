### Ghi chú nhanh: DTD vs XSD và "restriction" trong XSD

- **restriction trong XSD**: Cách tạo kiểu dữ liệu hẹp hơn từ kiểu cơ sở. Ví dụ `xs:restriction base="xs:string"` rồi thêm `xs:minLength/xs:maxLength/xs:pattern/xs:enumeration...` để giới hạn giá trị hợp lệ.
  - Ví dụ trong `TAIKHOAN.xsd`: `UsernameType` giới hạn độ dài 4–32 và pattern; `PasswordType` giới hạn 6–64.
  - Trong `HANHKHACH.xsd`: `EmailType` dùng `pattern` email, `PhoneType` dùng `pattern` số, `PassportType` dùng `minLength/maxLength`.
  - Trong `DATCHO.xsd` và `KIGUI.xsd`: các `TrangThai*Type` dùng `enumeration` để giới hạn giá trị.

- **Những gì DTD không thể hiện được so với XSD**:
  - Không có kiểu dữ liệu mạnh: tất cả lá thường là `#PCDATA` (chuỗi), không kiểm tra `integer`, `date`, `decimal`.
  - Không ràng buộc được `pattern`, `minLength`, `maxLength`, `enumeration`.
  - Không hỗ trợ `key`, `unique`, `keyref` (khóa và khóa ngoại) hay `namespace`.

- **Cách dùng DTD**:
  - Thêm DOCTYPE vào tài liệu XML tương ứng, ví dụ cho danh sách hành khách:
```xml
<!DOCTYPE DanhSachHanhKhach SYSTEM "HANHKHACH.dtd">
```
  - Với tài liệu có nhiều namespace như `test.xml`, DTD không hỗ trợ namespace nên thường tách tài liệu theo từng gốc (`DanhSachHanhKhach`, `DanhSachTaiKhoan`, `DanhSachDatCho`, `DanhSachKiGui`) nếu muốn validate bằng DTD.

- **Khuyến nghị**: Tiếp tục dùng XSD để có kiểm tra chặt chẽ. DTD chỉ phù hợp khi cần tính tương thích cũ hoặc yêu cầu rất đơn giản.

### Danh mục nhanh các thành phần/kiểu `xs:*` đã dùng và công dụng

- **xs:schema**: Gốc schema; khai báo namespace, `targetNamespace`, `elementFormDefault` và chứa các định nghĩa.
- **xs:import**: Nhập schema khác thuộc namespace khác (tham chiếu chéo giữa các file).
- **xs:element**: Khai báo phần tử XML. Có thể tham chiếu `type` hoặc khai báo `xs:complexType` nội tuyến.
- **xs:complexType**: Kiểu phức hợp có cấu trúc con (thường đi với `xs:sequence`).
- **xs:sequence**: Ràng buộc thứ tự các phần tử con; hỗ trợ `minOccurs`/`maxOccurs` trên từng con.
- **xs:simpleType**: Kiểu đơn giản (lá), thu hẹp từ kiểu cơ sở bằng `xs:restriction`.
- **xs:restriction**: Thu hẹp kiểu cơ sở bằng các facet (liệt kê dưới đây).
- **xs:enumeration**: Liệt kê tập giá trị hợp lệ.
- **xs:pattern**: Regex để kiểm tra giá trị chuỗi.
- **xs:minLength / xs:maxLength**: Giới hạn độ dài chuỗi tối thiểu/tối đa.
- **xs:unique**: Ràng buộc duy nhất trong phạm vi phần tử bao; xác định bằng `xs:selector` và `xs:field` (XPath tương đối).
- **xs:keyref**: Khóa ngoại tham chiếu tới một `xs:key`/`xs:unique` được đặt tên.
- **Thuộc tính hay dùng**:
  - `name`: tên phần tử/kiểu.
  - `type`: kiểu dữ liệu của phần tử.
  - `minOccurs`/`maxOccurs`: số lần xuất hiện (1 mặc định; `unbounded` là không giới hạn).
  - `targetNamespace`: namespace của các định nghĩa trong schema.
  - `elementFormDefault="qualified"`: yêu cầu phần tử địa phương mang namespace.

- **Kiểu dữ liệu dựng sẵn đã dùng**:
  - `xs:string`: chuỗi.
  - `xs:integer`: số nguyên.
  - `xs:date`: ngày (YYYY-MM-DD).
  - `xs:decimal`: số thập phân.

