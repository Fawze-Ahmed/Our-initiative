# 🎓 مشروع مبادرتنا - Our Initiative

مشروع موقع ويب شامل لمبادرة طلابية تهدف إلى تمكين الشباب وتنمية مهاراتهم من خلال الأنشطة والفعاليات المختلفة.

---

## 📋 محتويات المشروع

- **الواجهة الأمامية**: موقع ويب حديث مع دعم اللغة العربية (RTL)
- **الواجهة الخلفية**: API REST مكتوب بـ PHP خام
- **لوحة التحكم**: واجهة إدارية لإدارة الأنشطة والإعلانات والتقارير
- **قاعدة البيانات**: MySQL مع 7 جداول مدمجة

---

## 🚀 متطلبات التشغيل

### المتطلبات الأساسية:
- **PHP**: 7.4 أو أحدث
- **MySQL**: 5.7 أو أحدث
- **Web Server**: Apache / Nginx
- **متصفح**: Chrome, Firefox, Safari, Edge (آخر نسخة)

### أدوات اختيارية:
- **Git**: للتحكم بالإصدارات
- **Composer**: إذا كنت تريد إضافة مكتبات PHP

---

## 📦 التثبيت والإعداد

### الخطوة 1: استنساخ المستودع
```bash
git clone https://github.com/Fawze-Ahmed/Our-initiative.git
cd Our-initiative
```

### الخطوة 2: إنشاء قاعدة البيانات

#### الطريقة 1: استخدام phpMyAdmin
1. افتح `http://localhost/phpmyadmin`
2. أنشئ قاعدة بيانات جديدة باسم `student_initiatives`
3. اختر `UTF8MB4` كـ Collation
4. استورد ملف `backend/database.sql`

#### الطريقة 2: استخدام الـ Command Line
```bash
mysql -u root -p < backend/database.sql
```

### الخطوة 3: إعداد متغيرات البيئة
```bash
# انسخ ملف المثال
cp backend/.env.example backend/.env

# ثم عدّل القيم إذا لزم الأمر
```

**محتويات `.env`:**
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

### الخطوة 4: تشغيل السيرفر

#### الخيار 1: استخدام Apache
1. ضع مجلد المشروع في `htdocs` (في XAMPP) أو `www` (في WAMP)
2. افتح `http://localhost/Graduation_Project-main`

#### الخيار 2: استخدام PHP Built-in Server
```bash
cd backend
php -S 127.0.0.1:8000
```

#### الخيار 3: استخدام Docker (اختياري)
```bash
docker-compose up -d
```

### الخطوة 5: تشغيل الواجهة الأمامية
```bash
# الطريقة 1: استخدام Live Server في VS Code
# فقط اضغط على "Go Live" في الملف HTML

# الطريقة 2: Python
cd Graduation_Project-main
python -m http.server 5500

# الطريقة 3: Node (http-server)
npx http-server Graduation_Project-main -p 5500
```

---

## 📁 هيكل المشروع

```
Graduation_Project-main/
├── backend/                    # الخادم و API
│   ├── api.php                # نقطة دخول API
│   ├── config.php             # إعدادات البيئة
│   ├── database.php           # اتصال قاعدة البيانات
│   ├── database.sql           # تعريفات الجداول
│   ├── helpers.php            # دوال مساعدة
│   ├── .env.example           # متغيرات البيئة
│   ├── admin/                 # لوحة التحكم الإدارية
│   ├── uploads/               # مجلد الملفات المرفوعة
│   └── README.md              # توثيق الباك إند
│
├── Graduation_Project-main/   # الواجهة الأمامية
│   ├── index.html             # الصفحة الرئيسية
│   ├── activity.html          # صفحة تفاصيل النشاط
│   ├── css/                   # أنماط CSS
│   ├── js/                    # ملفات JavaScript
│   ├── images/                # صور الموقع
│   └── ...
│
├── .gitignore                 # ملفات يتم تجاهلها
├── DATABASE_SCHEMA.md         # خريطة قاعدة البيانات
├── PROJECT_STRUCTURE.md       # هيكل المشروع
├── README.md                  # (هذا الملف)
└── ...
```

**للمزيد من التفاصيل:**
- 📘 [خريطة هيكل المشروع](./PROJECT_STRUCTURE.md)
- 🗄️ [خريطة قاعدة البيانات](./DATABASE_SCHEMA.md)

---

## 🔌 API Endpoints

### التحقق والمصادقة
```
POST   /auth/login          - تسجيل الدخول
GET    /auth/me             - بيانات المستخدم الحالي
POST   /auth/logout         - تسجيل الخروج
```

### الأنشطة
```
GET    /activities          - الحصول على جميع الأنشطة
GET    /activities/:id      - تفاصيل نشاط واحد
POST   /activities          - إنشاء نشاط جديد (Admin فقط)
PUT    /activities/:id      - تحديث النشاط (Admin فقط)
DELETE /activities/:id      - حذف النشاط (Admin فقط)
```

### طلبات الانضمام
```
GET    /applications        - الحصول على الطلبات (Admin فقط)
POST   /applications        - تقديم طلب انضمام
PUT    /applications/:id    - تحديث حالة الطلب (Admin فقط)
```

