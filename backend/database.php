<?php

declare(strict_types=1);

require_once __DIR__ . '/config.php';

function db(): PDO
{
    static $pdo = null;

    if ($pdo instanceof PDO) {
        return $pdo;
    }

    // اختيار نوع قاعدة البيانات
    $driver = strtolower((string) envValue('DB_DRIVER', envValue('MYSQLHOST') ? 'mysql' : 'sqlite')); // sqlite أو mysql

    if ($driver === 'mysql') {
        // MySQL للإنتاج
        $host = envValue('DB_HOST', envValue('MYSQLHOST', '127.0.0.1'));
        $port = envValue('DB_PORT', envValue('MYSQLPORT', '3306'));
        $database = envValue('DB_DATABASE', envValue('MYSQLDATABASE', 'student_initiatives'));
        $username = envValue('DB_USERNAME', envValue('MYSQLUSER', 'root'));
        $password = envValue('DB_PASSWORD', envValue('MYSQLPASSWORD', ''));

        $dsn = "mysql:host={$host};port={$port};dbname={$database};charset=utf8mb4";
        $pdo = new PDO($dsn, $username, $password);
    } else {
        // SQLite للتطوير المحلي
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
