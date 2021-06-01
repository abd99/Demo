import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morphosis_flutter_demo/non_ui/blocs/products_bloc/products_bloc.dart';

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
  late ConnectivityResult connectivityStatus;

  @override
  void initState() {
    super.initState();
    getConnectivityStatus();
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
      _productsBloc.add(GetProducts(_searchTextField.text));
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
                      onSubmitted: (value) {
                        _productsBloc.add(GetProducts(value));
                      },
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

                if (products.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('No products found'),
                    )),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return index >= state.products.length
                          ? BottomLoader()
                          : ListTile(
                              leading: CachedNetworkImage(
                                imageUrl: products[index].image,
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.wifi_off),
                                placeholder: (context, url) =>
                                    CircularProgressIndicator.adaptive(
                                  strokeWidth: 1.5,
                                ),
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
              if (state is ProductsError) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child:
                          Text(state.errorMessage ?? 'Something went wrong!'),
                    ),
                  ),
                );
              }

              return SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: const Text('Something went wrong!'),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ));
  }

  void getConnectivityStatus() async {
    connectivityStatus = await Connectivity().checkConnectivity();
  }
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(16.0),
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
