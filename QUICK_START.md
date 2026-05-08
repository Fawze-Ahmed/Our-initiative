# 🚀 دليل تشغيل المشروع - مبادرتنا

## ✅ قاعدة البيانات جاهزة!

تم إنشاء قاعدة البيانات SQLite بنجاح مع البيانات التجريبية.

### 📊 البيانات المتاحة:
- 👤 **مستخدم إداري**: admin@initiative.com
- 🏃‍♂️ **3 أنشطة** جاهزة
- 📢 **2 إعلان**
- 🖼️ **2 صورة** في المعرض

---

## 🎯 خطوات التشغيل:

### 1️⃣ تشغيل الباك إند (Backend)
```bash
cd backend
php -S 127.0.0.1:8000
```

### 2️⃣ تشغيل الواجهة الأمامية (Frontend)
```bash
# في terminal آخر
cd public
python -m http.server 5500
```

### 3️⃣ افتح المتصفح
```
Frontend: http://127.0.0.1:5500
API Test: http://127.0.0.1:8000/api.php/activities
```

---

## 🔧 إذا أردت استخدام MySQL بدلاً من SQLite:

### 1️⃣ أنشئ قاعدة بيانات MySQL
```bash
mysql -u root -p
CREATE DATABASE student_initiatives CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
exit
```

### 2️⃣ استورد البيانات
```bash
mysql -u root -p student_initiatives < backend/database.sql
```

### 3️⃣ عدّل ملف .env
```bash
# في backend/.env
DB_DRIVER=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=student_initiatives
DB_USERNAME=root
DB_PASSWORD=your_password
```

---

## ✅ اختبار النجاح:

### اختبر الـ API:
```bash
curl http://127.0.0.1:8000/api.php/activities
# يجب أن ترى 3 أنشطة بالعربية
```

### اختبر الموقع:
- افتح http://127.0.0.1:5500
- اضغط على "الأنشطة"
- يجب أن ترى الأنشطة من قاعدة البيانات

---

## 🎉 المشروع يعمل الآن!

- ✅ قاعدة البيانات: SQLite جاهزة
- ✅ Backend: يعمل على 127.0.0.1:8000
- ✅ Frontend: يعمل على 127.0.0.1:5500
- ✅ API: يعيد البيانات بنجاح

---

## 📞 تحتاج مساعدة؟
إذا واجهت أي مشاكل، أخبرني!