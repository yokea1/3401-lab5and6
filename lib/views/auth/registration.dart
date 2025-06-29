import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_restaurant/common/app_style.dart';
import 'package:foodly_restaurant/common/custom_btn.dart';
import 'package:foodly_restaurant/common/utils/show_snackbar.dart';
import 'package:foodly_restaurant/common/utils/validator.dart';
import 'package:foodly_restaurant/constants/constants.dart';
import 'package:foodly_restaurant/controllers/registration_controller.dart';
import 'package:foodly_restaurant/models/registration.dart';
import 'package:foodly_restaurant/views/auth/widgets/email_textfield.dart';
import 'package:foodly_restaurant/views/auth/widgets/password_field.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();
  late final TextEditingController _usernameController =
      TextEditingController();

  final FocusNode _passwordFocusNode = FocusNode();
  final _loginFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  bool validateAndSave() {
    final form = _loginFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegistrationController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          padding: EdgeInsets.only(top: 5.w),
          height: 50.h,
          child: Text(
            "Foodly Family",
            style: appStyle(24, kPrimary, FontWeight.bold),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 30.h,
          ),
          Lottie.asset('assets/anime/delivery.json'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: _loginFormKey,
              child: Column(
                children: [
                  //email
                  EmailTextField(
                    focusNode: _passwordFocusNode,
                    hintText: "Username",
                    controller: _usernameController,
                    prefixIcon: Icon(
                      CupertinoIcons.person,
                      color: Theme.of(context).dividerColor,
                      size: 20.h,
                    ),
                    keyboardType: TextInputType.text,
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(_passwordFocusNode),
                  ),

                  SizedBox(
                    height: 15.h,
                  ),

                  EmailTextField(
                    focusNode: _passwordFocusNode,
                    hintText: "Email",
                    controller: _emailController,
                    prefixIcon: Icon(
                      CupertinoIcons.mail,
                      color: Theme.of(context).dividerColor,
                      size: 20.h,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(_passwordFocusNode),
                  ),

                  SizedBox(
                    height: 15.h,
                  ),

                  PasswordField(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                  ),

                  SizedBox(
                    height: 6.h,
                  ),

                  SizedBox(
                    height: 12.h,
                  ),

                  Obx(
                    () => controller.isLoading
                        ? const Center(
                            child: CircularProgressIndicator.adaptive(
                              backgroundColor: kPrimary,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(kLightWhite),
                          ))
                        : CustomButton(
                            btnHieght: 37.h,
                            color: kPrimary,
                            text: "R E G I S T E R",
                            onTap: () {

                              // Validation
                              String? usernameError = ValidationUtils.validateUsername(_usernameController.text);
                              String? emailError = ValidationUtils.validateEmail(_emailController.text);
                              String? passwordError = ValidationUtils.validatePassword(_passwordController.text);

                              if (usernameError != null) {
                                showCustomSnackBar(usernameError);
                                return;
                              }

                              if (emailError != null) {
                                showCustomSnackBar(emailError);
                                return;
                              }

                              if (passwordError != null) {
                                showCustomSnackBar(passwordError);
                                return;
                              }

                              Registration model = Registration(
                                  username: _usernameController.text,
                                  email: _emailController.text,
                                  password: _passwordController.text);

                              String userdata = registrationToJson(model);

                              controller.registration(userdata);
                            }),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
