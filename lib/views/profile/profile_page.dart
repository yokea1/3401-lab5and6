import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly_restaurant/common/app_style.dart';
import 'package:foodly_restaurant/common/common_appbar.dart';
import 'package:foodly_restaurant/common/custom_btn.dart';
import 'package:foodly_restaurant/constants/constants.dart';
import 'package:foodly_restaurant/controllers/login_controller.dart';
import 'package:foodly_restaurant/controllers/login_response.dart';
import 'package:foodly_restaurant/views/auth/widgets/login_redirect.dart';
import 'package:foodly_restaurant/views/home/wallet_page.dart';
import 'package:foodly_restaurant/views/home/widgets/back_ground_container.dart';
import 'package:foodly_restaurant/views/profile/widgets/tile_widget.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    LoginResponse? user;
    final box = GetStorage();
    String? token = box.read('token');

    final controller = Get.put(LoginController());

    if (token != null) {
      user = controller.getUserData();
    }

    return token == null
        ? const LoginRedirection()
        : Scaffold(
      appBar: CommonAppBar(titleText: "Profile"),
      body: BackGroundContainer(
        color: kOffWhite,
        child: Column(
          children: [
            Container(
              height: 926.h * 0.06,
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 0, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 35,
                          width: 35,
                          child: CircleAvatar(
                            backgroundColor: Colors.grey.shade100,
                            backgroundImage: NetworkImage(user!.profile),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.username,
                                style: appStyle(
                                  kFontSizeBodyRegular, // Use predefined font size
                                  kGray,
                                  FontWeight.w600,
                                ),
                              ),
                              Text(
                                user.email,
                                style: appStyle(
                                  kFontSizeSubtext, // Use predefined font size
                                  kGray,
                                  FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.only(top: 12.0.h),
                        child: const Icon(Feather.edit, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 926.h * 0.24,
              decoration: const BoxDecoration(color: Colors.white),
              child: ListView(
                children: [
                  DbestTilesWidget(
                    onTap: () {
                      Get.to(
                            () => const WalletPage(),
                        transition: Transition.fade,
                        duration: const Duration(seconds: 2),
                      );
                    },
                    title: "Wallet",
                    leading: MaterialCommunityIcons.wallet_outline,
                  ),
                  DbestTilesWidget(
                    onTap: () {},
                    title: "Service Center",
                    leading: AntDesign.customerservice,
                  ),
                  const DbestTilesWidget(
                    title: "App Feedback",
                    leading: MaterialIcons.rss_feed,
                  ),
                  DbestTilesWidget(
                    onTap: () {},
                    title: "Settings",
                    leading: AntDesign.setting,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.h),
              child: CustomButton(
                onTap: () {
                  controller.logout();
                },
                text: "Logout",
                radius: 10,
                color: kPrimary,
                btnHieght: 40.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
