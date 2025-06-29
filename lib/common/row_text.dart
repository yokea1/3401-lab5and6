import 'package:flutter/material.dart';
import 'package:foodly_restaurant/common/app_style.dart';
import 'package:foodly_restaurant/common/reusable_text.dart';
import 'package:foodly_restaurant/constants/constants.dart';

class RowText extends StatelessWidget {
  const RowText(
      {super.key, required this.first, required this.second, this.color});

  final String first;
  final String second;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ReusableText(text: first, style: appStyle(kFontSizeBodySmall, color ?? kGray , FontWeight.w500)),
        SizedBox(
          width: width*0.6,
          child: Text(
              second,
              style: appStyle(kFontSizeBodySmall, color ?? kGray, color != null ? FontWeight.w400 : FontWeight.w400)),
        )
      ],
    );
  }
}
