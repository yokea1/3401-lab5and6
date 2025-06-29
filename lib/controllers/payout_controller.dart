import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly_restaurant/constants/constants.dart';
import 'package:foodly_restaurant/models/environment.dart';
import 'package:foodly_restaurant/models/sucess_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class PayoutCotroller extends GetxController {

  RxBool _isLoading = false.obs;
  get isLoading=>_isLoading.value;
  set setIsLoading(bool loading)=>_isLoading.value=loading;

  final box = GetStorage();
  void payout(String data, Function? refetch) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);
    String? restaurantId = box.read('restaurantId');
    _isLoading.value=true;
    if(restaurantId==null){
      _isLoading.value=false;
      return null;
    }else{
      print("restaurant id ${restaurantId}");
    }

    var url = Uri.parse('${Environment.appBaseUrl}/api/restaurant/payout/$restaurantId');

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: data
      );
      var apiResponse = successResponseFromJson(response.body);
      if (response.statusCode == 201) {

        refetch!();
        Get.snackbar(
            apiResponse.message, "Check you email for updates on the progress ",
            colorText: kLightWhite,
            backgroundColor: kPrimary,
            icon: const Icon(SimpleLineIcons.bubbles));
        _isLoading.value=false;
      }else{
        Get.snackbar(
            apiResponse.message
            , "Check you email for updates on the progress ",
            colorText: kLightWhite,
            backgroundColor: kPrimary,
            icon: const Icon(SimpleLineIcons.bubbles));
        _isLoading.value=false;
      }
    } catch (e) {

      debugPrint(e.toString());
      _isLoading.value=false;
    }
  }
}

