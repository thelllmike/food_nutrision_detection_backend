import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodie/common_widgets/snackbar.dart';
import 'package:foodie/main.dart';
import 'package:foodie/models/meal_model.dart';
import 'package:foodie/screens/analytics.dart';

class FirebaseService {
  FirebaseService() {
    Firebase.initializeApp();
  }

  Future<void> addMealRecord(Meal meal) async {
    try {
      await FirebaseFirestore.instance
          .collection('meals')
          .add(meal.toMap())
          .whenComplete(() {
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(
            builder: (context) => AnalyticsScreen(),
          ),
        );
      });
    } catch (e) {
      showSnackBar(isError: true, msg: 'Error adding meal record: $e');
    }
  }

  Future<Map<String, double>> calculatePercentage(String day) async {
    Map<String, double> percentageMap = {
      'Carbs': 0.0,
      'Protein': 0.0,
      'Fat': 0.0,
      'Fiber': 0.0,
    };
    print(day);
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('meals')
          .where('dayName', isEqualTo: day)
          .get();

      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        double? carbs =
            _getPercentageRelavantToValue(data['nutritions']['Carbohydratesy']);
        double? protein =
            _getPercentageRelavantToValue(data['nutritions']['Protein']);
        double? fat =
            _getPercentageRelavantToValue(data['nutritions']['Fat']);
        double? fiber =
           _getPercentageRelavantToValue(data['nutritions']['Fiber']);

        if (carbs != null) {
          percentageMap['Carbs'] = percentageMap['Carbs']! + carbs;
        }
        if (protein != null) {
          percentageMap['Protein'] = percentageMap['Protein']! + protein;
        }
        if (fat != null) {
          percentageMap['Fat'] = percentageMap['Fat']! + fat;
        }
        if (fiber != null) {
          percentageMap['Fiber'] = percentageMap['Fiber']! + fiber;
        }
      });
      int totalRecords = querySnapshot.docs.length;
      double total = percentageMap['Carbs']! +
          percentageMap['Protein']! +
          percentageMap['Fat']! +
          percentageMap['Fiber']!;
      if (totalRecords > 1) {
        percentageMap['Carbs'] = (percentageMap['Carbs']! / total) * 100;
        percentageMap['Protein'] = (percentageMap['Protein']! / total) * 100;
        percentageMap['Fat'] = (percentageMap['Fat']! / total) * 100;
        percentageMap['Fiber'] = (percentageMap['Fiber']! / total) * 100;
      }
    } catch (e) {
      showSnackBar(
          isError: true, msg: 'Error fetching and calculating percentages: $e');
    }

    return percentageMap;
  }

  double _getPercentageRelavantToValue(String value) {
    if (value == 'high') {
      return 75;
    } else if (value == 'Moderate') {
      return 50;
    } else if (value == 'Low') {
      return 25;
    } else {
      return 0;
    }
  }
}
