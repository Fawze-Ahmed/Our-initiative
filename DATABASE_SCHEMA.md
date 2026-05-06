# خريطة قاعدة البيانات - مبادرتنا

اسم قاعدة البيانات: **student_initiatives**

---

## الجداول والحقول

### 1. جدول `users` - المستخدمون

```sql
CREATE TABLE users (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('admin', 'student') NOT NULL DEFAULT 'student',
    phone VARCHAR(30) DEFAULT NULL,
    college VARCHAR(150) DEFAULT NULL,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

**الوصف:**
- تخزين بيانات المستخدمين (الطلاب والمسؤولين)
- الأدوار: `admin` (مسؤول)، `student` (طالب)
- الحقول: الاسم الكامل، البريد الإلكتروني، كلمة المرور، الهاتف، الكلية

**الفهارس:**
- `id`: المفتاح الأساسي
- `email`: فريد (لا يمكن تكرار البريد)

---

### 2. جدول `activities` - الأنشطة

```sql
CREATE TABLE activities (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
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
    max_participants INT UNSIGNED NOT NULL DEFAULT 0,
    is_featured TINYINT(1) NOT NULL DEFAULT 0,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    created_by INT UNSIGNED NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_activities_creator FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
);
```

**الوصف:**
- تخزين بيانات الأنشطة المختلفة
- يتضمن: العنوان، الوصف، الصورة، المكان، الوقت، عدد المشاركين
- `slug`: نسخة من العنوان صالحة للـ URL (مثل: "workshop-web-design")
- `is_featured`: لتحديد الأنشطة المميزة
- `created_by`: يشير إلى المستخدم الذي أنشأ النشاط

**الفهارس:**
- `id`: المفتاح الأساسي
- `slug`: فريد
- `created_by`: مفتاح أجنبي يشير إلى `users`

---

### 3. جدول `volunteer_applications` - طلبات الانضمام

```sql
CREATE TABLE volunteer_applications (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    activity_id INT UNSIGNED NULL,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL,
    college VARCHAR(150) NOT NULL,
    phone VARCHAR(30) DEFAULT NULL,
    message TEXT NOT NULL,
    status ENUM('pending', 'approved', 'rejected') NOT NULL DEFAULT 'pending',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_volunteer_activity FOREIGN KEY (activity_id) REFERENCES activities(id) ON DELETE SET NULL
);
```

**الوصف:**
- تخزين طلبات المتطوعين للانضمام إلى الأنشطة
- الحالات: `pending` (قيد الانتظار)، `approved` (موافق عليه)، `rejected` (مرفوض)
- `activity_id`: يشير إلى النشاط الذي يرغب في الانضمام إليه

**الفهارس:**
- `id`: المفتاح الأساسي
- `activity_id`: مفتاح أجنبي يشير إلى `activities`

---

### 4. جدول `announcements` - الإعلانات

```sql
CREATE TABLE announcements (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    published_at DATETIME DEFAULT NULL,
    is_important TINYINT(1) NOT NULL DEFAULT 0,
    created_by INT UNSIGNED NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_announcements_creator FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
);
```

**الوصف:**
- تخزين الإعلانات والأخبار
- `is_important`: لتحديد الإعلانات المهمة (تظهر بأولوية)
- `published_at`: وقت نشر الإعلان

**الفهارس:**
- `id`: المفتاح الأساسي
- `created_by`: مفتاح أجنبي يشير إلى `users`

---

### 5. جدول `gallery_items` - معرض الصور

```sql
CREATE TABLE gallery_items (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    activity_id INT UNSIGNED NULL,
    title VARCHAR(255) NOT NULL,
    image_path VARCHAR(255) NOT NULL,
    report_excerpt TEXT DEFAULT NULL,
    captured_at DATETIME DEFAULT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_gallery_activity FOREIGN KEY (activity_id) REFERENCES activities(id) ON DELETE SET NULL
);
```

**الوصف:**
- تخزين صور من الأنشطة والفعاليات
- `image_path`: مسار الصورة في السيرفر
- `report_excerpt`: شرح قصير عن الصورة
- `captured_at`: تاريخ التقاط الصورة

**الفهارس:**
- `id`: المفتاح الأساسي
- `activity_id`: مفتاح أجنبي يشير إلى `activities`

---

### 6. جدول `notifications` - الإشعارات

```sql
CREATE TABLE notifications (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNSIGNED NULL,
    title VARCHAR(255) NOT NULL,
    body TEXT NOT NULL,
    type VARCHAR(100) DEFAULT 'general',
    is_read TINYINT(1) NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_notifications_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);
