# خريطة هيكل مشروع "مبادرتنا"

## نظرة عامة على المشروع
مشروع موقع ويب شامل لمبادرة طلابية يتضمن:
- **الواجهة الأمامية**: HTML, CSS, JavaScript (مع دعم اللغة العربية RTL)
- **الواجهة الخلفية**: PHP REST API + لوحة تحكم Admin
- **قاعدة البيانات**: MySQL

---

## البنية الرئيسية للمشروع

```
Graduation_Project-main/
├── backend/                          # الخادم والـ API
│   ├── api.php                       # نقطة دخول API الرئيسية
│   ├── config.php                    # تحميل متغيرات البيئة
│   ├── database.php                  # اتصال قاعدة البيانات
│   ├── database.sql                  # تعريفات جداول قاعدة البيانات
│   ├── helpers.php                   # دوال مساعدة عامة (Auth, JSON, Validation)
│   ├── .env.example                  # مثال على متغيرات البيئة
│   ├── README.md                     # توثيق الباك إند
│   │
│   ├── admin/                        # لوحة التحكم الإدارية
│   │   ├── index.php                 # الصفحة الرئيسية للإدارة
│   │   ├── login.php                 # صفحة تسجيل الدخول
│   │   ├── logout.php                # تسجيل الخروج
│   │   ├── common.php                # دوال مساعدة للإدارة
│   │   ├── dashboard.php             # لوحة البيانات الرئيسية
│   │   ├── activities.php            # إدارة الأنشطة
│   │   ├── applications.php          # إدارة طلبات الانضمام
│   │   ├── announcements.php         # إدارة الإعلانات
│   │   ├── notifications.php         # إدارة الإشعارات
│   │   ├── gallery.php               # إدارة معرض الصور
│   │   └── reports.php               # إدارة التقارير والإحصائيات
│   │
│   ├── app/                          # (مجلد للاستخدام المستقبلي)
│   │   └── Http/
│   │       └── Controllers/
│   │           └── Api/
│   │
│   ├── database/                     # (مجلد للاستخدام المستقبلي)
│   │   ├── migrations/
│   │   └── seeders/
│   │
│   ├── routes/                       # (مجلد للاستخدام المستقبلي)
│   │
│   └── uploads/                      # مجلد رفع الملفات والصور
│
├── Graduation_Project-main/          # الواجهة الأمامية (Frontend)
│   ├── index.html                    # الصفحة الرئيسية
│   ├── activity.html                 # صفحة تفاصيل النشاط
│   │
│   ├── css/
│   │   ├── style.css                 # أنماط رئيسية (مشترك)
│   │   └── activity.css              # أنماط صفحة النشاط
│   │
│   ├── js/
│   │   ├── api.js                    # دوال API (apiGet, apiPost)
│   │   ├── main.js                   # سكريبت الصفحة الرئيسية
│   │   ├── activity.js               # سكريبت صفحة النشاط
│   │   └── activities-data.js        # بيانات الأنشطة الثابتة
│   │
│   └── images/                       # صور المشروع
│       ├── about_page/               # صور صفحة عن المبادرة
│       ├── page/                     # صور عامة
│       ├── page2/                    # صور إضافية
│       └── page_laste/               # صور أخيرة
│
├── .hintrc                           # إعدادات HTML validation
├── .gitignore                        # ملفات يتم تجاهلها في Git
├── PROJECT_STRUCTURE.md              # (هذا الملف)
├── DATABASE_SCHEMA.md                # خريطة قاعدة البيانات
└── README.md                         # توثيق المشروع الرئيسي

```

---

## وصف الملفات والمجلدات الرئيسية

### الباك إند (Backend)

#### `api.php` (نقطة الدخول الرئيسية)
- معالج موجهات API REST
- دعم الـ CORS
- المسارات المدعومة:
  - `POST /auth/login` - تسجيل الدخول
  - `GET /auth/me` - بيانات المستخدم الحالي
  - `POST /auth/logout` - تسجيل الخروج
  - `GET /activities` - الحصول على الأنشطة
  - `GET /activities/:id` - تفاصيل نشاط
  - وغيرها...

