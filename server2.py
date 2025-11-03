# server.py
import http.server
import socketserver
import webbrowser
import threading
import os
import time

XML_FILE = "CombinedAirlineSystem.xml"
XSLT_FILE = "HTMB_queries.xslt"
HTML_OUTPUT = "index.html"
PORT = 8000

def generate_html():
    """Chạy XSLT tạo file HTML_OUTPUT"""
    try:
        from lxml import etree
    except ImportError:
        print("❌ Chưa cài lxml. Chạy:")
        print("   py -m pip install lxml")
        return False

    if not os.path.exists(XML_FILE):
        print(f"❌ Không tìm thấy file XML: {XML_FILE}")
        return False
    if not os.path.exists(XSLT_FILE):
        print(f"❌ Không tìm thấy file XSLT: {XSLT_FILE}")
        return False

    print("🔁 Đang đọc XML và XSLT...")
    xml_doc = etree.parse(XML_FILE)
    xslt_doc = etree.parse(XSLT_FILE)
    transform = etree.XSLT(xslt_doc)
    result = transform(xml_doc)

    with open(HTML_OUTPUT, "wb") as f:
        f.write(etree.tostring(result, pretty_print=True, encoding="UTF-8"))

    print(f"✅ Đã tạo {HTML_OUTPUT}")
    return True

class Handler(http.server.SimpleHTTPRequestHandler):
    def log_message(self, format, *args):
        # bớt ồn
        pass

def start_server():
    with socketserver.TCPServer(("", PORT), Handler) as httpd:
      print(f"🌐 Server chạy tại http://localhost:{PORT}")
      httpd.serve_forever()

if __name__ == "__main__":
    ok = generate_html()
    if not ok:
        exit(1)

    # mở browser sau 1s
    def open_browser():
        time.sleep(1)
        webbrowser.open(f"http://localhost:{PORT}/{HTML_OUTPUT}")

    t = threading.Thread(target=open_browser)
    t.daemon = True
    t.start()

    # chạy server
    start_server()
