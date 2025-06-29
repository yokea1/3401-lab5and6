import 'package:foodly_restaurant/common/common_appbar.dart';
import 'package:foodly_restaurant/common/values/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_restaurant/constants/constants.dart';
import 'package:foodly_restaurant/views/message/index.dart';

import 'chat/widgets/message_list.dart';
import 'package:get/get.dart';
class MessagePage extends StatelessWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MessageController());
    return Scaffold(
      appBar: CommonAppBar(
        titleText: "Message"
      ),
      body: const MessageList(),
    );
  }
}
