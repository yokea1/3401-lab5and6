import 'package:flutter/material.dart';
import 'package:foodly_restaurant/constants/constants.dart';
import 'package:get/get.dart';
void showCustomSnackBar(String message, {bool isError = true, String title="Errors"}) {

  Get.snackbar(
      icon:  isError==true?const Icon(Icons.error):const Icon(Icons.thumb_up),
      title,
      message,
      titleText: Text(title, style: const TextStyle(color: Colors.white, fontSize: 20),),
      messageText: Text(message, style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      backgroundColor: isError?kSecondary:kOffWhite
  );
}

void handleApiError(String message) {
  showCustomSnackBar(message);
}
