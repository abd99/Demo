import 'package:json_annotation/json_annotation.dart';
import 'product.dart';

part 'products.g.dart';

@JsonSerializable(explicitToJson: true)
class Products {
  final int offset;
  final List<Product> products;
  final int number;
  final int totalProducts;

  Products({
    required this.offset,
    required this.products,
    required this.number,
    required this.totalProducts,
  });

  factory Products.fromJson(Map<String, dynamic> json) =>
      _$ProductsFromJson(json);

  Map<String, dynamic> toJson() => _$ProductsToJson(this);
}
