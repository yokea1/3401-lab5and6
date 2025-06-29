import 'package:flutter/material.dart';
import 'package:foodly_restaurant/constants/constants.dart';

class CustomDialogDbestech extends StatelessWidget {
  final String title;
  final String description;
  final String closeButtonText;
  final String okButtonText;
  final VoidCallback onOkPressed;
  final Color backgroundColor;
  final Color buttonColor;
  bool? okButtonShow;

  CustomDialogDbestech({
    Key? key,
    required this.title,
    required this.description,
    required this.closeButtonText,
    required this.okButtonText,
    required this.onOkPressed,
    this.backgroundColor = kWhite,
    this.buttonColor = kPrimary,
    this.okButtonShow=false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: backgroundColor,
      title: Text(title),
      content: Text(description),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          style: TextButton.styleFrom(
            foregroundColor: kPrimary, // Text color for close button
          ),
          child: Text(closeButtonText),
        ),
        okButtonShow==true?TextButton(
          onPressed: onOkPressed,
          style: TextButton.styleFrom(
            foregroundColor: buttonColor, // Text color for OK button
          ),
          child: Text(okButtonText),
        ):const SizedBox.shrink(),
      ],
    );
  }
}
