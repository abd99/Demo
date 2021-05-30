import 'package:morphosis_flutter_demo/non_ui/modal/products.dart';
import 'package:morphosis_flutter_demo/non_ui/resources/api_provider.dart';

class APIRepository {
  var groceriesProvider = FoodAPIProvider();

  Future<Products> fetchFoodItems(String query, int offset, int limit) =>
      groceriesProvider.fetchFoodItems(query, offset, limit);
}
