#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
إنشاء قاعدة البيانات SQLite لمشروع "مبادرتنا"
تاريخ الإنشاء: مايو 2026
"""

import os
import sqlite3
from pathlib import Path

def create_database():
    """إنشاء قاعدة البيانات SQLite مع جميع الجداول والبيانات التجريبية"""

    # مسار قاعدة البيانات
    db_dir = Path(__file__).parent / 'data'
    db_path = db_dir / 'student_initiatives.db'

    # إنشاء مجلد البيانات إذا لم يكن موجوداً
    db_dir.mkdir(exist_ok=True)

    print(f"🔄 إنشاء قاعدة البيانات في: {db_path}")

    try:
        # الاتصال بقاعدة البيانات
        conn = sqlite3.connect(str(db_path))
        cursor = conn.cursor()

        # تفعيل Foreign Keys
        cursor.execute('PRAGMA foreign_keys = ON')

        # قراءة ملف SQL
        sql_file = Path(__file__).parent / 'database-sqlite.sql'
        if not sql_file.exists():
            print("❌ ملف database-sqlite.sql غير موجود!")
            return False

        with open(sql_file, 'r', encoding='utf-8') as f:
            sql_script = f.read()

        # تنفيذ الـ SQL
        cursor.executescript(sql_script)

        # حفظ التغييرات
        conn.commit()

        # التحقق من الجداول
        cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
        tables = cursor.fetchall()

        print("✅ تم إنشاء الجداول بنجاح:")
        for table in tables:
            cursor.execute(f"SELECT COUNT(*) FROM {table[0]}")
            count = cursor.fetchone()[0]
            print(f"   📋 {table[0]}: {count} سجل")

        # إغلاق الاتصال
        conn.close()

        print(f"\n🎉 قاعدة البيانات جاهزة في: {db_path}")
        print("🚀 يمكنك الآن تشغيل المشروع!")

        return True

    except Exception as e:
        print(f"❌ خطأ في إنشاء قاعدة البيانات: {e}")
        return False

if __name__ == "__main__":
    print("🗄️ إنشاء قاعدة البيانات SQLite لمشروع 'مبادرتنا'")
    print("=" * 50)

    success = create_database()

    if success:
        print("\n📝 الخطوات التالية:")
        print("1. شغّل السيرفر: cd backend && php -S 127.0.0.1:8000")
        print("2. شغّل الواجهة: cd public && python -m http.server 5500")
        print("3. افتح المتصفح: http://127.0.0.1:5500")
    else:
        print("\n❌ فشل في إنشاء قاعدة البيانات!")
        print("تحقق من الأخطاء أعلاه وحاول مرة أخرى.")