import 'dart:developer' as developer;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_restaurant/constants/constants.dart';
import 'package:foodly_restaurant/firebase_options.dart';
import 'package:foodly_restaurant/models/environment.dart';
import 'package:foodly_restaurant/services/notification_service.dart';
import 'package:foodly_restaurant/views/auth/login_page.dart';
import 'package:foodly_restaurant/views/auth/verification_page.dart';
import 'package:foodly_restaurant/views/auth/waiting_page.dart';
import 'package:foodly_restaurant/views/home/home_page.dart';
import 'package:foodly_restaurant/views/order/notifications_active_order.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';



Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  print(
      "onBackground: ${message.notification?.title}/${message.notification?.body}/${message.notification?.titleLocKey}");
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Widget defaultHome = const Login();

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  await dotenv.load(fileName: Environment.fileName);
  if(GetPlatform.isAndroid)
    await NotificationService().initialize(flutterLocalNotificationsPlugin);
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    String? token = box.read('token');
    String? restaurantId = box.read('restaurantId');
    String? verification = box.read("verification");
    bool? emailVerification = box.read("e-verification");

    if (token == null) {
      defaultHome = const Login();
    } else if (token != null && restaurantId == null) {
      defaultHome = const Login();
    }else if (token != null &&  emailVerification == false || emailVerification == null) {
      defaultHome = const VerificationPage();
    }  else if (restaurantId != null &&  verification == "Verified") {
      defaultHome = const HomePage();
    } else if (restaurantId != null && verification != "Verified") {
      defaultHome = const WaitingPage();
    }

    return ScreenUtilInit(
        useInheritedMediaQuery: true,
        designSize: const Size(428, 926),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Foodly Restaurant App',
            theme: ThemeData(
              scaffoldBackgroundColor: kOffWhite,
              iconTheme: const IconThemeData(color: kDark),
              primarySwatch: Colors.grey,
            ),
            home: defaultHome,
            navigatorKey: navigatorKey,
            routes: {
              '/order_details_page': (context) => const NotificationOrderPage(),
            },
          );
        });
  }
}
