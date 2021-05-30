import 'package:dio/dio.dart';
import 'package:morphosis_flutter_demo/non_ui/modal/products.dart';

class FoodAPIProvider {
  final _baseURL =
      'https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/food/products/search';
  final _clientKey = '8c7076f377mshb8efe7756bacc3bp148f59jsn5cf796dd3714';
  final _hostKey = 'spoonacular-recipe-food-nutrition-v1.p.rapidapi.com';

  Future<Products> fetchFoodItems(String query, int offset, int limit) async {
    var dio = Dio();

    late final String requestURL;

    if (query.isEmpty) {
      requestURL = '$_baseURL?query=food&offset=$offset&number=$limit';
    } else {
      requestURL = '$_baseURL?query=$query&offset=$offset&number=$limit';
    }
    print(requestURL);

    var response = await dio.get(
      requestURL,
      options: Options(
        headers: {
          'x-rapidapi-key': _clientKey,
          'x-rapidapi-host': _hostKey,
        },
      ),
    );

    if (response.statusCode == 200) {
      return Products.fromJson(response.data);
    } else {
      throw Exception('Failed to load food items');
    }
  }
}
