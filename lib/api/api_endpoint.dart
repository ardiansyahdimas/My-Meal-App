class ApiEndpoint {
  static const baseUrl = "https://www.themealdb.com/api/json/v1/1/";
  static const areasUrl = "${baseUrl}list.php?a=list";
  static const mealByAreaUrl = "${baseUrl}filter.php?a=";
  static const searchByNameUrl = "${baseUrl}search.php?s=";
  static const mealByIdUrl = "${baseUrl}lookup.php?i=";
}