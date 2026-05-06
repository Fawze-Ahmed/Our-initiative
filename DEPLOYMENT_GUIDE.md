# 🚀 إصلاح Vercel وإعداد قاعدة البيانات

## المشكلة التي كانت موجودة:
```
❌ البنية خاطئة (مجلد مرتين)
❌ الملفات في مكان خاطئ
❌ إعدادات Vercel ناقصة
❌ لا توجد Backend API
❌ قاعدة بيانات غير متصلة
```

## الحل الذي تم تطبيقه:
```
✅ نقل الملفات إلى مجلد public
✅ إنشاء vercel.json للإعدادات الصحيحة
✅ إنشاء package.json للـ dependencies
✅ تحديث api.js للتواصل مع قاعدة بيانات خارجية
```

---

## 📊 الآن تحتاج إلى:

### 1️⃣ قاعدة بيانات موجودة على الإنترنت

**الخيارات المجانية:**

#### أ) Railway (الأفضل للـ PHP + MySQL)
```
1. اذهب إلى https://railway.app
2. انشئ حساب جديد
3. نشئ مشروع جديد (New Project)
4. أختر MySQL
5. احصل على بيانات الاتصال:
   - HOST: xxxxx.railway.app
   - PORT: xxxxx
   - DATABASE: railway
   - USER: root
   - PASSWORD: xxxxx
```

#### ب) Neon (PostgreSQL مجاني)
```
1. اذهب إلى https://neon.tech
2. انشئ حساب
3. انشئ project جديد
4. استخدم SQL للإنشاء
```

#### ج) MongoDB Atlas (NoSQL)
```
1. اذهب إلى https://www.mongodb.com/cloud/atlas
2. انشئ حساب مجاني
3. Create Cluster
4. احصل على Connection String
```

---

### 2️⃣ Backend API على Vercel أو Railway

**الخيار الأول: استخدام Railway API مباشرة**

```bash
git clone https://github.com/Fawze-Ahmed/Our-initiative.git
cd Our-initiative
```

ثم اتبع الخطوات أدناه...

---

## 🔧 إعداد API الخلفية على Railway

### الخطوة 1: حضّر Backend للـ Railway

```bash
# 1. أنشئ ملف composer.json (إذا لم يكن موجوداً)
composer init

# 2. أضف Procfile للـ Railway
echo "web: php -S 0.0.0.0:\$PORT backend/api.php" > Procfile
```

### الخطوة 2: أنشئ ملف .env للـ Railway

```bash
# سينسخ من .env.example
cp backend/.env.example backend/.env.production
```

**محتويات `.env.production`:**
```env
APP_ENV=production
APP_DEBUG=false

DB_HOST=your_railway_host.railway.app
DB_PORT=3306
DB_DATABASE=railway
DB_USERNAME=root
DB_PASSWORD=your_railway_password

FRONTEND_URL=https://our-initiative-lc4x.vercel.app
```

### الخطوة 3: نشر على Railway

```bash
# 1. نصب Railway CLI
npm install -g @railway/cli

# 2. سجل الدخول
railway login

# 3. ابدأ مشروع جديد
railway init

# 4. اختر الخادم الموجود (أو أنشئ واحد جديد)
railway link

# 5. اضبط متغيرات البيئة
railway variable add DB_HOST=...
railway variable add DB_PASSWORD=...
# ... إلخ

# 6. نشر المشروع
git push
```

---

## 🗄️ إنشاء قاعدة البيانات على Railway

```bash
# 1. ادخل لـ Railway Dashboard
# 2. اختر MySQL
# 3. احصل على تفاصيل الاتصال
# 4. استخدم MySQL Workbench أو adminer لاستيراد database.sql

mysql -h your_host -u root -p < backend/database.sql

# أو استخدم phpMyAdmin عبر Railway
```

---

## 🔄 تحديث api.js للتواصل مع الـ API البعيد

```javascript
// في public/js/api.js

window.APP_CONFIG = {
  // للمطوّرين المحليين
  // apiBaseUrl: 'http://127.0.0.1:8000/api.php'
  
  // للإنتاج على Vercel + Railway
  apiBaseUrl: 'https://your-railway-app.railway.app/backend/api.php'
};

window.apiGet = async function apiGet(path) {
  try {
    const response = await fetch(window.APP_CONFIG.apiBaseUrl + path, {
      headers: {
        Accept: 'application/json'
      }
    });

    if (!response.ok) {
      if (response.status === 404) {
        console.warn('المورد غير موجود:', path);
        return { data: [] };
      }
      throw new Error('Request failed with status ' + response.status);
    }

    return response.json();
  } catch (error) {
    console.error('API Error:', error);
    return { data: [] };
  }
};
```

---

## ✅ الخطوات النهائية

### 1. اختبر المشروع محلياً أولاً
```bash
cd backend
php -S 127.0.0.1:8000

# في terminal آخر
cd public
python -m http.server 5500
```

### 2. ادفع إلى GitHub
```bash
git add .
git commit -m "Fix Vercel deployment: reorganize frontend structure"
git push origin main
```

### 3. نشر على Vercel
```bash
# 1. اذهب إلى https://vercel.com
# 2. اضغط "Import Project"
# 3. اختر GitHub Repository
# 4. اضغط Deploy
```

### 4. نشر Backend على Railway
```bash
# اتبع الخطوات أعلاه في قسم Railway
```

---

## 🔗 النتيجة النهائية

```
Frontend (Vercel):
https://our-initiative-lc4x.vercel.app

Backend API (Railway):
https://your-app.railway.app/backend/api.php

Database (Railway MySQL):
Managed by Railway
```

---

## 🚨 المشاكل الشائعة والحلول

| المشكلة | الحل |
|--------|------|
| CORS Error | أضف CORS Headers في backend/helpers.php |
| API 404 | تأكد من الـ URL في api.js صحيح |
| Database Connection Error | تحقق من بيانات الاتصال في .env |
| Pages 404 on Vercel | تأكد من vercel.json صحيح |

---

## 📞 هل تريد مساعدة في:

1. ✅ إعداد Railway مع MySQL
2. ✅ نشر Backend على Railway
3. ✅ ربط Frontend على Vercel بـ Backend على Railway
4. ✅ استيراد قاعدة البيانات

**أخبرني بأي منها تريد والخطوة الأولى!**
