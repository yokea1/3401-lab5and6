import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly_restaurant/common/app_style.dart';
import 'package:foodly_restaurant/common/custom_appbar.dart';
import 'package:foodly_restaurant/common/reusable_text.dart';
import 'package:foodly_restaurant/common/tab_widget.dart';
import 'package:foodly_restaurant/common/utils/show_snackbar.dart';
import 'package:foodly_restaurant/constants/constants.dart';
import 'package:foodly_restaurant/controllers/order_controller.dart';
import 'package:foodly_restaurant/controllers/restaurant_controller.dart';
import 'package:foodly_restaurant/views/home/add_foods.dart';
import 'package:foodly_restaurant/views/home/foods_page.dart';
import 'package:foodly_restaurant/views/home/restaurant_orders/cancelled_orders.dart';
import 'package:foodly_restaurant/views/home/restaurant_orders/picked_orders.dart';
import 'package:foodly_restaurant/views/home/restaurant_orders/preparing.dart';
import 'package:foodly_restaurant/views/home/restaurant_orders/delivered.dart';
import 'package:foodly_restaurant/views/home/restaurant_orders/new_orders.dart';
import 'package:foodly_restaurant/views/home/restaurant_orders/ready_for_pick_up.dart';
import 'package:foodly_restaurant/views/home/restaurant_orders/self_deliveries.dart';
import 'package:foodly_restaurant/views/home/self_delivered_page.dart';
import 'package:foodly_restaurant/views/home/wallet_page.dart';
import 'package:foodly_restaurant/views/home/widgets/back_ground_container.dart';
import 'package:foodly_restaurant/views/message/index.dart';
import 'package:foodly_restaurant/views/sales/sales_data.dart';
import 'package:get/get.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_storage/get_storage.dart';


