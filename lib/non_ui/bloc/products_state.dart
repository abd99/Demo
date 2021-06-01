part of 'products_bloc.dart';

@immutable
abstract class ProductsState extends Equatable {
  const ProductsState();
}

class ProductsInitial extends ProductsState {
  const ProductsInitial();
  @override
  List<Object?> get props => [];
}

class ProductsLoading extends ProductsState {
  const ProductsLoading();
  @override
  List<Object?> get props => [];
}

class ProductsLoaded extends ProductsState {
  final List<Product> products;
  final bool hasReachedMax;
  const ProductsLoaded({
    required this.products,
    required this.hasReachedMax,
  });

  ProductsLoaded copywith({
    List<Product>? products,
    required bool hasReachedMax,
  }) {
    return ProductsLoaded(
        products: products ?? this.products, hasReachedMax: hasReachedMax);
  }

  @override
  List<Object?> get props => [products, hasReachedMax];
}

class ProductsError extends ProductsState {
  final String? errorMessage;
  const ProductsError({this.errorMessage});
  @override
  List<Object?> get props => [];
}
