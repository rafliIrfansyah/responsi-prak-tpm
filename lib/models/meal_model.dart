class MealModel {
  List<Meals>? meals;

  MealModel({
    this.meals,
  });

  MealModel.fromJson(Map<String, dynamic> json) {
    meals = (json['meals'] as List?)?.map((dynamic e) => Meals.fromJson(e as Map<String,dynamic>)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['meals'] = meals?.map((e) => e.toJson()).toList();
    return json;
  }
}

class Meals {
  String? strMeal;
  String? strMealThumb;
  String? idMeal;

  Meals({
    this.strMeal,
    this.strMealThumb,
    this.idMeal,
  });

  Meals.fromJson(Map<String, dynamic> json) {
    strMeal = json['strMeal'];
    strMealThumb = json['strMealThumb'];
    idMeal = json['idMeal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['strMeal'] = strMeal;
    json['strMealThumb'] = strMealThumb;
    json['idMeal'] = idMeal;
    return json;
  }
}