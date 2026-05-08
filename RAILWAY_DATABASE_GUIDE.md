# 🚀 دليل كامل: إعداد قاعدة البيانات على Railway

## 📋 المتطلبات:
- حساب GitHub (لديك بالفعل ✅)
- حساب Railway (مجاني)
- بيانات مستودع GitHub

---

## 🎯 الخطوة الأولى: إنشاء حساب Railway وقاعدة البيانات

### 1️⃣ اذهب إلى Railway
```
رابط: https://railway.app
```

### 2️⃣ سجل الدخول أو أنشئ حساب
```
- اضغط "Login" أو "Sign up"
- استخدم GitHub للتسجيل السريع
- وافق على الأذونات
```

### 3️⃣ أنشئ مشروع جديد
```
1. في الصفحة الرئيسية، اضغط "+ New Project"
2. اختر "Create new"
3. اختر "MySQL" من القائمة
4. اسم المشروع: "our-initiative"
```

### 4️⃣ انتظر حتى تنتهي Railway من الإعداد
```
سيستغرق حوالي دقيقة واحدة
```

---

## 📊 استيراد قاعدة البيانات

### الطريقة 1: استخدام MySQL CLI (الأسهل)

#### الخطوة 1: احصل على بيانات الاتصال
```
1. افتح لوحة التحكم Railway
2. اختر MySQL من المشاريع
3. اضغط على Data (في الجانب الأيسر)
4. انسخ معلومات الاتصال:
   - MYSQL_HOST
   - MYSQL_PORT
   - MYSQL_DATABASE
   - MYSQL_USER
   - MYSQL_PASSWORD
```

#### الخطوة 2: نصب MySQL Client (إذا لم تكن مثبتاً)
```bash
# Windows - اذهب إلى https://dev.mysql.com/downloads/mysql/ وحمّل Installer

# أو استخدم Chocolatey (إذا كان مثبتاً)
choco install mysql-client

# macOS
brew install mysql-client

# Linux
sudo apt install mysql-client
```

#### الخطوة 3: تأكد من تثبيت MySQL
```bash
mysql --version
```

#### الخطوة 4: استورد قاعدة البيانات
```bash
# استبدل القيم بالقيم الحقيقية من Railway
mysql -h <MYSQL_HOST> \
       -P <MYSQL_PORT> \
       -u <MYSQL_USER> \
       -p<MYSQL_PASSWORD> \
       <MYSQL_DATABASE> < backend/database.sql

# مثال:
# mysql -h mysql.railway.internal \
#        -P 3306 \
#        -u root \
#        -pYourSecurePassword \
#        railway < backend/database.sql
```

⚠️ **ملاحظة:** لا توجع مسافة بين `-p` والكلمة المرورية

---

### الطريقة 2: استخدام phpMyAdmin (الأسهل)

#### الخطوة 1: افتح phpMyAdmin عبر Railway
```
1. في لوحة التحكم Railway
2. اختر MySQL
3. اضغط على "Connect"
4. اختر "phpMyAdmin"
```

#### الخطوة 2: استورد الملف
```
1. في phpMyAdmin، اختر Database جديد
2. اسمه: student_initiatives
3. Collation: utf8mb4_unicode_ci
4. اضغط Create
5. اختر Database الجديد
6. اذهب إلى "Import" tab
7. اختر ملف: backend/database.sql
8. اضغط "Go"
```

---

### الطريقة 3: SQL مباشر (من Railway Dashboard)

#### الخطوة 1: افتح Railway Console
```
1. في لوحة التحكم Railway
2. اختر MySQL
3. اضغط على "Terminal"
```

#### الخطوة 2: انسخ وألصق أوامر SQL
```sql
-- ليس معملياً للملفات الكبيرة، لكن يمكنك:
CREATE DATABASE IF NOT EXISTS student_initiatives CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE student_initiatives;

-- ثم ألصق محتوى database.sql هنا
-- (ليس مريح لكن يعمل)
```

---

## 🔑 احصل على بيانات الاتصال النهائية

### من لوحة التحكم Railway:
```
1. اختر Project → MySQL
2. اضغط على "Variables" (الجانب الأيسر)
3. سترى:
   ✅ MYSQL_HOST
   ✅ MYSQL_PORT
   ✅ MYSQL_DATABASE
   ✅ MYSQL_USER
   ✅ MYSQL_PASSWORD
   ✅ MYSQL_URL
```

### أو اضغط على "Connect"
```
سيظهر الاتصال الكامل:
DATABASE_URL=mysql://user:password@host:port/database
```

