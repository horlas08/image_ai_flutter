# Google Play Console: Subscriptions Setup Guide (English / العربية)

This guide shows how to create the three subscription products your app expects and how to test them.

Products to create (IDs must match exactly):
- Yearly: pro_yearly_36
- Weekly: pro_weekly_8
- Weekly with 3-day trial: pro_weekly_trial_3d

App code references (Env):
- Env.productYearly = 'pro_yearly_36'
- Env.productWeekly = 'pro_weekly_8'
- Env.productTrialWeekly = 'pro_weekly_trial_3d'

---

## ENGLISH

### 1) Prerequisites
- A Google Play Console account with access to your app.
- Your app is created in the Play Console (with applicationId = your Android package name in Env.androidPackageName).
- Billing permission added by the in_app_purchase plugin automatically. Build once so Play can detect billing.

### 2) Open Subscriptions
- Go to: Play Console → Monetize → Products → Subscriptions
- Click “Create subscription”.

### 3) Create YEARLY plan
- Product ID: pro_yearly_36
- Name and Description: Show the plan clearly (e.g., “Yearly Access”).
- Base plan:
  - Billing period: 1 year
  - Price: set your yearly price (e.g., USD 36 or local equivalent)
  - Auto-renewing: Enabled
- Save and activate.

### 4) Create WEEKLY plan
- Product ID: pro_weekly_8
- Name and Description: “Weekly Access”.
- Base plan:
- Billing period: 1 week
- Price: set your weekly price (e.g., USD 8 or local equivalent)
- Auto-renewing: Enabled
- Save and activate.


### 5) Create WEEKLY plan with 3-day free trial
- Product ID: pro_weekly_trial_3d
- Name and Description: “3 Days Free Trial then Weekly”.
- Base plan:
  - Billing period: 1 week
  - Price: same as your weekly plan
  - Auto-renewing: Enabled
- Offer: Add an introductory offer
  - Type: Free trial
  - Duration: 3 days
  - Eligibility: New subscribers
- Save and activate.

Note: Google’s new monetization UI uses Base plans and Offers. If you see the legacy UI, add an “Introductory price / Free trial” on the product.

### 6) Link test accounts and upload a build
- Create an internal testing track (Testing → Internal testing) and add testers (Gmail accounts).
- Upload an app bundle (AAB), publish the internal track.
- On a test device:
  - Play Store → switch to the tester account, install the app from the Play Store testing link.
  - Subscriptions test charges apply (often discounted or immediate trial flow depending on region/policy).

### 7) Verify in the app
- Open your app → open the Go Pro paywall.
- You should see 3 plans (Yearly, Weekly, Trial Weekly). Prices show as defined in Play.
- Selecting a plan and tapping Buy should open the native purchase flow.
- After success, ads hidden and features unlocked. `isPro` persists across restarts.

### 8) Going live
- Make sure all products are active and your production/beta/alpha release includes billing.
- Update any pricing and localized text in Play Console if needed.

---

## العربية

### 1) المتطلبات الأساسية
- حساب Google Play Console مع إمكانية الوصول إلى تطبيقك.
- تم إنشاء تطبيقك في Play Console (applicationId = اسم حزمة أندرويد في Env.androidPackageName).
- إضافة صلاحية الدفع تتم تلقائيًا بواسطة مكتبة in_app_purchase. قم ببناء التطبيق مرة واحدة ليتم اكتشاف الدفع في Play.

### 2) فتح صفحة الاشتراكات
- انتقل إلى: Play Console → الربح (Monetize) → المنتجات (Products) → الاشتراكات (Subscriptions)
- اضغط “Create subscription”.

### 3) إنشاء الخطة السنوية
- معرف المنتج: pro_yearly_36
- الاسم والوصف: اكتب “اشتراك سنوي” أو ما يناسب.
- الخطة الأساسية (Base plan):
  - فترة الدفع: سنة واحدة
  - السعر: حدد سعر السنة (مثال: 36 دولارًا أو ما يعادله محليًا)
  - التجديد التلقائي: مفعّل
- احفظ وفعّل.

### 4) إنشاء الخطة الأسبوعية
- معرف المنتج: pro_weekly_8
- الاسم والوصف: “اشتراك أسبوعي”.
- الخطة الأساسية:
  - فترة الدفع: أسبوع واحد
  - السعر: حدد سعر الأسبوع (مثال: 8 دولارات أو ما يعادل)
  - التجديد التلقائي: مفعّل
- احفظ وفعّل.

### 5) إنشاء خطة أسبوعية مع تجربة مجانية 3 أيام
- معرف المنتج: pro_weekly_trial_3d
- الاسم والوصف: “3 أيام تجربة مجانية ثم أسبوعيًا”.
- الخطة الأساسية:
  - فترة الدفع: أسبوع واحد
  - السعر: نفس سعر الخطة الأسبوعية
  - التجديد التلقائي: مفعّل
- العرض (Offer): أضف عرضًا تمهيديًا
  - النوع: تجربة مجانية
  - المدة: 3 أيام
  - الأهلية: مشتركين جدد
- احفظ وفعّل.

ملاحظة: واجهة تحقيق الدخل الحديثة في Google تستخدم Base plans و Offers. إذا ظهرت الواجهة القديمة، أضف “سعر تمهيدي / تجربة مجانية” ضمن المنتج مباشرة.

### 6) حسابات الاختبار ورفع نسخة
- أنشئ مسار اختبار داخلي (Testing → Internal testing) وأضف حسابات المراجعين (حسابات Gmail).
- ارفع حزمة التطبيق (AAB) وانشر مسار الاختبار الداخلي.
- على جهاز الاختبار:
  - افتح متجر Play بحساب المراجع، ثم ثبّت التطبيق من رابط الاختبار.
  - تطبق رسوم اختبار الاشتراكات (قد تكون مخفضة أو تجربة فورية حسب المنطقة/السياسة).

### 7) التحقق داخل التطبيق
- افتح التطبيق → افتح واجهة “الترقية إلى برو”.
- يجب أن ترى 3 خطط (سنوي، أسبوعي، تجربة 3 أيام ثم أسبوعي). تظهر الأسعار كما حددتها في Play.
- عند اختيار خطة والنقر على شراء، تظهر واجهة الشراء الخاصة بمتجر Play.
- بعد إتمام الشراء، تختفي الإعلانات وتُفعل المزايا. ويتم حفظ حالة الاشتراك بعد إعادة التشغيل.

### 8) الإطلاق للعامة
- تأكد من تفعيل جميع المنتجات وأن إصدار الإنتاج/البيتا/ألفا يحتوي على دعم الدفع.
- حدّث الأسعار والنصوص المترجمة في Play Console إذا لزم الأمر.

---

## Troubleshooting / استكشاف الأخطاء
- Product not visible in app? Ensure product IDs match Env constants and the tester account is enrolled in testing.
- Purchase flow not opening? Install from the testing link in Play, not from a sideloaded APK.
- Intro offer not applied? Verify the Offer is active and the tester is a new subscriber.
