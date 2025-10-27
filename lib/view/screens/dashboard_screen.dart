import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_ai/controllers/Auth/auth_controller.dart';
import 'package:image_ai/controllers/AI/ai_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../style/app_color.dart';
import '../widget/common/custom_button.dart';
import 'User/history.dart';
import 'User/profile.dart';

final bottomView = [
  History(),
  Profile(),
];
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _bottomNavIndex = 0;
  late final AIController _ai;

  @override
  void initState() {
    super.initState();
    // Ensure AIController is available and shares ApiClient with Auth
    _ai = Get.put(AIController(), permanent: true);
  }

  Future<void> _openRedesignSheet() async {
    File? pickedFile;
    String? style;
    final styles = ['modern', 'minimalist', 'luxury', 'industrial', 'scandinavian'];

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setModalState) {
          Future<void> pickImage() async {
            final x = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 90);
            if (x != null) {
              setModalState(() => pickedFile = File(x.path));
            }
          }

          Future<void> submit() async {
            if (pickedFile == null || style == null) return;
            try {
              await _ai.redesignRoom(originalImage: pickedFile!, styleChoice: style!);
              if (!mounted) return;
              Navigator.of(ctx).pop();
              setState(() => _bottomNavIndex = 0);
              Get.snackbar('Success', 'Room redesign requested', snackPosition: SnackPosition.BOTTOM);
            } catch (e) {
              Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
            }
          }

          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Text('room_redesign'.tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                      const Spacer(),
                      IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(ctx).pop()),
                    ],
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColor.primaryColor),
                      ),
                      child: Center(
                        child: pickedFile == null
                            ? Text('tap_to_select_room_image'.tr)
                            : Image.file(pickedFile!, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: style,
                    items: styles
                        .map((e) => DropdownMenuItem<String>(value: e, child: Text(e.tr)))
                        .toList(),
                    onChanged: (v) => setModalState(() => style = v),
                    decoration: InputDecoration(
                      labelText: 'style_choice'.tr,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12.5,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xFFEDF1F3),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xFFEDF1F3),
                          width: 1,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    onPressed: (pickedFile != null && style != null) ? submit : null,

                    text: 'redesign'.tr,

                  ),

                ],
              ),
            ),
          );
        });
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final iconList = ["assets/svg/home.svg", "assets/svg/user.svg"];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Obx(() {
          final user = auth.user.value;
          final name = user?.firstName ?? '';
          return Text(
            name.isNotEmpty ? 'hi_name'.trParams({'name': name}) : 'dashboard'.tr,
            style: TextStyle(fontWeight: FontWeight.bold),
          );
        }),
        actions: [
          GestureDetector(
            onTap: () async {
              await auth.logout();
              Get.offAllNamed('/login');
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: CircleAvatar(
                backgroundColor: AppColor.bottomBgColor,
                child:const Icon(Icons.logout, color: Colors.white, size: 25,),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _bottomNavIndex != 3
          ? FloatingActionButton(
              onPressed: _openRedesignSheet,
              backgroundColor: AppColor.bottomBgColor,
              child: Icon(Icons.add, color: Colors.white, size: 25),
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(1000),
                borderSide: BorderSide.none,
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        height: 72,

        tabBuilder: (int index, bool isActive) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconList[index],
                width: 25,
                height: 25,
                fit: BoxFit.scaleDown,
                color: Colors.white,
              ),
              // SizedBox(height: 5),
              // Text(
              //   _navNames[index],
              //   style: TextStyle(
              //     color: isActive ? AppColor.primaryColor : null,
              //   ),
              // ),
            ],
          );
        },

        backgroundColor: AppColor.bottomBgColor,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.smoothEdge,
        leftCornerRadius: 0,
        rightCornerRadius: 0,
        hideAnimationCurve: ElasticInOutCurve(),
        onTap: (index) => setState(() => _bottomNavIndex = index),
        //other params
      ),
      body: Obx(() {
        final user = auth.user.value;
        if (user == null) {
          return const Center(child: Text('Welcome!'));
        }
        final fn = user.firstName ?? '';
        return SingleChildScrollView(
          child: bottomView[_bottomNavIndex],
        );
      }),
    );
  }
}
