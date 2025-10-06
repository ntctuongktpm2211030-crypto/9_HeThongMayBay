#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os
import argparse
from typing import Optional, Dict, Tuple

try:
    from lxml import etree
except ImportError:
    sys.stderr.write("Missing dependency: lxml. Cài bằng: pip install lxml\n")
    raise

def _fmt_log_entry(err: etree._LogEntry) -> str:
    return f"[{err.level_name}] L{err.line}:C{err.column} - {err.message}"

def validate_with_xsd(xml_path: str, xsd_path: str, strict: bool=False) -> bool:
    try:
        with open(xsd_path, "rb") as f:
            schema_doc = etree.parse(f)
        schema = etree.XMLSchema(schema_doc)
    except (OSError, etree.XMLSchemaParseError) as e:
        sys.stderr.write(f"Không tải được XSD: {xsd_path}\n{e}\n")
        return False

    try:
        with open(xml_path, "rb") as f:
            xml_doc = etree.parse(f)
        if strict:
            schema.assertValid(xml_doc)
            return True
        ok = schema.validate(xml_doc)
        if not ok:
            sys.stderr.write("❌ XSD validation failed:\n")
            for err in schema.error_log:
                sys.stderr.write("  " + _fmt_log_entry(err) + "\n")
        return ok
    except etree.XMLSyntaxError as e:
        sys.stderr.write("❌ XML không hợp lệ về cú pháp:\n")
        for err in e.error_log:
            sys.stderr.write("  " + _fmt_log_entry(err) + "\n")
        return False

def validate_with_dtd(xml_path: str, dtd_path: Optional[str], strict: bool=False) -> bool:
    try:
        if dtd_path:
            with open(dtd_path, "rb") as f:
                dtd = etree.DTD(f)
            with open(xml_path, "rb") as f:
                xml_doc = etree.parse(f)
            ok = dtd.validate(xml_doc)
            if not ok:
                sys.stderr.write("❌ DTD validation failed:\n")
                for err in dtd.error_log:
                    sys.stderr.write("  " + _fmt_log_entry(err) + "\n")
            return ok
        else:
            parser = etree.XMLParser(dtd_validation=True, load_dtd=True)
            with open(xml_path, "rb") as f:
                etree.parse(f, parser)
            return True
    except (OSError, etree.DTDParseError) as e:
        sys.stderr.write(f"Không tải được DTD hoặc XML: {e}\n")
        return False
    except etree.XMLSyntaxError as e:
        sys.stderr.write("❌ DTD/XPath syntax error khi parse:\n")
        for err in e.error_log:
            sys.stderr.write("  " + _fmt_log_entry(err) + "\n")
        return False

def _split_qname(tag) -> Tuple[Optional[str], str]:
    """Nhận cả str hoặc non-str (comment/PI). Trả (ns_uri, local)."""
    if not isinstance(tag, str):
        return None, ""
    if tag.startswith("{"):
        uri, local = tag[1:].split("}", 1)
        return uri, local
    return None, tag

def validate_dataset(xml_path: str, ns_to_xsd: Dict[str, str], strict: bool=False) -> bool:
    try:
        with open(xml_path, "rb") as f:
            doc = etree.parse(f)
    except etree.XMLSyntaxError as e:
        sys.stderr.write("❌ XML không hợp lệ về cú pháp:\n")
        for err in e.error_log:
            sys.stderr.write("  " + _fmt_log_entry(err) + "\n")
        return False
    except OSError as e:
        sys.stderr.write(f"Không mở được file XML: {e}\n")
        return False

    # Load schemas theo namespace
    schemas: Dict[str, etree.XMLSchema] = {}
    for ns_uri, xsd_path in ns_to_xsd.items():
        try:
            with open(xsd_path, "rb") as f:
                schemas[ns_uri] = etree.XMLSchema(etree.parse(f))
        except (OSError, etree.XMLSchemaParseError) as e:
            sys.stderr.write(f"Không load được XSD cho ns '{ns_uri}': {e}\n")
            return False

    is_all_valid = True
    root = doc.getroot()

    # Chỉ lặp ELEMENT con trực tiếp; bỏ qua comment/PI/text
    for child in root.findall("*"):
        ns_uri, local = _split_qname(child.tag)
        label = f"{{{ns_uri}}}{local}" if ns_uri else local
        if ns_uri is None:
            sys.stderr.write(f"⚠️ Bỏ qua phần tử top-level không có namespace: {label}\n")
            continue

        schema = schemas.get(ns_uri)
        if not schema:
            sys.stderr.write(f"❌ Không có XSD cho namespace: {ns_uri} (element {local})\n")
            is_all_valid = False
            continue

        # Validate element như một document riêng
        try:
            if strict:
                schema.assertValid(child)
                sys.stdout.write(f"✅ Section hợp lệ: {label}\n")
            else:
                ok = schema.validate(child)
                if ok:
                    sys.stdout.write(f"✅ Section hợp lệ: {label}\n")
                else:
                    is_all_valid = False
                    sys.stderr.write(f"❌ Section không hợp lệ: {label}\n")
                    for err in schema.error_log:
                        sys.stderr.write("  " + _fmt_log_entry(err) + "\n")
        except etree.DocumentInvalid as e:
            is_all_valid = False
            sys.stderr.write(f"❌ Section không hợp lệ (strict): {label}\n")
            for err in e.error_log:
                sys.stderr.write("  " + _fmt_log_entry(err) + "\n")

    return is_all_valid

