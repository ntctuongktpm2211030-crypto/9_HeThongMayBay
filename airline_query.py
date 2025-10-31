
import os
from lxml import etree

# Kiểm tra file XML có tồn tại không
xml_file = "CombinedAirlineSystem.xml"
if not os.path.exists(xml_file):
    print(f"LỖI: Không tìm thấy file '{xml_file}'")
    print(f"   Đường dẫn hiện tại: {os.path.abspath('.')}")
    print("   HÃY ĐẶT file XML vào cùng thư mục với file .py!")
    exit(1)


root = etree.parse(xml_file).getroot()                                 # Đọc file XML
ns = {'ns': 'http://example.com/combined'}                             # Namespace

print("\n1. Tất cả MaSanBay:", *root.xpath("//ns:Airport/ns:MaSanBay/text()", namespaces=ns))
print("2. Danh sách hành khách:", *root.xpath("//ns:HanhKhach/ns:HoTen/text()", namespaces=ns))
print("3. MaDatCho=2 → PNR:", root.xpath("//ns:DatCho[ns:MaDatCho='2']/ns:MaPNR/text()", namespaces=ns)[0])
print("4. MaHK có MaVe=1005:", *root.xpath("//ns:TicketDetail[ns:MaVe='1005']/ns:MaHK/text()", namespaces=ns))
print("5. Hộ chiếu Việt Nam:", *root.xpath("//ns:Passport[ns:NuocCap='Vietnam']/ns:SoHoChieu/text()", namespaces=ns))
print("6. Tài khoản MaHK 101:", root.xpath("//ns:TaiKhoan[ns:MaHK='101']/ns:TenDangNhap/text()", namespaces=ns)[0])