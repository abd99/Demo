import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:morphosis_flutter_demo/non_ui/modal/product.dart';
import 'package:morphosis_flutter_demo/non_ui/resources/repository.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final APIRepository repository;
  ProductsBloc(this.repository) : super(ProductsInitial());

  String previousQuery = '';
  @override
  Stream<ProductsState> mapEventToState(
    ProductsEvent event,
  ) async* {
    final currentState = state;
    if (event is GetProducts && !_hasReachedMax(currentState)) {
      try {
        if (currentState is ProductsInitial) {
          previousQuery = event.query;
          yield ProductsLoading();
          final products = await _fetchProducts(event.query, 0, 20);
          yield ProductsLoaded(products: products, hasReachedMax: false);
          return;
        }
        if (currentState is ProductsLoaded) {
          if (previousQuery != event.query) {
            previousQuery = event.query;
            currentState.products.clear();
          }
          final products = await _fetchProducts(
              event.query, currentState.products.length, 20);
          var newProductsList = currentState.products + products;
          yield products.isEmpty
              ? currentState.copywith(hasReachedMax: true)
              : ProductsLoaded(products: newProductsList, hasReachedMax: false);
        }
      } on SocketException catch (e) {
        print('Socket exception: ${e.message}');

        if (e.message.contains('Failed host lookup')) {
          yield ProductsError(
              errorMessage: 'Please check your network connectivity.');
        } else
          yield ProductsError();
      } catch (e) {
        print('ProductsError: ${e.toString()}');
        yield ProductsError();
      }
    }
  }

  bool _hasReachedMax(ProductsState state) =>
      state is ProductsLoaded && state.hasReachedMax;

  Future<List<Product>> _fetchProducts(
      String query, int startIndex, int limit) async {
    final response = await repository.fetchFoodItems(query, startIndex, limit);
    try {
      return response.products;
    } on TypeError catch (e) {
      print('TypeError: $e');
      return [];
    } catch (e) {
      print('Error occurred: $e');
    }
    return [];
  }
}
