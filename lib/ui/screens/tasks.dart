import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morphosis_flutter_demo/non_ui/blocs/todos_bloc/todos_bloc.dart';
import 'package:morphosis_flutter_demo/non_ui/modal/task.dart';
import 'package:morphosis_flutter_demo/ui/screens/task.dart';

class TasksPage extends StatelessWidget {
  TasksPage({required this.title, required this.tasks});

  final String title;
  final List<Task> tasks;

  void addTask(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => addTask(context),
          )
        ],
      ),
      body: tasks.isEmpty
          ? Center(
              child: Text('Add your first task'),
            )
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return _Task(
                  tasks[index],
                );
              },
            ),
    );
  }
}

class _Task extends StatelessWidget {
  _Task(this.task);

  final Task task;

  _delete(context) {
    BlocProvider.of<TodosBloc>(context).add(DeleteTodo(task));
  }

  _toggleComplete(BuildContext context) {
    if (task.isCompleted) {
      task.completedAt = null;
    } else
      task.completedAt = DateTime.now();
    BlocProvider.of<TodosBloc>(context).add(UpdateTodo(task));
  }

  void _view(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskPage(task: task)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
        icon: Icon(
          task.isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
        ),
        onPressed: () {
          _toggleComplete(context);
        },
      ),
      title: Text(task.title.toString()),
      subtitle: Text(task.description.toString()),
      trailing: IconButton(
        icon: Icon(
          Icons.delete,
        ),
        onPressed: () async {
          await _delete(context);
        },
      ),
      onTap: () => _view(context),
    );
  }
}
