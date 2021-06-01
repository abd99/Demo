import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:morphosis_flutter_demo/non_ui/blocs/products_bloc/products_bloc.dart';
import 'package:morphosis_flutter_demo/non_ui/resources/firebase_todos_repository.dart';
import 'package:morphosis_flutter_demo/non_ui/resources/repository.dart';
import 'package:morphosis_flutter_demo/ui/screens/index.dart';
import 'package:morphosis_flutter_demo/ui/widgets/error_widget.dart';
import 'package:path_provider/path_provider.dart';

import 'non_ui/blocs/todos_bloc/todos_bloc.dart';
import 'non_ui/modal/product.dart';

const title = 'Morphosis Demo';

void main() async {
  Bloc.observer = SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  var appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(ProductAdapter());
  runZonedGuarded(() {
    runApp(FirebaseApp());
  }, (error, stackTrace) {
    print('runZonedGuarded: Caught error in the root zone:${error}');
  });
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
  }
}

class FirebaseApp extends StatefulWidget {
  @override
  _FirebaseAppState createState() => _FirebaseAppState();
}

class _FirebaseAppState extends State<FirebaseApp> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  Future<void> _initializeFlutterFire() async {
    // Wait for Firebase to initialize
    await Firebase.initializeApp();

    debugPrint("firebase initialized");

    // Pass all uncaught errors to Crashlytics.
    Function? originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails errorDetails) async {
      // Forward to original handler.
      originalOnError!(errorDetails);
    };
  }

  // Define an async function to initialize FlutterFire
  void initialize() async {
    if (_error) {
      setState(() {
        _error = false;
      });
    }

    try {
      await _initializeFlutterFire();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      print(e);
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error || !_initialized) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        home: Scaffold(
          body: _error
              ? ErrorMessage(
                  message: "Problem initialising the app",
                  buttonTitle: "RETRY",
                  onTap: initialize,
                )
              : Container(),
        ),
      );
    }
    return App();
  }
}

class App extends StatelessWidget {
  ///TODO: Try to implement themeing and use it throughout the app
  /// For reference : https://flutter.dev/docs/cookbook/design/themes
  ///

  ///TODO: Restructure folders pr rearrange folders based on your need.

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ProductsBloc(APIRepository())..add(GetProducts('')),
        ),
        BlocProvider(
          create: (context) =>
              TodosBloc(FirebaseTodosRepository())..add(LoadTodos()),
        ),
      ],
      child: MaterialApp(
        title: title,
        home: IndexPage(),
      ),
    );
  }
}
