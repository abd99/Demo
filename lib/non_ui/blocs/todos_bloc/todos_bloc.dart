import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:morphosis_flutter_demo/non_ui/modal/task.dart';
import 'package:morphosis_flutter_demo/non_ui/resources/firebase_todos_repository.dart';

part 'todos_event.dart';
part 'todos_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  late StreamSubscription _todosSubscription;
  final FirebaseTodosRepository _todosRepository;

  TodosBloc(this._todosRepository) : super(TodosLoading());

  @override
  Stream<TodosState> mapEventToState(
    TodosEvent event,
  ) async* {
    if (event is LoadTodos) {
      yield* _mapLoadTodosToState();
    } else if (event is AddTodo) {
      yield* _mapAddTodoToState(event);
    } else if (event is UpdateTodo) {
      yield* _mapUpdateTodoToState(event);
    } else if (event is DeleteTodo) {
      yield* _mapDeleteTodoToState(event);
    } else if (event is ClearCompleted) {
      yield* _mapClearCompletedToState();
    } else if (event is TodosUpdated) {
      yield* _mapTodosUpdateToState(event);
    }
  }

  Stream<TodosState> _mapLoadTodosToState() async* {
    if (_todosRepository == null) {
      _todosSubscription.cancel();
    }
    _todosSubscription = _todosRepository.tasks().listen(
          (todos) => add(TodosUpdated(todos)),
        );
  }

  Stream<TodosState> _mapAddTodoToState(AddTodo event) async* {
    _todosRepository.addNewTask(event.task);
  }

  Stream<TodosState> _mapUpdateTodoToState(UpdateTodo event) async* {
    _todosRepository.updateTask(event.updatedTask);
  }

  Stream<TodosState> _mapDeleteTodoToState(DeleteTodo event) async* {
    _todosRepository.deleteTask(event.task);
  }

  Stream<TodosState> _mapClearCompletedToState() async* {
    final currentState = state;
    if (currentState is TodosLoaded) {
      final List<Task> completedTodos =
          currentState.tasks.where((todo) => todo.isCompleted).toList();
      completedTodos.forEach((completedTask) {
        _todosRepository.deleteTask(completedTask);
      });
    }
  }

  Stream<TodosState> _mapTodosUpdateToState(TodosUpdated event) async* {
    yield TodosLoaded(event.tasks);
  }

  @override
  Future<void> close() {
    _todosSubscription.cancel();
    return super.close();
  }
}