class HomePage extends StatefulHookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 7,
    vsync: this,
  );

  bool _isNavigating = false;

  void handleRestaurantIdNull() {
    if (!_isNavigating) {
      _isNavigating = true;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        // Show a dialog or handle the case when the restaurant ID is null
        showAnimatedDialog(
          context,
          AlertDialog(
            backgroundColor: kWhite,
            title: const Text('Error'),
            content: const Text('Restaurant ID is null. Please set up the restaurant correctly.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _isNavigating = false;
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final restaurantController = Get.put(RestaurantController());
    final orderController = Get.put(OrdersController());
    _tabController.animateTo(orderController.tabIndex);

    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: CustomAppBar(
            type: true,
            onTap: () {
              restaurantController.restaurantStatus();
            },
            onRestaurantIdNull: handleRestaurantIdNull,
          ),
          elevation: 0,
          backgroundColor: kLightWhite,
        ),
        body: BackGroundContainer(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 12.w),
                  height: 65.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DbestHomeTile(
                        imagePath: "assets/icons/foods.svg",
                        text: "Create",
                        onTap: () {
                          Get.to(() => const AddFoodsPage(),
                              transition: Transition.fadeIn,
                              duration: const Duration(milliseconds: 400));
                        },
                      ),
                      DbestHomeTile(
                        imagePath: "assets/icons/wallet.svg",
                        text: "Wallet",
                        onTap: () {
                          Get.to(() => const WalletPage(),
                              transition: Transition.fadeIn,
                              duration: const Duration(milliseconds: 400));
                        },
                      ),
                      DbestHomeTile(
                        imagePath: "assets/icons/french_fries.svg",
                        text: "Foods",
                        onTap: () {
                          Get.to(() => const FoodsPage(),
                              transition: Transition.fadeIn,
                              duration: const Duration(milliseconds: 400));
                        },
                      ),
                      DbestHomeTile(
                        imagePath: "assets/icons/delivery.svg",
                        text: "Self Delivered",
                        onTap: () {
                          Get.to(() => const SelfDeliveredPage(),
                              transition: Transition.fadeIn,
                              duration: const Duration(milliseconds: 400));
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12.w),
                  height: 65.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      DbestHomeTile(
                        imagePath: "assets/icons/chat.svg",
                        text: "Chat",
                        onTap: () async {
                          var userToken = await GetStorage().read("userId");
                          if(userToken==null){
                            showCustomSnackBar("You are not logged in", title: "Login");
                          }else{
                            print("chatting page--");
                            Get.to(() => const MessagePage(),
                                transition: Transition.fadeIn,
                                duration: const Duration(milliseconds: 400));
                          }
                        },
                      ),
                      const SizedBox(width: 65,),
                      DbestHomeTile(
                        imagePath: "assets/icons/chart.svg",
                        text: "Chart",
                        onTap: () {
                          Get.to(() =>  SalesData(),
                              transition: Transition.fadeIn,
                              duration: const Duration(milliseconds: 400));
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Container(
                    height: 25.h,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: kOffWhite,
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: kPrimary,
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      labelPadding: EdgeInsets.zero,
                      labelColor: Colors.white,
                      dividerColor: Colors.transparent,
                      tabAlignment: TabAlignment.start,
                      isScrollable: true,
                      labelStyle: appStyle(12, kLightWhite, FontWeight.normal),
                      unselectedLabelColor: Colors.grey.withOpacity(0.7),
                      tabs: const <Widget>[
                        Tab(
                          child: TabWidget(text: "New Orders"),
                        ),
                        Tab(
                          child: TabWidget(text: "Preparing"),
                        ),
                        Tab(
                          child: TabWidget(text: "Ready"),
                        ),
                        Tab(
                          child: TabWidget(text: "Picked"),
                        ),
                        Tab(
                          child: TabWidget(text: "Self Deliveries"),
                        ),
                        Tab(
                          child: TabWidget(text: "Delivered"),
                        ),
                        Tab(
                          child: TabWidget(text: "Cancelled"),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      NewOrders(),
                      PreparingOrders(),
                      ReadyForDelivery(),
                      PickedOrders(),
                      SelfDeliveries(),
                      DeliveredOrders(),
                      CancelledOrders(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DbestHomeTile extends StatelessWidget {
  const DbestHomeTile({
    Key? key,
    required this.imagePath,
    required this.text,
    this.onTap,
  }) : super(key: key);

  final String imagePath;
  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SvgPicture.asset(
            imagePath,
            width: 40.w,
            height: 40.h,
          ),
          ReusableText(
            text: text,
            style: appStyle(14, kGray, FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

void showAnimatedDialog(BuildContext context, Widget dialog, {bool isFlip = false, bool dismissible = true}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: dismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withOpacity(0.5),
    pageBuilder: (context, animation1, animation2) => dialog,
    transitionDuration: Duration(milliseconds: 500),
    transitionBuilder: (context, a1, a2, widget) {
      if (isFlip) {
        return Rotation3DTransition(
          alignment: Alignment.center,
          turns: Tween<double>(begin: math.pi, end: 2.0 * math.pi).animate(CurvedAnimation(parent: a1, curve: Interval(0.0, 1.0, curve: Curves.linear))),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: a1, curve: Interval(0.5, 1.0, curve: Curves.elasticOut))),
            child: widget,
          ),
        );
      } else {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: widget,
          ),
        );
      }
    },
  );
}


class Rotation3DTransition extends AnimatedWidget {
  const Rotation3DTransition({
    Key? key,
    required this.turns,
    this.alignment = Alignment.center,
    this.child,
  }) : super(key: key, listenable: turns);

  final Animation<double> turns;
  final Alignment alignment;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final double turnsValue = turns.value;
    final Matrix4 transform = Matrix4.identity()
      ..setEntry(3, 2, 0.0006)
      ..rotateY(turnsValue);
    return Transform(
      transform: transform,
      alignment: FractionalOffset(0.5, 0.5),
      child: child,
    );
  }
}