import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morphosis_flutter_demo/non_ui/blocs/products_bloc/products_bloc.dart';
import 'package:morphosis_flutter_demo/non_ui/modal/product.dart';
import 'package:morphosis_flutter_demo/non_ui/resources/repository.dart';

class MockAPIRepository extends Mock implements APIRepository {}

void main(List<String> args) {
  MockAPIRepository mockAPIRepository;

  group('GetProducts', () {
    final products = [
      Product(
          id: 61911,
          title: 'Snickers Bar',
          image: 'https://spoonacular.com/productImages/61911-312x231.jpg')
    ];

    mockAPIRepository = MockAPIRepository();

    blocTest<ProductsBloc, ProductsState>(
      'Testing ProductsBloc',
      build: () => ProductsBloc(mockAPIRepository),
      act: (bloc) => bloc.add(GetProducts('Snickers Bar')),
      expect: () => [
        ProductsInitial(),
        ProductsLoading(),
        ProductsLoaded(products: products, hasReachedMax: true)
      ],
    );
  });
}
