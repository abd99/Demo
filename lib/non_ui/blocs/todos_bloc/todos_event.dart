part of 'todos_bloc.dart';

@immutable
abstract class TodosEvent extends Equatable {
  const TodosEvent();

  @override
  List<Object> get props => [];
}

class LoadTodos extends TodosEvent {}

class AddTodo extends TodosEvent {
  final Task task;

  const AddTodo(this.task);

  @override
  List<Object> get props => [task];

  @override
  String toString() => 'AddTodo { task: $task }';
}

class UpdateTodo extends TodosEvent {
  final Task updatedTask;

  const UpdateTodo(this.updatedTask);

  @override
  List<Object> get props => [updatedTask];

  @override
  String toString() => 'UpdateTask { updatedTask: $updatedTask }';
}

class DeleteTodo extends TodosEvent {
  final Task task;

  const DeleteTodo(this.task);

  @override
  List<Object> get props => [task];

  @override
  String toString() => 'DeleteTodo { task: $task }';
}

class ClearCompleted extends TodosEvent {}

class TodosUpdated extends TodosEvent {
  final List<Task> tasks;

  const TodosUpdated(this.tasks);

  @override
  List<Object> get props => [tasks];
}
