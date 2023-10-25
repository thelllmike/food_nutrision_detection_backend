import 'package:flutter/material.dart';
import 'package:foodie/common_widgets/main_button.dart';
import 'package:foodie/constants.dart';
import 'package:foodie/firebase_service.dart';
import 'package:foodie/main_layout.dart';
import 'package:foodie/models/food_model.dart';
import 'package:foodie/models/meal_model.dart';
import 'package:foodie/sample_data.dart';
import 'package:foodie/screens/analytics.dart';
import 'package:intl/intl.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class NutritionScreen extends StatefulWidget {
  NutritionScreen(
      {super.key,
      required this.foodInfo,
      required this.mealTime,
      this.diseases});
  FoodInfo foodInfo;
  String mealTime;
  String? diseases;
  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  bool _switchBUtton = false;
  late Map<String, String> nutritions;
  List<String>? diseases;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // var sampleData = getSampleData(widget.detectedFood);
    // nutritions = sampleData.nutritions;
    // diseases = sampleData.diseases;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MainLayout(
      title: 'NUTRITION',
      customBody: Container(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      widget.foodInfo.foodClass,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: size.width - 80,
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.primaryColor.withOpacity(0.3),
                      ),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Nutrition information',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.primaryColor),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Table(
                              // defaultColumnWidth: const FixedColumnWidth(70.0),
                              children: [
                                _tableRow(
                                    nutrition: 'Carbohydratesy',
                                    percentage: widget
                                        .foodInfo.nutritionInfo.carbohydrates),
                                _tableRow(
                                    nutrition: 'Protein',
                                    percentage:
                                        widget.foodInfo.nutritionInfo.protein),
                                _tableRow(
                                    nutrition: 'Fat',
                                    percentage:
                                        widget.foodInfo.nutritionInfo.fat),
                                _tableRow(
                                    nutrition: 'Fiber',
                                    percentage:
                                        widget.foodInfo.nutritionInfo.fiber),
                                _tableRow(
                                    nutrition: 'Vitamins and Minerals',
                                    percentage: widget.foodInfo.nutritionInfo
                                        .vitaminsAndMinerals),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    ((diseases != null) &&
                            (diseases?.length ?? 0) > 0 &&
                            widget.diseases != null)
                        ? Container(
                            child: diseases!.contains(widget.diseases!)
                                ? Container(
                                    width: size.width - 80,
                                    margin: const EdgeInsets.only(top: 20),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: AppColors.primaryColor,
                                        border: Border.all(
                                            width: 2, color: Colors.red)),
                                    child: const Column(
                                      children: [
                                        Text(
                                          'Warning',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'This is not good for your health,\nbecause This can be cause to your diabetes.',
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  )
                                : Container(),
                          )
                        : Container()
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Are you going to take this?'),
                const SizedBox(
                  width: 5,
                ),
                Switch(
                  value: _switchBUtton,
                  onChanged: (bool value) {
                    setState(() {
                      print(value);
                      _switchBUtton = value;
                    });
                  },
                  activeThumbImage:
                      const AssetImage('assets/icons/yes_icon.png'),
                  inactiveThumbImage:
                      const AssetImage('assets/icons/no_icon.png'),
                )
              ],
            ),
            MainButton(
              size: size,
              title: 'Next',
              onTap: _switchBUtton
                  ? () {
                      Meal meal = Meal(
                          type: widget.foodInfo.foodClass,
                          diseases: [],
                          nutritions: widget.foodInfo.nutritionInfo.toJson(),
                          dayName: getDayName(),
                          dateTime: DateTime.now(),
                          mealTime: widget.mealTime);
                      FirebaseService().addMealRecord(meal);
                    }
                  : null,
            )
          ],
        ),
      ),
    );
  }

  String getDayName() {
    final now = DateTime.now();
    final formatter = DateFormat('EEEE');
    final dayName = formatter.format(now);
    return dayName;
  }

  TableRow _tableRow({required String nutrition, required String percentage}) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(nutrition,
              style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primaryColor)),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(percentage,
              style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primaryColor)),
        ),
      ],
    );
  }
}
