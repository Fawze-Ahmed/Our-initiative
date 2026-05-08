# 🗄️ خيار بديل: استخدام SQLite مع الموقع

إذا لم تريد استخدام MySQL على Railway، يمكنك استخدام SQLite وهو أبسط وأسرع للبدء!

---

## ✅ مميزات SQLite:
- ✅ ملف واحد فقط
- ✅ لا حاجة للسيرفر المنفصل
- ✅ مجاني تماماً
- ✅ مرن وسهل

## ❌ عيوب SQLite:
- ❌ بطيء للتطبيقات الكبيرة
- ❌ لا يدعم متزامن جيد
- ❌ محدود للإنتاج

---

## 🔄 تحويل المشروع إلى SQLite

### الخطوة 1: تحديث `backend/database.php`

```php
<?php

declare(strict_types=1);

require_once __DIR__ . '/config.php';

function db(): PDO
{
    static $pdo = null;

    if ($pdo instanceof PDO) {
        return $pdo;
    }

    // اختيار قاعدة البيانات بناءً على البيئة
    $useDatabase = envValue('DB_DRIVER', 'sqlite');

    if ($useDatabase === 'mysql') {
        // MySQL الإنتاج
        $host = envValue('DB_HOST', '127.0.0.1');
        $port = envValue('DB_PORT', '3306');
        $database = envValue('DB_DATABASE', 'student_initiatives');
        $username = envValue('DB_USERNAME', 'root');
        $password = envValue('DB_PASSWORD', '');

        $dsn = "mysql:host={$host};port={$port};dbname={$database};charset=utf8mb4";
        $pdo = new PDO($dsn, $username, $password);
    } else {
        // SQLite التطوير المحلي
        $dbPath = __DIR__ . '/data/student_initiatives.db';
        
        // إنشاء مجلد البيانات إذا لم يكن موجوداً
        if (!is_dir(dirname($dbPath))) {
            mkdir(dirname($dbPath), 0755, true);
        }
        
        $dsn = "sqlite:{$dbPath}";
        $pdo = new PDO($dsn);
        
        // تفعيل Foreign Keys في SQLite
        $pdo->exec('PRAGMA foreign_keys = ON');
    }

    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);

    return $pdo;
}
```

### الخطوة 2: تحديث `.env`

```env
# للتطوير المحلي (SQLite)
DB_DRIVER=sqlite

# للإنتاج (MySQL)
# DB_DRIVER=mysql
# DB_HOST=your-host.railway.app
# DB_PORT=3306
# DB_DATABASE=student_initiatives
# DB_USERNAME=root
# DB_PASSWORD=your_password
```

### الخطوة 3: تحويل database.sql إلى SQLite

يجب تحويل بعض الأوامر:

```sql
-- 1. حذف IF EXISTS
-- قبل: IF NOT EXISTS
-- بعد: لا تحتاج في SQLite

-- 2. AUTO_INCREMENT يصبح AUTOINCREMENT
-- 3. UNSIGNED INT يصبح INTEGER
-- 4. TINYINT(1) يصبح INTEGER

-- نسخة SQLite من database.sql:
```

### الخطوة 4: إنشاء ملف `backend/database-sqlite.sql`