### الإعلانات
```
GET    /announcements       - الحصول على الإعلانات
POST   /announcements       - إنشاء إعلان جديد (Admin فقط)
PUT    /announcements/:id   - تحديث الإعلان (Admin فقط)
DELETE /announcements/:id   - حذف الإعلان (Admin فقط)
```

### الإشعارات
```
GET    /notifications       - الحصول على الإشعارات
POST   /notifications       - إنشاء إشعار (Admin فقط)
```

### التقارير
```
GET    /reports            - الحصول على التقارير (Admin فقط)
POST   /reports            - إنشاء تقرير (Admin فقط)
```

**ملاحظة:** جميع الـ endpoints التي تتطلب Admin تحتاج تسجيل دخول إداري

---

## 🔐 الأمان

### ممارسات الأمان المطبقة:
- ✅ استخدام Prepared Statements لمنع SQL Injection
- ✅ تشفير كلمات المرور
- ✅ التحقق من الجلسات (Sessions)
- ✅ التحقق من صلاحيات الإدارة
- ✅ دعم CORS

### توصيات الأمان:
- ⚠️ استخدم كلمات مرور قوية
- ⚠️ غيّر `APP_DEBUG` إلى `false` في الإنتاج
- ⚠️ استخدم HTTPS في الإنتاج
- ⚠️ قيّد CORS Origins
- ⚠️ استخدم متغيرات بيئة حقيقية

---

## 📝 الملفات الرئيسية

| الملف | الوصف |
|------|-------|
| `backend/api.php` | نقطة دخول API الرئيسية |
| `backend/database.php` | اتصال قاعدة البيانات |
| `backend/config.php` | تحميل متغيرات البيئة |
| `backend/helpers.php` | دوال مساعدة عامة |
| `Graduation_Project-main/index.html` | الصفحة الرئيسية |
| `Graduation_Project-main/js/api.js` | مكتبة الـ API |
| `DATABASE_SCHEMA.md` | خريطة قاعدة البيانات |
| `PROJECT_STRUCTURE.md` | هيكل المشروع |

---

## 🐛 استكشاف الأخطاء

### المشكلة: "Connection refused"
**الحل:**
- تأكد من تشغيل MySQL و Apache/Nginx
- تحقق من قيم `DB_HOST` و `DB_PORT` في `.env`

### المشكلة: "Database not found"
**الحل:**
- استورد ملف `backend/database.sql`
- تحقق من اسم قاعدة البيانات

### المشكلة: "API returns 404"
**الحل:**
- تحقق من أن السيرفر يعمل على `http://127.0.0.1:8000`
- تحقق من المسار المطلوب

### المشكلة: "CORS Error"
**الحل:**
- يجب أن يكون الـ Frontend على port مختلف من الـ Backend
- تحقق من إعدادات CORS في `backend/helpers.php`

---

## 🎨 التقنيات المستخدمة

### الواجهة الأمامية:
- HTML5
- CSS3 (Flexbox, Grid, Gradient)
- Vanilla JavaScript (ES6+)
- Google Fonts (Cairo)

### الواجهة الخلفية:
- PHP 7.4+
- MySQL / PDO
- REST API

### أدوات الإنتاج:
- Git / GitHub
- Apache / Nginx
- Docker (اختياري)

---

## 📞 التواصل والدعم

- **البريد الإلكتروني**: [your-email@example.com]
- **GitHub Issues**: [Report Issues](https://github.com/Fawze-Ahmed/Our-initiative/issues)
- **GitHub Discussions**: [Discussions](https://github.com/Fawze-Ahmed/Our-initiative/discussions)

---

## 📄 الترخيص

هذا المشروع مرخص تحت رخصة MIT - انظر ملف [LICENSE](./LICENSE) للتفاصيل.

---

## 🙏 شكر خاص

شكر خاص لجميع المساهمين والدعم المستمر للمشروع.

---

## 📈 الإحصائيات

- **الجداول**: 7
- **الحقول الكلية**: 60+
- **صفحات**: 2
- **API Endpoints**: 20+
- **أسطر الكود**: 2000+

---

## 🗺️ خريطة الطريق

### مكتمل ✅
- [x] هيكل قاعدة البيانات
- [x] API الأساسية
- [x] لوحة التحكم الإدارية
- [x] الواجهة الأمامية
- [x] نظام المصادقة

### قيد التطوير 🔄
- [ ] نظام الحجوزات المتقدم
- [ ] تحسينات الأداء
- [ ] إضافة اختبارات وحدة

### مخطط له 📋
- [ ] تطبيق موبايل
- [ ] نظام البريد الإلكتروني
- [ ] نظام الدفع
- [ ] النسخ الاحتياطي التلقائية

---

## 📚 الموارد والمراجع

- [PHP Documentation](https://www.php.net/docs.php)
- [MySQL Documentation](https://dev.mysql.com/doc/)
- [MDN Web Docs](https://developer.mozilla.org/)
- [REST API Best Practices](https://restfulapi.net/)

---

**تم الإنشاء:** مايو 2026  
**آخر تحديث:** مايو 2026  
**الإصدار:** 1.0.0
