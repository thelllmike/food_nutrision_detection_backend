class FoodInfo {
  String foodClass;
  double confidence;
  NutritionInfo nutritionInfo;

  FoodInfo({
    required this.foodClass,
    required this.confidence,
    required this.nutritionInfo,
  });

  factory FoodInfo.fromJson(Map<String, dynamic> json) {
    return FoodInfo(
      foodClass: json['class'] as String,
      confidence: json['confidence'] as double,
      nutritionInfo: NutritionInfo.fromJson(json['nutrition_info']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'class': foodClass,
      'confidence': confidence,
      'nutrition_info': nutritionInfo.toJson(),
    };
  }
}

class NutritionInfo {
  String foodCategory;
  String carbohydrates;
  String protein;
  String fat;
  String fiber;
  String vitaminsAndMinerals;

  NutritionInfo({
    required this.foodCategory,
    required this.carbohydrates,
    required this.protein,
    required this.fat,
    required this.fiber,
    required this.vitaminsAndMinerals,
  });

  factory NutritionInfo.fromJson(Map<String, dynamic> json) {
    return NutritionInfo(
      foodCategory: json['Food Category '] as String,
      carbohydrates: json['Carbohydratesy'] as String,
      protein: json['Protein'] as String,
      fat: json['Fat'] as String,
      fiber: json['Fiber'] as String,
      vitaminsAndMinerals: json['Vitamins and Minerals'] as String,
    );
  }

  Map<String, String> toJson() {
    return {
      'Food Category ': foodCategory,
      'Carbohydratesy': carbohydrates,
      'Protein': protein,
      'Fat': fat,
      'Fiber': fiber,
      'Vitamins and Minerals': vitaminsAndMinerals,
    };
  }
}
