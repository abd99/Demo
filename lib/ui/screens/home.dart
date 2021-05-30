import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morphosis_flutter_demo/non_ui/bloc/products_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchTextField = TextEditingController();
  final _scrollController = ScrollController();
  final _scrollThreshold = 50.0;
  late ProductsBloc _productsBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _productsBloc = BlocProvider.of<ProductsBloc>(context);
  }

  @override
  void dispose() {
    _searchTextField.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _productsBloc.add(GetProducts(''));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
        body: Scrollbar(
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 125.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Home",
                      style: textTheme.headline6!.copyWith(),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    CupertinoSearchTextField(
                      controller: _searchTextField,
                    ),
                  ],
                ),
              ),
              centerTitle: true,
            ),
            floating: true,
          ),
          BlocBuilder<ProductsBloc, ProductsState>(
            builder: (context, state) {
              if (state is ProductsLoading) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator.adaptive(
                      strokeWidth: 1.5,
                    ),
                  ),
                );
              }

              if (state is ProductsLoaded) {
                var products = state.products;

                return SliverList(
                  /* In this section we will be testing your skills with network and local storage. You need to fetch data from any open source api from the internet.
                               E.g:
                               https://any-api.com/
                               https://rapidapi.com/collection/best-free-apis?utm_source=google&utm_medium=cpc&utm_campaign=Beta&utm_term=%2Bopen%20%2Bsource%20%2Bapi_b&gclid=Cj0KCQjw16KFBhCgARIsALB0g8IIV107-blDgIs0eJtYF48dAgHs1T6DzPsxoRmUHZ4yrn-kcAhQsX8aAit1EALw_wcB
                               Implement setup for network. You are free to use package such as Dio, Choppper or Http can ve used as well.
                               Upon fetching the data try to store thmm locally. You can use any local storeage.
                               Upon Search the data should be filtered locally and should update the UI.
                              */

                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return index >= state.products.length
                          ? BottomLoader()
                          : ListTile(
                              leading: CachedNetworkImage(
                                imageUrl: products[index].image,
                                height: 50.0,
                                width: 50.0,
                                fit: BoxFit.fill,
                              ),
                              title: Text(products[index].title),
                            );
                    },
                    childCount: state.hasReachedMax
                        ? state.products.length
                        : state.products.length + 1,
                  ),
                );
              }
              return SliverToBoxAdapter(
                  child: const Text('Something went wrong!'));
            },
          ),
        ],
      ),
    ));
  }
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator.adaptive(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}
