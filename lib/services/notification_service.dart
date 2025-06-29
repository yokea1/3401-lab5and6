// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:foodly_restaurant/controllers/notifications_controller.dart';
import 'package:foodly_restaurant/main.dart';
import 'package:get/get.dart';

class NotificationService {
  final controller = Get.put(NotificationsController());
  final _messaging = FirebaseMessaging.instance;

  Future<void> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
    const AndroidInitializationSettings('notification_icon');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationSettings =
    InitializationSettings(android: androidInitialize, iOS: iOSInitialize);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (data) {
          try {
            if (data.payload != null && data.payload!.isNotEmpty) {
              navigatorKey.currentState
                  ?.pushNamed('/order_details_page', arguments: data);
            }
          } catch (e) {
            print("Error navigating from notification: $e");
          }
        });

    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    final token = await _messaging.getToken();
    if (token != null) {
      controller.setFcm = token;
    }

    initPushNotification();
  }

  void handleMessage(RemoteMessage? message) {
    if (message?.notification != null) {
      navigatorKey.currentState
          ?.pushNamed('/order_details_page', arguments: message);
    }
  }

  void initPushNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      controller.newOrdersController.setTriggerReload();

      print("onMessage: ${message.notification?.title}/${message.notification?.body}");

      String orderData = jsonEncode(message.data);
      showBigTextNotification(
        message.notification!.title!,
        message.notification!.body!,
        orderData,
        flutterLocalNotificationsPlugin,
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onOpenApp: ${message.notification?.title}/${message.notification?.body}");
    });
  }

  static Future<void> showBigTextNotification(
      String title,
      String body,
      String orderID,
      FlutterLocalNotificationsPlugin fln) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      body,
      htmlFormatBigText: true,
      contentTitle: title,
      htmlFormatContentTitle: true,
    );

    AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'channel_id_5',
      'foodly_flutter',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: bigTextStyleInformation,
      playSound: true,
    );

    NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await fln.show(0, title, body, platformChannelSpecifics,
        payload: orderID);
  }
}
