-- ===== قاعدة البيانات SQLite لمشروع "مبادرتنا" =====
-- تم تحويلها من MySQL للعمل مع SQLite
-- تاريخ الإنشاء: مايو 2026

-- ===== جدول المستخدمين =====
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

-- ===== جدول الأنشطة =====
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

-- ===== جدول طلبات الانضمام =====
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

-- ===== جدول الإعلانات =====
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

-- ===== جدول معرض الصور =====
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

-- ===== جدول الإشعارات =====
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

-- ===== جدول تقارير الأنشطة =====
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

-- ===== بيانات تجريبية =====
-- إدراج مستخدم إداري
INSERT OR IGNORE INTO users (full_name, email, password_hash, role, college, phone) VALUES
('المدير العام', 'admin@initiative.com', 'admin123', 'admin', 'إدارة النظام', '01000000000');

-- إدراج أنشطة تجريبية
INSERT OR IGNORE INTO activities (title, slug, short_description, full_description, image, icon, color, category, location, max_participants, is_featured, is_active) VALUES
('ورشة عمل البرمجة', 'programming-workshop', 'تعلم أساسيات البرمجة باستخدام Python', 'ورشة عمل شاملة تغطي أساسيات البرمجة باستخدام لغة Python. ستتعلم كيفية كتابة البرامج الأساسية، حل المشاكل، وتطوير التطبيقات البسيطة.', 'images/page2/istockphoto-1427848338-612x612 1.png', 'code', '#FF6B6B', 'تعليمي', 'قاعة المحاضرات الرئيسية', 50, 1, 1),
('فعالية الرياضة الجماعية', 'sports-activity', 'نشاط رياضي جماعي لتعزيز الروح الرياضية', 'انضم إلينا في فعالية رياضية ممتعة تجمع بين الرياضة والمرح. سنقوم بألعاب جماعية مختلفة تساعد في بناء الفريق وتعزيز الروابط بين الطلاب.', 'images/page2/men-play-socer-park-tournament-mini-footbal-guy-black-sportsuits 1.png', 'users', '#4ECDC4', 'رياضي', 'ملعب الجامعة', 100, 1, 1),
('ورشة التصوير الفوتوغرافي', 'photography-workshop', 'تعلم فن التصوير والإبداع البصري', 'ورشة عمل متخصصة في التصوير الفوتوغرافي. ستتعلم أساسيات التصوير، استخدام الإضاءة، وتطوير مهاراتك في التقاط الصور الإبداعية.', 'images/page/pexels-419907350-34255037 1.png', 'camera', '#45B7D1', 'فني', 'استوديو التصوير', 30, 0, 1);

-- إدراج إعلانات تجريبية
INSERT OR IGNORE INTO announcements (title, content, published_at, is_important) VALUES
('ترحيب بالطلاب الجدد', 'نرحب بجميع الطلاب الجدد في مبادرتنا. نتمنى لكم عاماً دراسياً موفقاً مليئاً بالإنجازات والنجاحات.', '2026-05-01 09:00:00', 1),
('تسجيل الأنشطة الجديدة', 'تم فتح باب التسجيل للأنشطة الجديدة للفصل الدراسي الحالي. يمكنكم التسجيل من خلال الموقع أو زيارة مكتب المبادرة.', '2026-05-02 10:00:00', 0);

-- إدراج عناصر معرض تجريبية
INSERT OR IGNORE INTO gallery_items (activity_id, title, image_path, report_excerpt, captured_at) VALUES
(1, 'ورشة البرمجة - الجلسة الأولى', 'images/page/Screenshot 2026-01-21 035100 1.png', 'بدء الورشة بمقدمة عن أساسيات البرمجة', '2026-05-01 14:00:00'),
(2, 'فعالية الرياضة - المباراة النهائية', 'images/page/students-stacking-hands-table 1.png', 'لحظة الفرح بعد الفوز في المباراة النهائية', '2026-05-02 16:30:00');

-- ===== فهارس لتحسين الأداء =====
CREATE INDEX IF NOT EXISTS idx_activities_slug ON activities(slug);
CREATE INDEX IF NOT EXISTS idx_activities_featured ON activities(is_featured, is_active);
CREATE INDEX IF NOT EXISTS idx_activities_created_by ON activities(created_by);
CREATE INDEX IF NOT EXISTS idx_volunteer_applications_activity ON volunteer_applications(activity_id);
CREATE INDEX IF NOT EXISTS idx_volunteer_applications_status ON volunteer_applications(status);
CREATE INDEX IF NOT EXISTS idx_announcements_published ON announcements(published_at, is_important);
CREATE INDEX IF NOT EXISTS idx_gallery_activity ON gallery_items(activity_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user ON notifications(user_id, is_read);
CREATE INDEX IF NOT EXISTS idx_reports_activity ON activity_reports(activity_id);

-- ===== رسالة نجاح =====
-- قاعدة البيانات تم إنشاؤها بنجاح!
-- يمكنك الآن تشغيل المشروع محلياً باستخدام SQLite