---

## 🔗 ربط Backend بـ Railway

### الطريقة 1: نشر Backend على Railway نفسها

#### الخطوة 1: أنشئ Services جديد
```
1. في Railway Dashboard
2. اضغط "+ New Service"
3. اختر "GitHub Repo"
4. ابحث عن: Our-initiative
5. اختر الـ Repository
6. اضغط "Deploy"
```

#### الخطوة 2: أضف متغيرات البيئة
```
1. في Dashboard، اختر Service الجديد
2. اضغط "Variables"
3. أضف:

DB_HOST=<محتوى MYSQL_HOST>
DB_PORT=3306
DB_DATABASE=student_initiatives
DB_USERNAME=<محتوى MYSQL_USER>
DB_PASSWORD=<محتوى MYSQL_PASSWORD>
```

#### الخطوة 3: أضف Procfile
```bash
# أنشئ ملف في جذر المشروع: Procfile
echo "web: php -S 0.0.0.0:\$PORT backend/api.php" > Procfile
```

#### الخطوة 4: ادفع إلى GitHub
```bash
git add Procfile
git commit -m "Add Procfile for Railway deployment"
git push
```

---

### الطريقة 2: Frontend على Vercel + Backend على Railway

#### الخطوة 1: Frontend على Vercel
```
1. اذهب إلى https://vercel.com
2. اضغط "Import Project"
3. ابحث عن: Our-initiative
4. اضغط "Import"
5. اضغط "Deploy"
```

#### الخطوة 2: Backend على Railway
```
(اتبع الخطوات أعلاه)
```

#### الخطوة 3: حدّث api.js على Vercel
```javascript
// في public/js/api.js
window.APP_CONFIG = {
  apiBaseUrl: 'https://<your-railway-app>.railway.app/backend/api.php'
};
```

#### الخطوة 4: ادفع التحديث
```bash
git add public/js/api.js
git commit -m "Update API URL for Railway backend"
git push
```

---

## ⚙️ اختبار الاتصال

### اختبر قاعدة البيانات:
```bash
# من داخل المشروع
mysql -h <MYSQL_HOST> \
       -u <MYSQL_USER> \
       -p<MYSQL_PASSWORD> \
       <MYSQL_DATABASE> \
       -e "SELECT * FROM users;"
```

### اختبر الـ API:
```bash
# في terminal مختلف
curl -X GET "https://<your-railway-app>.railway.app/backend/api.php/activities"

# يجب أن ترى JSON بالبيانات
```

---

## 🔐 الأمان

### ⚠️ تأكد من:
```
✅ لا تضع كلمات المرور في الكود
✅ استخدم Variables في Railway فقط
✅ جعل MYSQL_PASSWORD قوي جداً
✅ استخدم HTTPS في الـ URLs
✅ قيّد CORS Origins
```

### حدّث helpers.php للأمان:
```php
// في backend/helpers.php
header('Access-Control-Allow-Origin: https://our-initiative-vercel.app');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
```

---

## 📞 حل المشاكل الشائعة

| المشكلة | الحل |
|--------|------|
| `Connection refused` | تحقق من HOST و PORT |
| `Access denied` | تحقق من USERNAME و PASSWORD |
| `Database not found` | استورد database.sql |
| `CORS Error` | حدّث Origin في helpers.php |
| `API 404` | تأكد من المسار صحيح |

---

## 🎯 الخطوات الملخصة

```bash
# 1. إنشاء قاعدة بيانات
# - اذهب إلى railway.app
# - أنشئ MySQL
# - احصل على بيانات الاتصال

# 2. استيراد البيانات
mysql -h <host> -u <user> -p <password> <database> < backend/database.sql

# 3. نشر Frontend
# - اذهب إلى vercel.com
# - ربط GitHub
# - Deploy

# 4. نشر Backend
# - اذهب إلى railway.app
# - أضف GitHub Repo
# - أضف Variables
# - Deploy

# 5. ربط الاثنين
# - حدّث api.js بـ URL الـ Backend
# - ادفع التحديث
```

---

## ✅ بعد الإعداد

```
Frontend: https://our-initiative-lc4x.vercel.app ✅
Backend:  https://your-app.railway.app ✅
Database: Railway MySQL ✅
```

---

## 🆘 تحتاج مساعدة؟

### إذا واجهت مشاكل:
1. اذهب إلى: https://railway.app/docs
2. أو: https://vercel.com/docs
3. أو أطلب مساعدتي مباشرة

---

**هل تريد أن أشرح أي خطوة بالتفصيل؟**
