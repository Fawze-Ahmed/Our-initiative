// تحديد URL الـ API بناءً على البيئة
window.APP_CONFIG = {
  // الإنتاج (Railway)
  apiBaseUrl: (typeof process !== 'undefined' && process.env.NODE_ENV === 'production')
    ? 'https://api.your-railway-app.railway.app/backend/api.php'
    // التطوير المحلي
    : window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1'
      ? 'http://127.0.0.1:8000/api.php'
      // الإنتاج على Vercel (بدون Backend محلي)
      : window.location.protocol + '//' + window.location.host + '/api'
};

// دالة للحصول على البيانات
window.apiGet = async function apiGet(path) {
  try {
    console.log('🔄 جاري الطلب:', window.APP_CONFIG.apiBaseUrl + path);
    
    var response = await fetch(window.APP_CONFIG.apiBaseUrl + path, {
      method: 'GET',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      credentials: 'include'
    });

    // في حالة عدم وجود Backend، أرجع بيانات فارغة
    if (response.status === 404 || response.status === 503) {
      console.warn('⚠️ الـ Backend غير متاح:', response.status);
      return { data: [], message: 'الخدمة غير متاحة حالياً' };
    }

    if (!response.ok) {
      console.error('❌ خطأ في الطلب:', response.status);
      throw new Error('Request failed with status ' + response.status);
    }

    const data = await response.json();
    console.log('✅ تم الحصول على البيانات');
    return data;
  } catch (error) {
    console.error('🚨 خطأ في API:', error);
    return { data: [], error: error.message };
  }
};

// دالة لإرسال البيانات
window.apiPost = async function apiPost(path, body) {
  try {
    console.log('📤 جاري الإرسال:', path, body);
    
    var response = await fetch(window.APP_CONFIG.apiBaseUrl + path, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: JSON.stringify(body),
      credentials: 'include'
    });

    if (!response.ok) {
      var errorPayload = null;

      try {
        errorPayload = await response.json();
      } catch (error) {
        errorPayload = null;
      }

      console.error('❌ خطأ في الإرسال:', response.status);
      throw new Error(
        (errorPayload && errorPayload.message) || ('Request failed with status ' + response.status)
      );
    }

    const data = await response.json();
    console.log('✅ تم الإرسال بنجاح');
    return data;
  } catch (error) {
    console.error('🚨 خطأ في API POST:', error);
    throw error;
  }
};

// دالة للتحقق من حالة الـ API
window.apiHealth = async function apiHealth() {
  try {
    const response = await fetch(window.APP_CONFIG.apiBaseUrl, {
      method: 'OPTIONS'
    });
    return response.ok;
  } catch (error) {
    console.warn('⚠️ الـ API غير متاح');
    return false;
  }
};