```sql
-- ===== جداول SQLite =====

CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role TEXT NOT NULL DEFAULT 'student' CHECK(role IN ('admin', 'student')),
    phone VARCHAR(30) DEFAULT NULL,
    college VARCHAR(150) DEFAULT NULL,
    is_active INTEGER NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS activities (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE,
    short_description VARCHAR(500) NOT NULL,
    full_description TEXT NOT NULL,
    image VARCHAR(255) NOT NULL,
    icon VARCHAR(20) DEFAULT NULL,
    color VARCHAR(20) DEFAULT NULL,
    category VARCHAR(100) DEFAULT NULL,
    location VARCHAR(255) DEFAULT NULL,
    starts_at DATETIME DEFAULT NULL,
    ends_at DATETIME DEFAULT NULL,
    max_participants INTEGER NOT NULL DEFAULT 0,
    is_featured INTEGER NOT NULL DEFAULT 0,
    is_active INTEGER NOT NULL DEFAULT 1,
    created_by INTEGER DEFAULT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS volunteer_applications (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    activity_id INTEGER DEFAULT NULL,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL,
    college VARCHAR(150) NOT NULL,
    phone VARCHAR(30) DEFAULT NULL,
    message TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending' CHECK(status IN ('pending', 'approved', 'rejected')),
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (activity_id) REFERENCES activities(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS announcements (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    published_at DATETIME DEFAULT NULL,
    is_important INTEGER NOT NULL DEFAULT 0,
    created_by INTEGER DEFAULT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS gallery_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    activity_id INTEGER DEFAULT NULL,
    title VARCHAR(255) NOT NULL,
    image_path VARCHAR(255) NOT NULL,
    report_excerpt TEXT DEFAULT NULL,
    captured_at DATETIME DEFAULT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (activity_id) REFERENCES activities(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS notifications (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER DEFAULT NULL,
    title VARCHAR(255) NOT NULL,
    body TEXT NOT NULL,
    type VARCHAR(100) DEFAULT 'general',
    is_read INTEGER NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS activity_reports (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    activity_id INTEGER NOT NULL,
    title VARCHAR(255) NOT NULL,
    summary TEXT NOT NULL,
    participants_count INTEGER NOT NULL DEFAULT 0,
    report_date DATE NOT NULL,
    created_by INTEGER DEFAULT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (activity_id) REFERENCES activities(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
);
```

### الخطوة 5: أنشئ script Python لإنشاء السيرفر

```python
# backend/server.py

import http.server
import socketserver
import os

PORT = 8000
os.chdir(os.path.dirname(__file__))

class MyHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/api.php' or self.path.startswith('/api.php/'):
            # نشغّل api.php
            os.system(f'php api.php{self.path}')
        else:
            super().do_GET()

with socketserver.TCPServer(("", PORT), MyHandler):
    print(f'✅ Server running on http://localhost:{PORT}')
    print('Press Ctrl+C to stop')
    socketserver.TCPServer.serve_forever(socketserver.TCPServer)
```

---

## ⚡ تشغيل مع SQLite

### الطريقة 1: استخدام PHP Built-in Server
```bash
cd backend
php -S 127.0.0.1:8000

# في terminal آخر:
cd public
python -m http.server 5500
```

### الطريقة 2: استخدام Python
```bash
cd backend
python server.py

# في terminal آخر:
cd public
python -m http.server 5500
```

---

## 📝 إنشاء قاعدة البيانات SQLite

### الطريقة 1: استخدام sqlite3 CLI
```bash
cd backend/data

# إنشاء قاعدة بيانات جديدة
sqlite3 student_initiatives.db

# ثم داخل sqlite3:
.read database-sqlite.sql
.exit
```

### الطريقة 2: استخدام Python
```python
import sqlite3

conn = sqlite3.connect('backend/data/student_initiatives.db')
cursor = conn.cursor()

with open('backend/database-sqlite.sql', 'r', encoding='utf-8') as f:
    sql_script = f.read()
    cursor.executescript(sql_script)

conn.commit()
conn.close()
print("✅ Database created successfully!")
```

---

## ✅ الفوائد:

| الميزة | SQLite | MySQL |
|-------|--------|-------|
| **التثبيت** | سهل جداً ✅ | معقد ❌ |
| **التكلفة** | مجاني ✅ | قد يكون مدفوع ❌ |
| **الأداء (محلي)** | سريع جداً ✅ | أبطأ قليلاً ❌ |
| **الأداء (إنتاج)** | بطيء ❌ | سريع ✅ |
| **التزامن** | محدود ❌ | ممتاز ✅ |

---

## 🎯 متى تستخدم SQLite:

```
✅ للتطوير المحلي
✅ للاختبار السريع
✅ للمشاريع الصغيرة جداً
✅ عندما لا يكون لديك سيرفر

❌ للإنتاج مع عدد كبير من المستخدمين
❌ للتطبيقات التي تحتاج تزامن عالي
❌ للموقع الموثوق للغاية
```

---

## 📞 هل تريد مساعدة؟

اخبرني إذا أردت:
1. نسخة جاهزة من database-sqlite.sql
2. script Python لإنشاء قاعدة البيانات
3. تعديل كود PHP للعمل مع SQLite بشكل كامل
