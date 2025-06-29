import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly_restaurant/common/app_style.dart';
import 'package:foodly_restaurant/common/custom_btn.dart';
import 'package:foodly_restaurant/constants/constants.dart';
import 'package:foodly_restaurant/controllers/foods_controller.dart';
import 'package:foodly_restaurant/models/foods.dart';
import 'package:foodly_restaurant/views/food/widgets/promotion_date.dart';
import 'package:get/get.dart';

class EditFoodPage extends StatefulWidget {
  const EditFoodPage({Key? key, required this.food}) : super(key: key);

  final Food food;

  @override
  State<EditFoodPage> createState() => _EditFoodPageState();
}

class _EditFoodPageState extends State<EditFoodPage> {
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController? _promotionPrice;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.food.title);
    _priceController = TextEditingController(text: widget.food.price.toString());
    _descriptionController = TextEditingController(text: widget.food.description);
    //_promotion  = TextEditingController(text:widget.food.promotion.toString());
    _promotionPrice  = TextEditingController(text:widget.food.promotionPrice.toString());

  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _promotionPrice?.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final foodController = Get.put(FoodsController());

    WidgetsBinding.instance.addPostFrameCallback((_){
      widget.food.promotion ??= false;
      widget.food.promotionPrice ??= "" as double?;
      Get.find<FoodsController>().setPromotion=widget.food.promotion;
      Get.find<FoodsController>().setPromotionPrice=widget.food.promotionPrice;
    });

    return Scaffold(
      backgroundColor: kLightWhite,
      body: SizedBox(
        height: double.infinity,
        child: ListView(

          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: 300.h, // Adjust this based on your needs
              child: Stack(
                children: [
                  // Your image gallery (omitted)
                  Positioned(
                    top: 40.h,
                    left: 12,

                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(
                        Ionicons.chevron_back_circle,
                        color: kPrimary,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Editable title
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),

                  ),
                  SizedBox(height: 10.h),
                  // Editable price
                  TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Obx((){
                    return Checkbox(value: Get.find<FoodsController>().promotion, onChanged: (val){
                      Get.find<FoodsController>().setPromotion=val;
                        widget.food.promotion=Get.find<FoodsController>().promotion;
                      });
                  }),
                 Obx((){
                   return  Get.find<FoodsController>().promotion==true?TextFormField(
                     controller: _promotionPrice!,
                     keyboardType: TextInputType.number,
                     decoration: const InputDecoration(
                       labelText: 'Promotion price 0.0',
                       border: OutlineInputBorder(),
                     ),
                     onChanged: (val){

                         if (val.isNotEmpty && double.tryParse(val) != null) {
                           // The value is valid, so parse it
                           Get.find<FoodsController>().setPromotionPrice = double.parse(val);
                           widget.food.promotionPrice = Get.find<FoodsController>().promotionPrice;
                         } else {
                           // Handle the case where the value is invalid (e.g., empty string or non-numeric input)
                           Get.find<FoodsController>().setPromotionPrice = 0.0;
                           widget.food.promotionPrice = 0.0;
                         }

                     },
                   ):const SizedBox.shrink();

                 }),
                  SizedBox(height: 10.h),
                  //date picker
                 Obx(()=> Get.find<FoodsController>().promotion==true?Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     DateRangePickerWidget(
                       labelText: "Select Date Range",
                       backgroundColor: kPrimary,
                       onDateRangeSelected: (start, end) {
                         // Update the controller with selected dates
                         Get.find<FoodsController>().updateDateRange(start, end);
                       },
                     ),
                     SizedBox(height: 10),
                     Obx(() {
                       // Display the selected date range
                       return Text(
                         "Selected Range: \n ${Get.find<FoodsController>().startDate.value} \n ${Get.find<FoodsController>().endDate.value}",
                         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                       );
                     }),
                   ],
                 ):SizedBox.shrink()),

                  SizedBox(height: 20.h),
                  // Editable description
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      // Optionally handle any real-time changes here
                    },
                  ),
                  SizedBox(height: 10.h),

                  // Save button
                  CustomButton(
                    text: "Save",
                    onTap: () {
                      final editedFood = Food(
                        id: widget.food.id,
                        title: _titleController.text,
                        code:widget.food.code,
                        price: double.parse(_priceController.text),
                        description: _descriptionController.text,
                        imageUrl: widget.food.imageUrl,
                        foodTags: widget.food.foodTags,
                        category: widget.food.category,
                        time: widget.food.time,
                        additives: widget.food.additives,
                        foodType: widget.food.foodType,
                        restaurant: widget.food.restaurant,
                        isAvailable: widget.food.isAvailable,
                        promStarts: Get.find<FoodsController>().startDate.value,
                        promEnds: Get.find<FoodsController>().endDate.value,
                        promotion: widget.food.promotion,
                        promotionPrice: widget.food.promotionPrice,
                        verified: false,
                      );
                      print("here we go ${Get.find<FoodsController>().startDate.value}");
                      print("here we go ${Get.find<FoodsController>().endDate.value}");
                     foodController.updateFood(widget.food.id, editedFood.toJson());
                     Get.back();

                    },

                    color: kPrimary,
                    btnWidth: width / 2.9,
                    radius: 30,
                  ),

                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}