import 'package:flutter/material.dart';
import 'package:image_ai/view/style/app_color.dart';
import 'package:image_ai/view/style/app_text.dart';
import 'package:image_ai/view/widget/common/custom_button.dart';
import 'package:image_ai/view/widget/common/custom_input.dart';
import 'package:get/get.dart';
import 'package:image_ai/routes/screen_name.dart';
import 'package:image_ai/controllers/Auth/auth_controller.dart';

import '../../widget/common/fancy_background.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _username.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  Future<void> _validateAndSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final auth = Get.find<AuthController>();
    setState(() => _loading = true);
    try {
      await auth.register(
        email: _email.text.trim(),
        password: _password.text,
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        username: _username.text.trim(),
      );
      Get.offAllNamed(RoutesName.login);
    } catch (e) {
      // Error snackbar already shown in controller; ensure not to crash
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FancyGradientBackground(
      child: Center(
        child: Stack(
          fit: StackFit.loose,
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                height: 620,
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(

                  borderRadius: BorderRadius.circular(12),

                  border: Border.all(
                    color: Colors.white,
                    style: BorderStyle.solid,
                    strokeAlign: BorderSide.strokeAlignInside,
                  ),
                  color: Colors.white.withOpacity(0.6),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    Text('sign_up'.tr, style: AppText.bold24.copyWith(fontSize: 32)),
                    SizedBox(height: 12),
                    Text('create_account_to_continue'.tr, style: AppText.regular12),
                    SizedBox(height: 24),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextInput(
                            hintText: 'first_name'.tr,
                            controller: _firstName,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (v) {
                              final value = (v ?? '').trim();
                              if (value.isEmpty) return 'required'.tr;
                              return null;
                            },
                          ),
                          CustomTextInput(
                            hintText: 'last_name'.tr,
                            controller: _lastName,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (v) {
                              final value = (v ?? '').trim();
                              if (value.isEmpty) return 'required'.tr;
                              return null;
                            },
                          ),
                          CustomTextInput(
                            hintText: 'username'.tr,
                            controller: _username,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (v) {
                              final value = (v ?? '').trim();
                              if (value.isEmpty) return 'required'.tr;
                              if (value.length < 3) return 'min_3_char'.tr;
                              return null;
                            },
                          ),
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
                          CustomTextInput(
                            hintText: 'confirm_password'.tr,
                            controller: _confirmPassword,
                            obscureText: true,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (v) {
                              final value = v ?? '';
                              if (value.isEmpty) return 'confirm_your_password'.tr;
                              if (value != _password.text) return 'password_mismatch'.tr;
                              return null;
                            },
                          ),
                          SizedBox(height: 18),
                          CustomButton(text: _loading ? 'please_wait'.tr : 'sign_up'.tr, onPressed: _loading ? null : _validateAndSubmit),
                          SizedBox(height: 24),
                          Text.rich(
                            TextSpan(
                              text: 'already_have_account'.tr,
                              children: [
                                WidgetSpan(child: SizedBox(width: 6)),
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () => Get.toNamed(RoutesName.login),
                                    child: Text(
                                      'login'.tr,
                                      style: AppText.medium12.copyWith(
                                        color: AppColor.primaryColor,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            style: AppText.medium12,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
