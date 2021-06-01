// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Products _$ProductsFromJson(Map<String, dynamic> json) {
  return Products(
    offset: json['offset'] as int,
    products: (json['products'] as List<dynamic>)
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList(),
    number: json['number'] as int,
    totalProducts: json['totalProducts'] as int,
  );
}

Map<String, dynamic> _$ProductsToJson(Products instance) => <String, dynamic>{
      'offset': instance.offset,
      'products': instance.products.map((e) => e.toJson()).toList(),
      'number': instance.number,
      'totalProducts': instance.totalProducts,
    };