#### `database.php`
- إنشاء اتصال PDO مع MySQL
- إعدادات UTF8MB4
- استخدام Exception Mode للأخطاء

#### `helpers.php`
- `sendJson()` - إرسال استجابة JSON
- `currentUser()` - الحصول على بيانات المستخدم
- `requireAdmin()` - التحقق من صلاحيات الإدارة
- `passwordMatches()` - التحقق من كلمات المرور
- دوال أخرى للتحقق من البيانات

#### `admin/` (لوحة التحكم)
- صفحات مختلفة لإدارة جوانب المشروع المختلفة
- تحتاج تسجيل دخول إداري
- توفر واجهة لإدارة الأنشطة والإعلانات والتقارير

### الواجهة الأمامية (Frontend)

#### `index.html`
- الصفحة الرئيسية للموقع العام
- أقسام: الرئيسية، عن المبادرة، الأنشطة، فريق العمل، الانضمام

#### `activity.html`
- صفحة تفاصيل نشاط واحد
- يتم تحميل البيانات ديناميكياً عبر JavaScript

#### `js/api.js`
- مكتبة للتواصل مع الـ API
- دوال: `apiGet()`, `apiPost()`
- رابط الـ API: `http://127.0.0.1:8000/api.php`

#### `css/style.css`
- الأنماط الرئيسية
- دعم اللغة العربية (RTL)
- استخدام Gradient و Glass Effect

---

## متطلبات التشغيل

### السيرفر
- **PHP**: 7.4 أو أحدث
- **MySQL**: 5.7 أو أحدث
- **Web Server**: Apache / Nginx

### متغيرات البيئة (.env)
```env
APP_ENV=local
APP_DEBUG=true

DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=student_initiatives
DB_USERNAME=root
DB_PASSWORD=

FRONTEND_URL=http://127.0.0.1:5500
```

### البيانات الأساسية
- قاعدة البيانات: `student_initiatives`
- جداول رئيسية: users, activities, volunteer_applications, announcements, gallery_items, notifications, activity_reports

---

## خطوات التشغيل

### 1. إنشاء قاعدة البيانات
```bash
mysql -u root -p < backend/database.sql
```

### 2. إعداد متغيرات البيئة
```bash
cp backend/.env.example backend/.env
# ثم عدّل القيم حسب بيئتك
```

### 3. تشغيل السيرفر
- **اختيار 1**: Apache (من XAMPP/WAMP)
  - ضع المجلد في `htdocs` أو `www`
  - افتح `http://localhost/Graduation_Project-main`

- **اختيار 2**: PHP Built-in Server
  ```bash
  cd backend
  php -S 127.0.0.1:8000
  ```

### 4. تشغيل الواجهة الأمامية
- افتح الملفات HTML مباشرة أو استخدم Live Server
- أو شغّل سيرفر محلي:
  ```bash
  cd Graduation_Project-main
  python -m http.server 5500
  ```

---

## حالة المشروع ✅

- ✅ هيكل قاعدة البيانات مكتمل
- ✅ API الأساسية مُنفذة
- ✅ لوحة التحكم الإدارية موجودة
- ✅ الواجهة الأمامية مكتملة
- ✅ دعم اللغة العربية
- ✅ نظام المصادقة
- ✅ إدارة الأنشطة والتقارير

---

## الخطوات التالية / التحسينات المستقبلية

- [ ] إضافة نظام سجل تدقيق (Audit Log)
- [ ] تحسين أداء الـ API
- [ ] إضافة اختبارات وحدة (Unit Tests)
- [ ] نشر على خادم الإنتاج
- [ ] تحسين واجهة المستخدم
- [ ] إضافة نظام البريد الإلكتروني
- [ ] نظام الصور المتقدم (Thumbnail, CDN)

---

تم الإنشاء: مايو 2026
