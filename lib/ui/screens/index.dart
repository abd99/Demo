import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morphosis_flutter_demo/non_ui/blocs/todos_bloc/todos_bloc.dart';
import 'package:morphosis_flutter_demo/non_ui/modal/task.dart';
import 'package:morphosis_flutter_demo/ui/screens/home.dart';
import 'package:morphosis_flutter_demo/ui/screens/tasks.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      HomePage(),
      TaskPageBlocBuilder(
        onLoadedWidget: (state) => state.tasks,
      ),
      TaskPageBlocBuilder(
        onLoadedWidget: (state) =>
            state.tasks.where((task) => task.isCompleted).toList(),
      ),
    ];

    return Scaffold(
      body: children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'All Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Completed Tasks',
          ),
        ],
      ),
    );
  }
}

class TaskPageBlocBuilder extends StatelessWidget {
  final List<Task> Function(TodosLoaded state) onLoadedWidget;
  const TaskPageBlocBuilder({
    required this.onLoadedWidget,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodosBloc, TodosState>(
      builder: (context, state) {
        if (state is TodosLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is TodosLoaded) {
          return TasksPage(
            title: 'All Tasks',
            tasks: onLoadedWidget(state),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
