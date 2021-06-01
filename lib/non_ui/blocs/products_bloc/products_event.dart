part of 'products_bloc.dart';

@immutable
abstract class ProductsEvent extends Equatable {
  const ProductsEvent();
}

class GetProducts extends ProductsEvent {
  final String query;

  const GetProducts(this.query);

  @override
  List<Object?> get props => [query];
}
