import 'package:hive/hive.dart';
import 'package:morphosis_flutter_demo/non_ui/modal/product.dart';

class HiveService {
  Future<bool> exists(String boxName) async {
    final openBox = await Hive.openBox<Product>(boxName);
    int length = openBox.length;
    return length != 0;
  }

  void addBoxes<Product>(List<Product> items, String boxName) async {
    final openBox = await Hive.openBox<Product>(
      boxName,
    );

    List<Product> existingProducts = await getBoxes(boxName);

    for (var item in items) {
      if (!existingProducts.contains(item)) {
        openBox.add(item);
      }
    }
  }

  Future<List<Product>> getBoxes<Product>(String boxName,
      [String? query]) async {
    List<Product> boxList = [];

    final openBox = await Hive.openBox<Product>(boxName);

    int length = openBox.length;

    for (int i = 0; i < length; i++) {
      boxList.add(openBox.getAt(i) as Product);
    }

    return boxList;
  }
}
