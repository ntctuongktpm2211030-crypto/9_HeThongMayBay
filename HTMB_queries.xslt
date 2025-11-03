<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:c="http://example.com/combined"
  xmlns:airport="http://example.com/airportsystem"
  xmlns:airline="http://example.com/airline"
  xmlns:dc="http://example.com/datcho"
  xmlns:hk="http://example.com/hanhkhach"
  xmlns:kg="http://example.com/kigui"
  xmlns:tk="http://example.com/taikhoan"
  exclude-result-prefixes="c airport airline dc hk kg tk">
  
  <xsl:output method="html" indent="yes" encoding="UTF-8"/>
  
  <!-- Trang chính -->
  <xsl:template match="/c:CombinedAirlineSystem">
    <html lang="vi">
      <head>
        <meta charset="UTF-8" />
        <title>Hệ thống vé máy bay - XML → HTML</title>
        <style>
          body { font-family: Arial, sans-serif; margin: 0; background: #f3f4f6; }
          header { background: #0f172a; color: #fff; padding: 1rem 2rem; }
          h1 { margin: 0; font-size: 1.4rem; }
          .container { padding: 1.5rem 2rem; }
          h2 { margin-top: 2rem; margin-bottom: .5rem; color: #0f172a; }
          table { border-collapse: collapse; width: 100%; background: #fff; margin-bottom: 1rem; }
          th, td { border: 1px solid #e2e8f0; padding: .5rem .6rem; font-size: .9rem; }
          th { background: #e2e8f0; text-align: left; }
          .badge { display: inline-block; padding: 2px 6px; border-radius: 4px; font-size: .7rem; }
          .badge-new { background: #0ea5e9; color: #fff; }
          .badge-ok { background: #16a34a; color: #fff; }
          .badge-cancel { background: #dc2626; color: #fff; }
          .small { font-size: .75rem; color: #64748b; }
          nav { margin-bottom: 1rem; }
          nav a { margin-right: .7rem; color: #0f172a; text-decoration: none; font-weight: 600; }
          nav a:hover { text-decoration: underline; }
          section { scroll-margin-top: 4rem; }
        </style>
      </head>
      <body>
        <header>
          <h1>Hệ thống vé máy bay – BÁO CÁO TRUY VẤN</h1>
          <div class="small">Nguồn: CombinedAirlineSystem.xml</div>
        </header>
        <div class="container">
          <nav>
            <a href="#airports">Sân bay</a>
            <a href="#routes">Tuyến bay</a>
            <a href="#flights">Chuyến bay</a>
            <a href="#passengers">Hành khách</a>
            <a href="#bookings">Đặt chỗ</a>
            <a href="#tickets">Chi tiết vé</a>
          </nav>
          
          <!-- 1. Sân bay -->
          <section id="airports">
            <h2>1. Danh sách sân bay</h2>
            <table>
              <tr>
                <th>Mã</th>
                <th>Tên sân bay</th>
                <th>Thành phố</th>
                <th>Quốc gia</th>
                <th>IATA</th>
              </tr>
              <!-- <xsl:for-each select="airport:Airports/airport:Airport"> -->
                <!-- <xsl:for-each select="airport:Airports/airport:Airport[airport:QuocGia='Việt Nam']"> -->
              <xsl:for-each select="airport:Airports/airport:Airport[number(airport:MaSanBay) &lt; 5]"> 
              <!-- <xsl:for-each select="airport:Airports/airport:Airport[number(airport:MaSanBay) &gt;= 3 and number(airport:MaSanBay) &lt;= 6]"> trông khoảng-->
              <!-- <xsl:for-each select="airport:Airports/airport:Airport[
                  airport:QuocGia='Việt Nam'
                  and airport:ThanhPho='TP. Hồ Chí Minh'
                ]"> -->
              <!-- <xsl:for-each select="airport:Airports/airport:Airport[starts-with(airport:MaIATA, 'S')]"> bắt đầu là S-->

                <!-- <xsl:if test="airport:QuocGia='Việt Nam'"> -->
                <tr>
                  <td><xsl:value-of select="airport:MaSanBay"/></td>
                  <td><xsl:value-of select="airport:TenSanBay"/></td>
                  <td><xsl:value-of select="airport:ThanhPho"/></td>
                  <td><xsl:value-of select="airport:QuocGia"/></td>
                  <td><xsl:value-of select="airport:MaIATA"/></td>
                </tr>
                <!-- </xsl:if> -->
              </xsl:for-each>
            </table>
          </section>
          
          <!-- 2. Tuyến bay -->
          <section id="routes">
            <h2>2. Tuyến bay</h2>
            <table>
              <tr>
                <th>Mã tuyến</th>
                <th>Đi</th>
                <th>Đến</th>
                <th>Khoảng cách (km)</th>
              </tr>
              <!-- <xsl:for-each select="airport:Routes/airport:Route"> -->
                <!-- <xsl:for-each select="airport:Routes/airport:Route[airport:MaSanBayDi='1']"> -->
              <xsl:for-each select="airport:Routes/airport:Route[number(airport:KhoangCach) &gt; 2500]">
              <!-- <xsl:for-each select="airport:Routes/airport:Route[
                  number(airport:KhoangCach) &gt;= 1000
                  and number(airport:KhoangCach) &lt;= 3000
                ]"> -->
                <tr>
                  <td><xsl:value-of select="airport:MaTuyenBay"/></td>
                  <td>
                    <xsl:value-of select="airport:MaSanBayDi"/>
                    <span class="small">(
                      <xsl:value-of select="/c:CombinedAirlineSystem/airport:Airports/airport:Airport[airport:MaSanBay=current()/airport:MaSanBayDi]/airport:MaIATA"/>
                      )</span>
                  </td>
                  <td>
                    <xsl:value-of select="airport:MaSanBayDen"/>
                    <span class="small">(
                      <xsl:value-of select="/c:CombinedAirlineSystem/airport:Airports/airport:Airport[airport:MaSanBay=current()/airport:MaSanBayDen]/airport:MaIATA"/>
                      )</span>
                  </td>
                  <td><xsl:value-of select="airport:KhoangCach"/></td>
                </tr>
              </xsl:for-each>
            </table>
          </section>
          
          <!-- 3. Chuyến bay -->
          <section id="flights">
            <h2>3. Chuyến bay</h2>
            <table>
              <tr>
                <th>Mã CB</th>
                <th>Số hiệu</th>
                <th>Tuyến</th>
                <th>Giờ đi</th>
                <th>Giờ đến</th>
                <th>Máy bay</th>
                <th>Sức chứa</th>
              </tr>
              <!-- <xsl:for-each select="airport:Flights/airport:Flight"> -->
              <xsl:for-each select="airport:Flights/airport:Flight[number(airport:SucChua) &gt; 200]">
              <!-- <xsl:for-each select="airport:Flights/airport:Flight[
                  airport:MauMaybay='Airbus A350'
                  and number(airport:SucChua) &gt;= 200
                ]"> -->
                <tr>
                  <td><xsl:value-of select="airport:MaChuyenBay"/></td>
                  <td><xsl:value-of select="airport:SoHieu"/></td>
                  <td>
                    <xsl:value-of select="airport:MaTuyenBay"/>
                    <span class="small">
                      -
                      <xsl:value-of select="/c:CombinedAirlineSystem/airport:Routes/airport:Route[airport:MaTuyenBay=current()/airport:MaTuyenBay]/airport:MaSanBayDi"/>
                      →
                      <xsl:value-of select="/c:CombinedAirlineSystem/airport:Routes/airport:Route[airport:MaTuyenBay=current()/airport:MaTuyenBay]/airport:MaSanBayDen"/>
                    </span>
                  </td>
                  <td><xsl:value-of select="airport:GioDi"/></td>
                  <td><xsl:value-of select="airport:GioDen"/></td>
                  <td><xsl:value-of select="airport:MauMaybay"/></td>
                  <td><xsl:value-of select="airport:SucChua"/></td>
                </tr>
              </xsl:for-each>
            </table>
          </section>
          
          <!-- 4. Hành khách -->
          <section id="passengers">
            <h2>4. Hành khách</h2>
            <table>
              <tr>
                <th>Mã HK</th>
                <th>Họ tên</th>
                <th>Ngày sinh</th>
                <th>Email</th>
                <th>Hộ chiếu</th>
              </tr>
              <!-- <xsl:for-each select="hk:DanhSachHanhKhach/hk:HanhKhach"> -->
              <!-- <xsl:for-each select="hk:DanhSachHanhKhach/hk:HanhKhach[starts-with(hk:NgaySinh, '2000')]"> -->
              <xsl:for-each select="hk:DanhSachHanhKhach/hk:HanhKhach[contains(hk:HoTen, 'Nguyễn')]">
                <tr>
                  <td><xsl:value-of select="hk:MaHK"/></td>
                  <td><xsl:value-of select="hk:HoTen"/></td>
                  <td><xsl:value-of select="hk:NgaySinh"/></td>
                  <td><xsl:value-of select="hk:Email"/></td>
                  <td><xsl:value-of select="hk:SoHoChieu"/></td>
                </tr>
              </xsl:for-each>
            </table>
          </section>
          
          <!-- 5. Đặt chỗ -->
          <section id="bookings">
            <h2>5. Đặt chỗ</h2>
            <table>
              <tr>
                <th>Mã DC</th>
                <th>Tài khoản</th>
                <th>Chuyến bay</th>
                <th>PNR</th>
                <th>Ngày đặt</th>
                <th>Trạng thái</th>
                <th>Tổng tiền</th>
              </tr>
              <!-- <xsl:for-each select="dc:DanhSachDatCho/dc:DatCho"> -->
              <!-- <xsl:for-each select="dc:DanhSachDatCho/dc:DatCho[dc:TrangThai='XAC_NHAN']"> -->
              <xsl:for-each select="dc:DanhSachDatCho/dc:DatCho[number(dc:TongTien) &gt; 5000000]">
                <tr>
                  <td><xsl:value-of select="dc:MaDatCho"/></td>
                  <td>
                    <xsl:value-of select="dc:MaTK"/>
                    <span class="small">
                      (
                      <xsl:value-of select="/c:CombinedAirlineSystem/tk:DanhSachTaiKhoan/tk:TaiKhoan[tk:MaTK=current()/dc:MaTK]/tk:TenDangNhap"/>
                      )
                    </span>
                  </td>
                  <td><xsl:value-of select="dc:MaChuyenBay"/></td>
                  <td><xsl:value-of select="dc:MaPNR"/></td>
                  <td><xsl:value-of select="dc:NgayDat"/></td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="dc:TrangThai='XAC_NHAN'">
                        <span class="badge badge-ok">XÁC NHẬN</span>
                      </xsl:when>
                      <xsl:when test="dc:TrangThai='HUY'">
                        <span class="badge badge-cancel">HỦY</span>
                      </xsl:when>
                      <xsl:otherwise>
                        <span class="badge badge-new"><xsl:value-of select="dc:TrangThai"/></span>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td><xsl:value-of select="dc:TongTien"/></td>
                </tr>
              </xsl:for-each>
            </table>
          </section>
          
          <!-- 6. Chi tiết vé -->
          <section id="tickets">
            <h2>6. Chi tiết vé</h2>
            <table>
              <tr>
                <th>Mã vé</th>
                <th>Mã đặt chỗ</th>
                <th>Hành khách</th>
                <th>Hạng ghế</th>
                <th>Số ghế</th>
                <th>Thành tiền</th>
                <th>TT thanh toán</th>
              </tr>
              <!-- <xsl:for-each select="airline:TicketDetails/airline:TicketDetail"> -->
              <xsl:for-each select="airline:TicketDetails/airline:TicketDetail[airline:HangGhe='Business']">
                <tr>
                  <td><xsl:value-of select="airline:MaVe"/></td>
                  <td><xsl:value-of select="airline:MaDatCho"/></td>
                  <td>
                    <xsl:variable name="hkId" select="tk:MaHK"/>
                    <xsl:value-of select="/c:CombinedAirlineSystem/hk:DanhSachHanhKhach/hk:HanhKhach[hk:MaHK=$hkId]/hk:HoTen"/>
                    <span class="small"> (HK: <xsl:value-of select="$hkId"/>)</span>
                  </td>
                  <td><xsl:value-of select="airline:HangGhe"/></td>
                  <td><xsl:value-of select="airline:SoGhe"/></td>
                  <td><xsl:value-of select="airline:ThanhTien"/></td>
                  <td><xsl:value-of select="dc:TrangThai"/></td>
                </tr>
                  
              </xsl:for-each>
            </table>
          </section>
          
        </div>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
