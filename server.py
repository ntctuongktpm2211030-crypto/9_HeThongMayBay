# server.py - Chạy localhost + mở trình duyệt tự động
import http.server
import socketserver
import webbrowser
import threading
import time
import os
from lxml import etree

# CẤU HÌNH
PORT = 8000
XML_FILE = "CombinedAirlineSystem.xml"
XSLT_FILE = "airline_queries.xslt"  # File XSLT bạn đã có
HTML_OUTPUT = "index.html"

# Tạo file HTML tạm (chạy XSLT trước)
def generate_html():
    try:
        print("Đang đọc XML và XSLT...")
        xml = etree.parse(XML_FILE)
        xslt = etree.parse(XSLT_FILE)
        transform = etree.XSLT(xslt)
        result = transform(xml)

        print("Đang tạo file HTML...")
        with open(HTML_OUTPUT, "w", encoding="utf-8") as f:
            f.write(str(result))
        print(f"HOÀN TẤT! File: {HTML_OUTPUT}")
    except Exception as e:
        print(f"LỖI: {e}")
        with open(HTML_OUTPUT, "w", encoding="utf-8") as f:
            f.write(f"<h1>LỖI: {e}</h1>")

# Tạo HTML trước
generate_html()

# Chạy server
Handler = http.server.SimpleHTTPRequestHandler

def start_server():
    os.chdir(os.path.dirname(os.path.abspath(__file__)))  # Đảm bảo đúng thư mục
    with socketserver.TCPServer(("", PORT), Handler) as httpd:
        url = f"http://localhost:{PORT}/{HTML_OUTPUT}"
        print(f"\nSERVER ĐANG CHẠY TẠI: {url}")
        print("Nhấn Ctrl+C để dừng\n")
        # Mở trình duyệt sau 1 giây
        threading.Thread(target=lambda: [time.sleep(1), webbrowser.open(url)]).start()
        httpd.serve_forever()

# BẮT ĐẦU
if __name__ == "__main__":
    start_server()