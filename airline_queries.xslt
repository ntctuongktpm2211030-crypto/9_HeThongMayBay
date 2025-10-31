<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ns="http://example.com/combined"
                exclude-result-prefixes="ns">
  
  <xsl:output method="html" encoding="UTF-8" indent="yes" doctype-system="about:legacy-compat"/>
  

  <xsl:template match="/ns:CombinedAirlineSystem">
    <html lang="vi">
      <head>
        <meta charset="UTF-8"/>
        <title>Báo Cáo Truy Vấn Hệ Thống Hàng Không</title>
        <style>
          body { font-family: Arial, sans-serif; margin: 30px; background: #f9f9f9; color: #333; }
          h1 { text-align: center; color: #2c3e50; }
          h2 { color: #2980b9; border-bottom: 2px solid #3498db; padding-bottom: 8px; margin-top: 40px; }
          table { width: 100%; border-collapse: collapse; margin: 15px 0; background: white; }
          th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
          th { background-color: #3498db; color: white; font-weight: 600; }
          tr:nth-child(even) { background-color: #f2f2f2; }
          tr:hover { background-color: #f0f8ff; }
          .no-data { color: #e74c3c; font-style: italic; }
          .footer { text-align: center; margin-top: 50px; color: #7f8c8d; font-size: 0.9em; }
        </style>
      </head>
      <body>
        <h1>HỆ THỐNG HÀNG KHÔNG - BÁO CÁO TRUY VẤN</h1>
        
        <!-- CÂU 1: Thông tin KH 105 -->
        <h2>Câu 1: Liệt kê thông tin của mã khách hàng 105 (họ tên, địa chỉ, số điện thoại, email)</h2>
        <table>
          <tr><th>Thông tin</th><th>Chi tiết</th></tr>
          <xsl:apply-templates select="ns:DanhSachHanhKhach/ns:HanhKhach[ns:MaHK='105']" mode="q1"/>
        </table>
        
        <!-- CÂU 2: Tất cả mã chuyến bay -->
        <h2>Câu 2: Liệt kê tất cả mã chuyến bay</h2>
        <table>
          <tr><th>STT</th><th>Mã chuyến bay</th></tr>
          <xsl:apply-templates select="ns:Flights/ns:Flight" mode="q2"/>
        </table>
        
        <!-- CÂU 3: KH có ghế Economy -->
        <h2>Câu 3: Thống kê các mã khách hàng có hạng ghế là Economy</h2>
        <table>
          <tr><th>Mã HK</th><th>Họ tên</th><th>Số ghế</th></tr>
          <xsl:apply-templates select="ns:TicketDetails/ns:TicketDetail[ns:HangGhe='Economy']" mode="q3">
            <xsl:sort select="ns:MaHK" data-type="number"/>
          </xsl:apply-templates>
        </table>
        
        <!-- CÂU 4: Tài khoản hành khách 107 -->
        <h2>Câu 4: Hiển thị mã tài khoản, tên đăng nhập, mật khẩu của hành khách 107</h2>
        <table>
          <tr><th>Thông tin</th><th>Chi tiết</th></tr>
          <xsl:apply-templates select="ns:DanhSachTaiKhoan/ns:TaiKhoan[ns:MaHK='107']" mode="q4"/>
        </table>
        
        <!-- CÂU 5: Hành khách sinh năm 1998 -->
        <h2>Câu 5: Lấy họ tên của hành khách có năm sinh là 1998</h2>
        <table>
          <tr><th>STT</th><th>Họ tên</th><th>Ngày sinh</th></tr>
          <xsl:apply-templates select="ns:DanhSachHanhKhach/ns:HanhKhach[starts-with(ns:NgaySinh, '1998')]" mode="q5">
            <xsl:sort select="ns:HoTen"/>
          </xsl:apply-templates>
        </table>
        
        <div class="footer">
          Báo cáo được tạo bằng XSLT • Dữ liệu từ CombinedAirlineSystem.xml
        </div>
      </body>
    </html>
  </xsl:template>
  
  <!-- ================== CÁC TEMPLATE CHO TỪNG CÂU ================== -->
  
  <!-- Câu 1 -->
  <xsl:template match="ns:HanhKhach" mode="q1">
    <tr><td>Họ tên</td><td><xsl:value-of select="ns:HoTen"/></td></tr>
    <tr><td>Địa chỉ</td><td class="no-data">Không có dữ liệu</td></tr>
    <tr><td>Số điện thoại</td><td><xsl:value-of select="ns:DienThoai"/></td></tr>
    <tr><td>Email</td><td><xsl:value-of select="ns:Email"/></td></tr>
  </xsl:template>
  
  <!-- Câu 2 -->
  <xsl:template match="ns:Flight" mode="q2">
    <tr>
      <td><xsl:value-of select="position()"/></td>
      <td><xsl:value-of select="ns:MaChuyenBay"/></td>
    </tr>
  </xsl:template>
  
  <!-- Câu 3 -->
  <xsl:template match="ns:TicketDetail" mode="q3">
    <xsl:variable name="maHK" select="ns:MaHK"/>
    <xsl:variable name="ten" select="//ns:HanhKhach[ns:MaHK=$maHK]/ns:HoTen"/>
    <tr>
      <td><xsl:value-of select="$maHK"/></td>
      <td><xsl:value-of select="$ten"/></td>
      <td><xsl:value-of select="ns:SoGhe"/></td>
    </tr>
  </xsl:template>
  
  <!-- Câu 4 -->
  <xsl:template match="ns:TaiKhoan" mode="q4">
    <tr><td>Mã tài khoản</td><td><xsl:value-of select="ns:MaTK"/></td></tr>
    <tr><td>Tên đăng nhập</td><td><xsl:value-of select="ns:TenDangNhap"/></td></tr>
    <tr><td>Mật khẩu</td><td><xsl:value-of select="ns:MatKhau"/></td></tr>
  </xsl:template>
  
  <!-- Câu 5 -->
  <xsl:template match="ns:HanhKhach" mode="q5">
    <tr>
      <td><xsl:value-of select="position()"/></td>
      <td><xsl:value-of select="ns:HoTen"/></td>
      <td><xsl:value-of select="ns:NgaySinh"/></td>
    </tr>
  </xsl:template>
  
</xsl:stylesheet>