```

**الوصف:**
- تخزين الإشعارات للمستخدمين
- `type`: نوع الإشعار (عام، تنبيه، إعلان، إلخ)
- `is_read`: هل تم قراءة الإشعار

**الفهارس:**
- `id`: المفتاح الأساسي
- `user_id`: مفتاح أجنبي يشير إلى `users`

---

### 7. جدول `activity_reports` - تقارير الأنشطة

```sql
CREATE TABLE activity_reports (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    activity_id INT UNSIGNED NOT NULL,
    title VARCHAR(255) NOT NULL,
    summary TEXT NOT NULL,
    participants_count INT UNSIGNED NOT NULL DEFAULT 0,
    report_date DATE NOT NULL,
    created_by INT UNSIGNED NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_reports_activity FOREIGN KEY (activity_id) REFERENCES activities(id) ON DELETE CASCADE,
    CONSTRAINT fk_reports_creator FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
);
```

**الوصف:**
- تخزين تقارير الأنشطة والإحصائيات
- `participants_count`: عدد المشاركين
- `report_date`: تاريخ النشاط
- `ON DELETE CASCADE`: حذف التقرير إذا تم حذف النشاط

**الفهارس:**
- `id`: المفتاح الأساسي
- `activity_id`: مفتاح أجنبي يشير إلى `activities` (حذف متسلسل)
- `created_by`: مفتاح أجنبي يشير إلى `users`

---

## الارتباطات (Relationships)

### خريطة الارتباطات:

```
users (1) ──────→ (M) activities
         created_by

users (1) ──────→ (M) announcements
         created_by

users (1) ──────→ (M) notifications
         user_id

users (1) ──────→ (M) activity_reports
         created_by

activities (1) ──────→ (M) volunteer_applications
            activity_id

activities (1) ──────→ (M) gallery_items
            activity_id

activities (1) ──────→ (M) activity_reports
            activity_id
```

---

## إحصائيات الجداول

| الجدول | الوصف | المفتاح الأساسي | الحقول | الارتباطات |
|--------|-------|---------------|---------|-----------| 
| users | المستخدمون | id | 9 | إنشاء activities, announcements, notifications, activity_reports |
| activities | الأنشطة | id | 14 | يتم إنشاؤها بواسطة users, ترتبط مع volunteer_applications, gallery_items, activity_reports |
| volunteer_applications | طلبات الانضمام | id | 8 | ترتبط مع activities |
| announcements | الإعلانات | id | 7 | ترتبط مع users |
| gallery_items | الصور | id | 7 | ترتبط مع activities |
| notifications | الإشعارات | id | 7 | ترتبط مع users |
| activity_reports | تقارير الأنشطة | id | 8 | ترتبط مع activities, users |

---

## الخصائص العامة لجميع الجداول

- **الترميز**: UTF8MB4 (دعم اللغات المتعددة)
- **التجميع**: utf8mb4_unicode_ci (مقارنة حساسة للحالة)
- **الطوابع الزمنية**: 
  - `created_at`: وقت الإنشاء
  - `updated_at`: وقت آخر تحديث
- **المفاتيح الأجنبية**: تستخدم `ON DELETE SET NULL` (الحفاظ على البيانات) أو `ON DELETE CASCADE` (حذف متسلسل)

---

## ملاحظات أمان

- ⚠️ **كلمات المرور**: يجب تخزينها مشفرة باستخدام `bcrypt` أو `argon2`
- ⚠️ **الصور**: يجب التحقق من نوع الملف وحجمه
- ⚠️ **البريد الإلكتروني**: يجب التحقق من صحته
- ⚠️ **SQL Injection**: استخدم Prepared Statements (وهو مطبق بالفعل)
- ⚠️ **CORS**: تأكد من تقييد Origins في الإنتاج

---

تم الإنشاء: مايو 2026
