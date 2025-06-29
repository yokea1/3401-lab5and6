// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:foodly_restaurant/common/services/auth_services_dbestech.dart';
import 'package:foodly_restaurant/common/utils/show_snackbar.dart';
import 'package:foodly_restaurant/constants/constants.dart';
import 'package:foodly_restaurant/models/api_error.dart';
import 'package:foodly_restaurant/models/environment.dart';
import 'package:foodly_restaurant/models/sucess_model.dart';
import 'package:foodly_restaurant/views/auth/login_page.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
class RegistrationController extends GetxController {
  RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set setLoading(bool newValue) {
    _isLoading.value = newValue;
  }

  void registration(String model) async {
    setLoading = true;

    try {
      var response = await AuthServiceDbestech.postRequest('register', model);

      if (response.statusCode == 201) {
        var data = successResponseFromJson(response.body);
        showCustomSnackBar(data.message, title: "Proceed to Login", isError: false);

        Get.to(() => const Login(),
            transition: Transition.fade, duration: const Duration(seconds: 2));
      } else {
        var data = apiErrorFromJson(response.body);
        showCustomSnackBar(data.message, title: "Failed to login, please try again");
      }
    } catch (e) {
      showCustomSnackBar(e.toString(), title: "Failed to login, please try again");
    } finally {
      setLoading = false;
    }
  }
}


/*class RegistrationController extends GetxController {
  RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set setLoading(bool newValue) {
    _isLoading.value = newValue;
  }

  void registration(String model) async {
    setLoading = true;
    var url = Uri.parse('${Environment.appBaseUrl}/register');

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: model,
      );

      if (response.statusCode == 201) {
        var data = successResponseFromJson(response.body);
        setLoading = false;
        showCustomSnackBar(data.message, title: "Proceed to Login", isError: false);


        Get.to(() => const Login(),
            transition: Transition.fade, duration: const Duration(seconds: 2));
      } else {
        var data = apiErrorFromJson(response.body);
        showCustomSnackBar(data.message, title: "Failed to login, please try again");

      }
    } catch (e) {
      setLoading = false;
      showCustomSnackBar(e.toString(), title: "Failed to login, please try again");

    } finally {
      setLoading = false;
    }
  }
}*/
