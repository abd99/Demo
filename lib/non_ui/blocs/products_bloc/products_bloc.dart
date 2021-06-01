import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:morphosis_flutter_demo/non_ui/modal/product.dart';
import 'package:morphosis_flutter_demo/non_ui/resources/hive_service.dart';
import 'package:morphosis_flutter_demo/non_ui/resources/repository.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final APIRepository repository;
  ProductsBloc(this.repository) : super(ProductsInitial());

  String previousQuery = '';
  final HiveService hiveService = HiveService();
  var previousConnectivityStatus = ConnectivityResult.none;

  @override
  Stream<ProductsState> mapEventToState(
    ProductsEvent event,
  ) async* {
    final currentState = state;
    var connectivityStatus = await Connectivity().checkConnectivity();
    if (event is GetProducts) {
      if (!_hasReachedMax(currentState) ||
          previousConnectivityStatus != connectivityStatus ||
          previousQuery != event.query) {
        previousConnectivityStatus = connectivityStatus;

        try {
          if (currentState is ProductsInitial) {
            previousQuery = event.query;
            yield ProductsLoading();

            if (connectivityStatus == ConnectivityResult.none) {
              var exists = await hiveService.exists('products');
              if (exists) {
                var savedProducts =
                    await hiveService.getBoxes<Product>('products');
                var filteredProducts = savedProducts
                    .where((product) => product.title.contains(event.query))
                    .toList();
                yield ProductsLoaded(
                    products: filteredProducts, hasReachedMax: true);
              } else {
                yield ProductsError(
                    errorMessage:
                        'No products available locally. Connect to a network to fetch products online');
              }
            } else {
              final products = await _fetchProducts(event.query, 0, 20);
              hiveService.addBoxes(products, 'products');
              yield ProductsLoaded(products: products, hasReachedMax: false);
            }
            return;
          }
          if (currentState is ProductsLoaded) {
            if (previousQuery != event.query) {
              print('Search query changed');
              previousQuery = event.query;
              currentState.products.clear();
              yield ProductsLoading();
            }

            if (connectivityStatus == ConnectivityResult.none) {
              var exists = await hiveService.exists('products');
              if (exists) {
                var savedProducts =
                    await hiveService.getBoxes<Product>('products');
                var filteredProducts = savedProducts.where((product) {
                  return product.title
                      .toLowerCase()
                      .contains(event.query.toLowerCase());
                }).toList();

                yield ProductsLoaded(
                    products: filteredProducts, hasReachedMax: true);
              } else {
                yield ProductsError(
                    errorMessage:
                        'No products available locally. Check network connection to fetch products');
              }
            } else {
              final products = await _fetchProducts(
                  event.query, currentState.products.length, 20);
              hiveService.addBoxes(products, 'products');
              var newProductsList = currentState.products + products;

              yield products.isEmpty
                  ? currentState.copywith(hasReachedMax: true)
                  : ProductsLoaded(
                      products: newProductsList, hasReachedMax: false);
            }
          }
        } on SocketException catch (e) {
          print('Socket exception: ${e.message}');

          if (e.message.contains('Failed host lookup')) {
            yield ProductsError(
                errorMessage: 'Please check your network connectivity.');
          } else
            yield ProductsError();
        } on DioError catch (e) {
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
