import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_app/model/todo_model.dart';
import 'package:to_do_app/screen/todo_screen.dart';
import 'package:uuid/uuid.dart';

class TodoList extends StateNotifier<List<Todo>> {
  TodoList() : super([]);

  void addTodo(String title) {
    state = [
      ...state,
      Todo(
        id: Uuid().v4(),
        title: title,
      ),
    ];
  }

  void toggleComplete(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            id: todo.id,
            title: todo.title,
            isCompleted: !todo.isCompleted,
            isFavourite: todo.isFavourite,
          )
        else
          todo,
    ];
  }

  void toggleFavourite(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            id: todo.id,
            title: todo.title,
            isCompleted: todo.isCompleted,
            isFavourite: !todo.isFavourite,
          )
        else
          todo,
    ];
  }

  void removeTodo(String id) {
    state = state.where((todo) => todo.id != id).toList();
  }
}

final todoListProvider = StateNotifierProvider<TodoList, List<Todo>>((ref) {
  return TodoList();
});

final filterProvider = StateProvider((ref) => TodoFilter.all);
