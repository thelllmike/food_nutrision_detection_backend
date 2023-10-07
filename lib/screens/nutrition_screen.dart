import 'package:flutter/material.dart';
import 'package:foodie/common_widgets/main_button.dart';
import 'package:foodie/constants.dart';
import 'package:foodie/firebase_service.dart';
import 'package:foodie/main_layout.dart';
import 'package:foodie/models/meal_model.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:foodie/api_service.dart';

class NutritionScreen extends StatefulWidget {
  NutritionScreen({
    Key? key,
    required this.detectedFood,
    required this.mealTime,
    this.diseases,
  });

  final String detectedFood;
  final String mealTime;
  final String? diseases;

  @override
  _NutritionScreenState createState() => _NutritionScreenState();
}

List<String>? diseases;

class _NutritionScreenState extends State<NutritionScreen> {
  bool _switchButton = false;

  Map<String, dynamic> nutritionDetails = {};
  Map<String, String> convertedNutritionDetails = {};

  String? currentDetectedFood;

  @override
  void initState() {
    super.initState();
    currentDetectedFood = widget.detectedFood;
    _fetchAndSetData();
  }

  Future<void> _fetchAndSetData() async {
    File myImage = File('path_to_your_image.jpg');

    try {
      Map<String, dynamic> response = await ApiService().uploadImage(myImage);

      setState(() {
        currentDetectedFood = response['class'];
        nutritionDetails = response['nutrition_info'];
        convertedNutritionDetails = nutritionDetails.map((key, value) => MapEntry(key, value.toString()));
      });

      print("Fetched Nutrition Details: ${nutritionDetails['Carbohydratesy']}"); // Printing the value after setting the state.
    } catch (error) {
      print("Error fetching data: $error");
    }
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
                      widget.detectedFood,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: size.width - 80,
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.primaryColor.withOpacity(0.3),
                      ),
                      child: Center(
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Nutrition information',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...nutritionDetails.entries.map((e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text('${e.key}: ${e.value}', style: TextStyle(fontSize: 16)),
                            )).toList(),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    (diseases != null && widget.diseases != null && diseases!.contains(widget.diseases!))
                        ? Container(
                      width: size.width - 80,
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.primaryColor,
                        border: Border.all(
                          width: 2,
                          color: Colors.red,
                        ),
                      ),
                      child: const Column(
                        children: [
                          Text(
                            'Warning',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'This is not good for your health,\nbecause This can be cause to your diabetes.',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                        : Container(),
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
                  value: _switchButton,
                  onChanged: (bool value) {
                    setState(() {
                      print(value);
                      _switchButton = value;
                    });
                  },
                  activeThumbImage: const AssetImage('assets/icons/yes_icon.png'),
                  inactiveThumbImage: const AssetImage('assets/icons/no_icon.png'),
                ),
              ],
            ),
            MainButton(
              size: size,
              title: 'Next',
              onTap: _switchButton
                  ? () {
                Meal meal = Meal(
                  type: widget.detectedFood,
                  diseases: [],
                  nutritions: convertedNutritionDetails,
                  dayName: getDayName(),
                  dateTime: DateTime.now(),
                  mealTime: widget.mealTime,
                );
                FirebaseService().addMealRecord(meal);
                // Navigate to the next screen if needed.
                Navigator.of(context).pushReplacementNamed("/nextScreenRouteName");
              }
                  : null,
            ),
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
}
