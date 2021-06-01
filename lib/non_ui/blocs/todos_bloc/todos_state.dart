part of 'todos_bloc.dart';

@immutable
abstract class TodosState extends Equatable {
  const TodosState();

  @override
  List<Object> get props => [];
}

class TodosLoading extends TodosState {}

class TodosLoaded extends TodosState {
  final List<Task> tasks;

  const TodosLoaded([this.tasks = const []]);

  @override
  List<Object> get props => [tasks];

  @override
  String toString() => 'TodosLoaded { tasks: $tasks }';
}

class TodosNotLoaded extends TodosState {}
