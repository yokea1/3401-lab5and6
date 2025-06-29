import 'dart:convert';

import 'package:foodly_restaurant/common/entities/entities.dart';
import 'package:foodly_restaurant/models/driver_model.dart';
import 'package:foodly_restaurant/models/login_response.dart';
import 'package:foodly_restaurant/models/response_model.dart';
import 'package:foodly_restaurant/models/restaurant.dart';
import 'package:foodly_restaurant/services/check_user.dart';

import 'package:foodly_restaurant/views/message/chat/index.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

class ContactState{
  var count = 0.obs;
  RxString driverId = "".obs;
  Rxn<Restaurants> restaurant = Rxn<Restaurants>();
  RxBool loading = false.obs;
  RxList<UserData> contactList = <UserData>[].obs;
}


class ContactController extends GetxController {
  ContactController();

  final ContactState state = ContactState();
  final db = FirebaseFirestore.instance;
  final box = GetStorage();
  String? token;

  @override
  void onReady() {
    super.onReady();
    //this token could be something encrypted
    token = box.read("userId");
    if (token != null) {
      //token = jsonDecode(token!);
    }
  }

  Future<ResponseModel> goChat(Driver to_userdata) async {
    String? token = box.read("userId");
    token = jsonDecode(token!);
    if(token==null){
      return ResponseModel(isSuccess: false, message: "You don't exist", title: "Token issue");
    }
    if(token == state.driverId.value){
      return ResponseModel(isSuccess: false, message: "You can not chat to yourself", title: "Token issue");
    }

    bool appUser = CheckUser.isValidId(token);
    if(appUser==false){
      return ResponseModel(isSuccess: false, message: "Corrupted user account", title: "Serious issue");
    }
    to_userdata.id = state.driverId.value;
    bool restaurantOwner = CheckUser.isValidId(to_userdata.id!);

    if(to_userdata.id==null){
      return ResponseModel(isSuccess: false, message: "Restaurant may not exist, try another shop");
    }
    if(restaurantOwner==false){
      return ResponseModel(isSuccess: false, message: "Corrupted restaurant account", title: "Serious issue");

    }
    var from_messages = await db
        .collection("message")
        .withConverter(
        fromFirestore: Msg.fromFirestore,
        toFirestore: (Msg msg, options) => msg.toFirestore())
        .where("from_uid", isEqualTo: token) //and condition
        .where("to_uid", isEqualTo: to_userdata.id)
        .get();
    var to_messages = await db
        .collection("message")
        .withConverter(
        fromFirestore: Msg.fromFirestore,
        toFirestore: (Msg msg, options) => msg.toFirestore())
        .where("from_uid", isEqualTo: to_userdata.id)
        .where("to_uid", isEqualTo: token)
        .get();
    if (from_messages.docs.isEmpty) {
      print("Empty chat list");
    } else {
      print("Chat id is ${from_messages.docs.first.id}");
    }
/*
    if (from_messages.docs.isEmpty && to_messages.docs.isEmpty) {
      String? data = box.read("user");
      if(data==null){
        return ResponseModel(isSuccess: false, message: "Try to login again",title: "Login");
      }
      LoginResponse userdata = LoginResponse.fromJson(jsonDecode(data));
      print("inserting---------");
      var msgdata = Msg(
          from_uid: userdata.id,
          to_uid: to_userdata.owner,
          from_name: userdata.username,
          to_name: to_userdata.title,
          from_avatar: userdata.profile,
          to_avatar: to_userdata.imageUrl,
          last_msg: "",
          last_time: Timestamp.now(),
          msg_num: 0);
      await db
          .collection("message")
          .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (Msg msg, options) => msg.toFirestore())
          .add(msgdata)
          .then((value) {
        Get.to(const ChatPage(), arguments: {
          "doc_id": value.id,
          "to_uid": to_userdata.id ?? "",
          "to_name": to_userdata.title ?? "",
          "to_avatar": to_userdata.logoUrl ?? ""
        });
      });
      return ResponseModel(isSuccess: true, message: "");

    } else {
      if (from_messages.docs.isNotEmpty) {
        Get.to(const ChatPage(), arguments: {
          "doc_id": from_messages.docs.first.id,
          "to_uid": to_userdata.id ?? "",
          "to_name": to_userdata.title ?? "",
          "to_avatar": to_userdata.logoUrl ?? ""
        });
      }
      if (to_messages.docs.isNotEmpty) {
        Get.to(const ChatPage(), arguments: {
          "doc_id": to_messages.docs.first.id,
          "to_uid": to_userdata.id ?? "",
          "to_name": to_userdata.title ?? "",
          "to_avatar": to_userdata.logoUrl ?? ""
        });
      }
      return ResponseModel(isSuccess: true,);

    }*/
    return ResponseModel(isSuccess: true);
  }

  Future<ResponseModel> asyncLoadSingleDriver() async {
    // Retrieve the userId from storage
    final userId = box.read("userId");
    if(userId==null){
      return ResponseModel(isSuccess: false, message: "You did not login", title: "Login issue");
    }else{
      print("userId $userId");
    }
    final decodedUserId = userId;//jsonDecode(userId).toString();
    final driverId = state.driverId.value;
    print("Raw user id from storage: $userId");
    print("Decoded user id: $decodedUserId");
    print("driverId id : $driverId");
    state.contactList.clear();
    // Query the Firestore collection
    var usersbase = await db
        .collection("users")
        .where("id", isNotEqualTo: decodedUserId)
        .withConverter(
      fromFirestore: UserData.fromFirestore,
      toFirestore: (UserData userdata, options) => userdata.toFirestore(),
    )
        .get();
    state.contactList.add(usersbase.docs[0].data());
    print("${usersbase.docs[0].data().toFirestore()}");
    return ResponseModel(isSuccess: true);
  }
  Future<ResponseModel> asyncLoadMultipleRestaurant() async {
    // Retrieve the userId from storage

    final userId = box.read("userId");
    if(userId==null){
      return ResponseModel(isSuccess: false, message: "You did not login");
    }
    final decodedUserId = jsonDecode(userId).toString();
    final driverId = state.driverId.value;
    print("Raw user id from storage: $userId");
    print("Decoded user id: $decodedUserId");
    print("driverId id : $driverId");
    // Query the Firestore collection
    var usersbase = await db
        .collection("users")
        .where("id", isNotEqualTo: decodedUserId)
        .withConverter(
      fromFirestore: UserData.fromFirestore,
      toFirestore: (UserData userdata, options) => userdata.toFirestore(),
    )
        .get();
    state.contactList.clear();
    for(var item in usersbase.docs){
      state.contactList.add(item.data());
    }
    //state.contactList.add(usersbase.docs[0].data());
    print("${usersbase.docs[0].data().toFirestore()}");
    return ResponseModel(isSuccess: true);
  }
}