def build_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(
        prog="validate_xml.py",
        description="Validate XML bằng XSD/DTD hoặc dataset nhiều-namespace."
    )
    sub = p.add_subparsers(dest="cmd", required=True)

    px = sub.add_parser("xsd", help="Validate XML với XSD")
    px.add_argument("schema_xsd")
    px.add_argument("document_xml")
    px.add_argument("--strict", action="store_true", help="Dùng assertValid (ném exception)")

    pd = sub.add_parser("dtd", help="Validate XML với DTD (file DTD hoặc DOCTYPE nội bộ)")
    pd.add_argument("arg1", help="schema.dtd hoặc document.xml nếu dùng DOCTYPE nội bộ")
    pd.add_argument("document_xml", nargs="?", help="document.xml (khi có schema.dtd)")
    pd.add_argument("--strict", action="store_true", help="(để đồng bộ giao diện)")

    pds = sub.add_parser("dataset", help="Validate nhiều namespace (nsUri=xsdPath ...)")
    pds.add_argument("document_xml")
    pds.add_argument("mappings", nargs="+", help="nsUri=xsdPath")
    pds.add_argument("--strict", action="store_true")

    pa = sub.add_parser("auto", help="Tự phát hiện theo đuôi (.xsd/.dtd)")
    pa.add_argument("schema")
    pa.add_argument("document_xml")
    pa.add_argument("--strict", action="store_true")

    return p

def main(argv=None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)

    def _must_exist(path: str) -> bool:
        if not os.path.exists(path):
            sys.stderr.write(f"Không tìm thấy file: {path}\n")
            return False
        return True

    if args.cmd == "xsd":
        if not (_must_exist(args.schema_xsd) and _must_exist(args.document_xml)):
            return 2
        ok = validate_with_xsd(args.document_xml, args.schema_xsd, strict=args.strict)
        sys.stdout.write("Valid\n" if ok else "Invalid\n")
        return 0 if ok else 1

    if args.cmd == "dtd":
        if args.document_xml is None:
            if not _must_exist(args.arg1):
                return 2
            ok = validate_with_dtd(args.arg1, None, strict=args.strict)
        else:
            if not (_must_exist(args.arg1) and _must_exist(args.document_xml)):
                return 2
            ok = validate_with_dtd(args.document_xml, args.arg1, strict=args.strict)
        sys.stdout.write("Valid\n" if ok else "Invalid\n")
        return 0 if ok else 1

    if args.cmd == "dataset":
        if not _must_exist(args.document_xml):
            return 2
        ns_to_xsd: Dict[str, str] = {}
        for m in args.mappings:
            if "=" not in m:
                sys.stderr.write(f"Mapping không hợp lệ (nsUri=xsdPath): {m}\n")
                return 2
            ns_uri, xsd_path = m.split("=", 1)
            ns_to_xsd[ns_uri] = xsd_path
        for x in ns_to_xsd.values():
            if not _must_exist(x):
                return 2
        ok = validate_dataset(args.document_xml, ns_to_xsd, strict=args.strict)
        sys.stdout.write("Valid\n" if ok else "Invalid\n")
        return 0 if ok else 1

    if args.cmd == "auto":
        if not (_must_exist(args.schema) and _must_exist(args.document_xml)):
            return 2
        ext = os.path.splitext(args.schema.lower())[1]
        if ext == ".xsd":
            ok = validate_with_xsd(args.document_xml, args.schema, strict=args.strict)
        elif ext == ".dtd":
            ok = validate_with_dtd(args.document_xml, args.schema, strict=args.strict)
        else:
            sys.stderr.write("Không nhận dạng được loại schema (chỉ .xsd hoặc .dtd)\n")
            return 2
        sys.stdout.write("Valid\n" if ok else "Invalid\n")
        return 0 if ok else 1

    parser.print_help()
    return 2

if __name__ == "__main__":
    raise SystemExit(main())
