# xpath_queries.py
from lxml import etree

XML_FILE = "CombinedAirlineSystem.xml"

NS = {
    "c": "http://example.com/combined",
    "airport": "http://example.com/airportsystem",
    "airline": "http://example.com/airline",
    "dc": "http://example.com/datcho",
    "hk": "http://example.com/hanhkhach",
    "kg": "http://example.com/kigui",
    "tk": "http://example.com/taikhoan",
}

tree = etree.parse(XML_FILE)
root = tree.getroot()

print("1) Danh sách chuyến bay thuộc tuyến 101:")
flights_101 = root.xpath("//airport:Flight[airport:MaTuyenBay='101']/airport:MaChuyenBay/text()", namespaces=NS)
print(flights_101)

print("\n2) Hành khách có vé đã thanh toán (TicketDetails dc:TrangThai='Paid'):")
paid_hk = root.xpath("//airline:TicketDetail[dc:TrangThai='Paid']/tk:MaHK/text()", namespaces=NS)
print(paid_hk)

print("\n3) Đếm số đặt chỗ theo trạng thái:")
for st in ["MOI", "XAC_NHAN", "HUY"]:
    count = root.xpath(f"count(//dc:DatCho[dc:TrangThai='{st}'])", namespaces=NS)
    print(f" - {st}: {int(count)}")

print("\n4) Lấy tên hành khách theo mã tài khoản (vd MaTK=6):")
name_for_tk6 = root.xpath("""
    //hk:HanhKhach[hk:MaHK = //tk:TaiKhoan[tk:MaTK='6']/tk:MaHK]/hk:HoTen/text()
""", namespaces=NS)
print(name_for_tk6)

print("\n5) Danh sách sân bay ở Việt Nam:")
vn_airports = root.xpath("//airport:Airport[airport:QuocGia='Việt Nam']/airport:TenSanBay/text()", namespaces=NS)
print(vn_airports)
