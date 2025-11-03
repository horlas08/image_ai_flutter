import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_ai/controllers/Auth/auth_controller.dart';
import 'package:image_ai/routes/screen_name.dart';
import 'package:image_ai/view/style/app_text.dart';
import 'package:image_ai/view/widget/common/custom_button.dart';
import 'package:image_ai/view/widget/common/custom_input.dart';
import 'package:image_ai/view/widget/common/fancy_background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _doLogin() async {
    final auth = Get.find<AuthController>();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    try {
      await auth.login(_email.text.trim(), _password.text);
      Get.offAllNamed(RoutesName.dashboard);
    } catch (e) {
      Get.snackbar('login_failed'.tr, e.toString(), snackPosition: SnackPosition.BOTTOM);
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
          height: 420,
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
              const SizedBox(height: 8),
              Text('login'.tr, style: AppText.bold24.copyWith(fontSize: 32)),
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
              CustomTextInput(
                hintText: 'new_password'.tr,
                controller: _password,
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (v) {
                  final value = v ?? '';
                  if (value.isEmpty) return 'password_required'.tr;
                  if (value.length < 6) return 'min_6_char'.tr;
                  return null;
                },
              ),
              const SizedBox(height: 12),
              CustomButton(text: _loading ? 'please_wait'.tr : 'login'.tr, onPressed: _loading ? null : _doLogin),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => Get.toNamed(RoutesName.forgotPassword),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text('forgot_password_q'.tr, style: AppText.medium12.copyWith(color: Colors.deepPurple)),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Get.toNamed(RoutesName.register),
                child: Center(
                  child: Text('no_account_sign_up'.tr, style: AppText.medium12.copyWith(color: Colors.deepPurple)),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Get.offAllNamed(RoutesName.dashboard),
                child: Text('skip_for_now'.tr),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
