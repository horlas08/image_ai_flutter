import 'package:flutter/material.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_ai/controllers/Auth/auth_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_ai/view/style/app_text.dart';
import 'package:image_ai/view/style/app_color.dart';
import 'package:image_ai/view/widget/common/custom_input.dart';
import 'package:image_ai/view/widget/common/custom_button.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  final _pwFormKey = GlobalKey<FormState>();

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _username = TextEditingController();
  final _email = TextEditingController();

  final _oldPassword = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool _savingProfile = false;
  bool _changingPassword = false;
  bool _uploadingAvatar = false;

  @override
  void initState() {
    super.initState();
    final auth = Get.find<AuthController>();
    final u = auth.user.value;
    _firstName.text = u?.firstName ?? '';
    _lastName.text = u?.lastName ?? '';
    _username.text = u?.username ?? '';
    _email.text = u?.email ?? '';
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _username.dispose();
    _email.dispose();
    _oldPassword.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image == null) return;
    final auth = Get.find<AuthController>();
    try {
      setState(() => _uploadingAvatar = true);
      await auth.uploadAvatar(File(image.path));
    } catch (_) {}
    if (mounted) setState(() => _uploadingAvatar = false);
  }

  Future<void> _submitProfile() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _savingProfile = true);
    final auth = Get.find<AuthController>();
    try {
      await auth.updateProfile(
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
      );
    } finally {
      if (mounted) setState(() => _savingProfile = false);
    }
  }

  Future<void> _submitPassword() async {
    if (!(_pwFormKey.currentState?.validate() ?? false)) return;
    setState(() => _changingPassword = true);
    final auth = Get.find<AuthController>();
    try {
      await auth.changePassword(
        oldPassword: _oldPassword.text,
        newPassword: _newPassword.text,
      );
      _oldPassword.clear();
      _newPassword.clear();
      _confirmPassword.clear();
    } finally {
      if (mounted) setState(() => _changingPassword = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return Obx(() {
      final u = auth.user.value;
      final avatar = u?.avatarUrl;
      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: (avatar != null && avatar.isNotEmpty)
                        ? NetworkImage(avatar)
                        : null,
                    child: (avatar == null || avatar.isEmpty)
                        ? Icon(
                            Icons.person,
                            size: 48,
                            color: Colors.grey.shade700,
                          )
                        : null,
                  ),
                  Positioned(
                    right: -4,
                    bottom: -4,
                    child: GestureDetector(
                      onTap: _uploadingAvatar ? null : _pickAndUploadImage,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: _uploadingAvatar
                            ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 18,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Text('profile'.tr, style: AppText.bold24.copyWith(fontSize: 22)),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'switch_language'.tr,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Builder(
                  builder: (context) {
                    final isArabic = (Get.locale?.languageCode ?? 'ar') == 'ar';
                    return Switch(
                      value: isArabic,
                      onChanged: (val) {
                        final next = val
                            ? const Locale('ar')
                            : const Locale('en');
                        Get.updateLocale(next);
                        setState(() {});
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextInput(
                    hintText: 'first_name'.tr,
                    controller: _firstName,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'required'.tr : null,
                  ),
                  CustomTextInput(
                    hintText: 'last_name'.tr,
                    controller: _lastName,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'required'.tr : null,
                  ),
                  CustomTextInput(
                    hintText: 'email'.tr,
                    controller: _email,
                    enabled: false,
                  ),
                  const SizedBox(height: 10),
                  CustomButton(
                    text: _savingProfile
                        ? 'save_changes'.tr
                        : 'save_changes'.tr,
                    onPressed: _savingProfile ? null : _submitProfile,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),
            Text(
              'change_password'.tr,
              style: AppText.bold24.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 8),
            Form(
              key: _pwFormKey,
              child: Column(
                children: [
                  CustomTextInput(
                    hintText: 'old_password'.tr,
                    controller: _oldPassword,
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'required'.tr : null,
                  ),
                  CustomTextInput(
                    hintText: 'new_password'.tr,
                    controller: _newPassword,
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (v) {
                      final value = v ?? '';
                      if (value.isEmpty) return 'required'.tr;
                      if (value.length < 6) return 'min_6_char'.tr;
                      return null;
                    },
                  ),
                  CustomTextInput(
                    hintText: 'confirm_new_password'.tr,
                    controller: _confirmPassword,
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (v) => (v ?? '') != _newPassword.text
                        ? 'password_mismatch'.tr
                        : null,
                  ),
                  const SizedBox(height: 10),
                  CustomButton(
                    text: _changingPassword
                        ? 'change_password'.tr
                        : 'change_password'.tr,
                    onPressed: _changingPassword ? null : _submitPassword,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
