import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_ai/controllers/Auth/auth_controller.dart';
import 'package:image_ai/routes/screen_name.dart';
import 'package:image_ai/view/style/app_text.dart';
import 'package:image_ai/view/widget/common/custom_button.dart';
import 'package:image_ai/view/widget/common/custom_input.dart';
import 'package:image_ai/view/widget/common/fancy_background.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _email = TextEditingController();
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final auth = Get.find<AuthController>();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    try {
      await auth.forgotPassword(_email.text.trim());
      Get.toNamed(RoutesName.resetPassword, arguments: {'email': _email.text.trim()});
    } catch (e) {
      Get.snackbar('error'.tr, e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FancyGradientBackground(
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          height: 300,
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white, style: BorderStyle.solid, strokeAlign: BorderSide.strokeAlignInside),
            color: Colors.white.withOpacity(0.6),
          ),
          child: Form(
            key: _formKey,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('forgot_password'.tr, style: AppText.bold24.copyWith(fontSize: 28)),
              const SizedBox(height: 16),
              CustomTextInput(
                hintText: 'email'.tr,
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (v) {
                  final value = (v ?? '').trim();
                  if (value.isEmpty) return 'email_required'.tr;
                  final emailRegex = RegExp(r'^\S+@\S+\.\S+$');
                  if (!emailRegex.hasMatch(value)) return 'enter_valid_email'.tr;
                  return null;
                },
              ),
              const SizedBox(height: 12),
              CustomButton(text: _loading ? 'please_wait'.tr : 'send_otp'.tr, onPressed: _loading ? null : _submit),
            ],
          )),
        ),
      ),
    );
  }
}
