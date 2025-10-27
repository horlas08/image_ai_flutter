import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          // Generic
          'success': 'Success',
          'error': 'Error',
          'permission': 'Permission',
          'saved_to_gallery': 'Saved to gallery',
          'save_failed': 'Save failed',
          'failed_to_download': 'Failed to download',
          'photos_permission_required': 'Photos permission is required to save',
          'storage_permission_denied': 'Storage permission denied. Enable it in settings.',

          // App
          'app_title': 'Room Design Ai',
          'dashboard': 'Dashboard',
          'hi_name': 'Hi, @name',

          // Bottom sheet redesign
          'room_redesign': 'Room Redesign',
          'tap_to_select_room_image': 'Tap to select room image',
          'style_choice': 'Style Choice',
          'redesign': 'Redesign',
          'redesign_requested': 'Room redesign requested',
          // Styles
          'modern': 'Modern',
          'minimalist': 'Minimalist',
          'luxury': 'Luxury',
          'industrial': 'Industrial',
          'scandinavian': 'Scandinavian',

          // History
          'no_history_yet': 'No history yet',
          'refresh': 'Refresh',
          'download': 'Download',
          'view_original': 'View original',

          // Profile
          'profile': 'Profile',
          'first_name': 'First Name',
          'last_name': 'Last Name',
          'username': 'Username',
          'email': 'Email',
          'save_changes': 'Save Changes',
          'change_password': 'Change Password',
          'old_password': 'Old Password',
          'new_password': 'New Password',
          'confirm_new_password': 'Confirm New Password',
          'required': 'Required',
          'min_6_char': 'Minimum 6 characters',
          'password_mismatch': 'Passwords do not match',
          'switch_language': 'Switch language',

          // Viewer
          'preview': 'Preview',

          // Controller messages
          'profile_updated': 'Profile updated successfully',
          'profile_image_updated': 'Profile image updated',
          'password_changed_successfully': 'Password changed successfully',
          'update_failed': 'Update failed',
          'upload_failed': 'Upload failed',
          'change_password_failed': 'Change password failed',
          'login_failed': 'Login Failed',
          'account_created_please_login': 'Account created. Please login.',
          'password_reset_success': 'Password reset successful. Please login.',
          'session_expired': 'Your session has expired. Please login again.',

          // Auth screens
          'login': 'Login',
          'sign_up': 'Sign Up',
          'create_account_to_continue': 'Create an account to continue!',
          'email_required': 'Email is required',
          'enter_valid_email': 'Enter a valid email',
          'password_required': 'Password is required',
          'please_wait': 'Please wait...',
          'forgot_password': 'Forgot Password',
          'forgot_password_q': 'Forgot Password?',
          'no_account_sign_up': 'No account? Sign up',
          'already_have_account': 'Already have an account?',
          'min_3_char': 'Minimum 3 characters',
          'send_otp': 'Send OTP',
          'otp_code': 'OTP Code',
          'reset_password': 'Reset Password',
          'enter_code_email': 'Enter the code sent to your email',
          'confirm_password': 'Confirm Password',
          'confirm_your_password': 'Confirm your password',
        },
        'ar': {
          // Generic
          'success': 'نجاح',
          'error': 'خطأ',
          'permission': 'إذن',
          'saved_to_gallery': 'تم الحفظ في المعرض',
          'save_failed': 'فشل الحفظ',
          'failed_to_download': 'فشل التنزيل',
          'photos_permission_required': 'مطلوب إذن الصور للحفظ',
          'storage_permission_denied': 'تم رفض إذن التخزين. قم بتمكينه من الإعدادات.',

          // App
          'app_title': 'ذكاء تصميم الغرف',
          'dashboard': 'لوحة التحكم',
          'hi_name': 'مرحباً، @name',

          // Bottom sheet redesign
          'room_redesign': 'إعادة تصميم الغرفة',
          'tap_to_select_room_image': 'اضغط لاختيار صورة الغرفة',
          'style_choice': 'اختيار النمط',
          'redesign': 'إعادة التصميم',
          'redesign_requested': 'تم إرسال طلب إعادة التصميم',
          // Styles
          'modern': 'حديث',
          'minimalist': 'بسيط',
          'luxury': 'فاخر',
          'industrial': 'صناعي',
          'scandinavian': 'إسكندنافي',

          // History
          'no_history_yet': 'لا يوجد سجل بعد',
          'refresh': 'تحديث',
          'download': 'تنزيل',
          'view_original': 'عرض الأصل',

          // Profile
          'profile': 'الملف الشخصي',
          'first_name': 'الاسم الأول',
          'last_name': 'اسم العائلة',
          'username': 'اسم المستخدم',
          'email': 'البريد الإلكتروني',
          'save_changes': 'حفظ التغييرات',
          'change_password': 'تغيير كلمة المرور',
          'old_password': 'كلمة المرور القديمة',
          'new_password': 'كلمة المرور الجديدة',
          'confirm_new_password': 'تأكيد كلمة المرور الجديدة',
          'required': 'مطلوب',
          'min_6_char': '6 أحرف على الأقل',
          'password_mismatch': 'كلمتا المرور غير متطابقتين',
          'switch_language': 'تبديل اللغة',

          // Viewer
          'preview': 'معاينة',

          // Controller messages
          'profile_updated': 'تم تحديث الملف الشخصي بنجاح',
          'profile_image_updated': 'تم تحديث صورة الملف الشخصي',
          'password_changed_successfully': 'تم تغيير كلمة المرور بنجاح',
          'update_failed': 'فشل التحديث',
          'upload_failed': 'فشل الرفع',
          'change_password_failed': 'فشل تغيير كلمة المرور',
          'login_failed': 'فشل تسجيل الدخول',
          'account_created_please_login': 'تم إنشاء الحساب. يرجى تسجيل الدخول.',
          'password_reset_success': 'تمت إعادة تعيين كلمة المرور. يرجى تسجيل الدخول.',
          'session_expired': 'انتهت صلاحية الجلسة. يرجى تسجيل الدخول مرة أخرى.',

          // Auth screens
          'login': 'تسجيل الدخول',
          'sign_up': 'إنشاء حساب',
          'create_account_to_continue': 'أنشئ حسابًا للمتابعة!',
          'email_required': 'البريد الإلكتروني مطلوب',
          'enter_valid_email': 'أدخل بريدًا إلكترونيًا صالحًا',
          'password_required': 'كلمة المرور مطلوبة',
          'please_wait': 'يرجى الانتظار...',
          'forgot_password': 'نسيت كلمة المرور',
          'forgot_password_q': 'هل نسيت كلمة المرور؟',
          'no_account_sign_up': 'لا تملك حسابًا؟ سجل الآن',
          'already_have_account': 'هل لديك حساب بالفعل؟',
          'min_3_char': '3 أحرف على الأقل',
          'send_otp': 'إرسال الرمز',
          'otp_code': 'رمز التحقق',
          'reset_password': 'إعادة تعيين كلمة المرور',
          'enter_code_email': 'أدخل الرمز المرسل إلى بريدك الإلكتروني',
          'confirm_password': 'تأكيد كلمة المرور',
          'confirm_your_password': 'أكد كلمة المرور',
        },
      };
}

Locale getInitialLocale() {
  // final device = Get.deviceLocale;
  // if (device != null && (device.languageCode == 'ar' || device.languageCode == 'en')) {
  //   return device;
  // }
  return const Locale('ar');
}
