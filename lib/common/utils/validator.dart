// utils/validation_utils.dart
import 'package:get/get.dart';
class ValidationUtils {
  static String? validateUsername(String username) {
    if (username.isEmpty) {
      return "Username cannot be empty";
    }
    if (username.length < 6) {
      return "Your name is too short";
    }

    // Check if username contains any numbers or special characters
    RegExp regex = RegExp(r'^[a-zA-Z]+$'); // Only allows alphabets (A-Z, a-z)
    if (!regex.hasMatch(username)) {
      return "Username cannot contain numbers or special characters";
    }

    return null;
  }

  static String? validateEmail(String email) {
    if (email.isEmpty) {
      return "Email cannot be empty";
    } else if (!GetUtils.isEmail(email)) {
      return "Please enter a valid email";
    }
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return "Password cannot be empty";
    } else if (password.length < 6) {
      return "Password should be at least 6 characters";
    }
    return null;
  }
}



/// 检查邮箱格式
bool duIsEmail(String? input) {
  if (input == null || input.isEmpty) return false;
  // 邮箱正则
  String regexEmail = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";
  return RegExp(regexEmail).hasMatch(input);
}

/// 检查字符长度
bool duCheckStringLength(String? input, int length) {
  if (input == null || input.isEmpty) return false;
  return input.length >= length;
}
