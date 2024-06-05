import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_app/model/todo_model.dart';
import 'package:to_do_app/view_model/todo_view_model.dart';

enum TodoFilter { all, active, favourite, done }

class TodoScreen extends ConsumerWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoListProvider);
    final filter = ref.watch(filterProvider);

    List<Todo> filteredTodos;
    switch (filter) {
      case TodoFilter.active:
        filteredTodos = todos.where((todo) => !todo.isCompleted).toList();
        break;
      case TodoFilter.favourite:
        filteredTodos = todos.where((todo) => todo.isFavourite).toList();
        break;
      case TodoFilter.done:
        filteredTodos = todos.where((todo) => todo.isCompleted).toList();
        break;
      case TodoFilter.all:
      default:
        filteredTodos = todos;
    }

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Todopad'),
          bottom: TabBar(
            onTap: (index) {
              switch (index) {
                case 0:
                  ref.read(filterProvider.notifier).state = TodoFilter.all;
                  break;
                case 1:
                  ref.read(filterProvider.notifier).state = TodoFilter.active;
                  break;
                case 2:
                  ref.read(filterProvider.notifier).state =
                      TodoFilter.favourite;
                  break;
                case 3:
                  ref.read(filterProvider.notifier).state = TodoFilter.done;
                  break;
              }
            },
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Active'),
              Tab(text: 'Favourite'),
              Tab(text: 'Done'),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onSubmitted: (value) {
                  ref.read(todoListProvider.notifier).addTodo(value);
                },
                decoration: const InputDecoration(
                  labelText: 'What do you want to do?',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Text(
              '${todos.where((todo) => todo.isCompleted).length} of ${todos.length} tasks completed',
            ),
            Expanded(
              child: ListView(
                children: [
                  for (final todo in filteredTodos)
                    ListTile(
                      title: Text(todo.title),
                      leading: Checkbox(
                        value: todo.isCompleted,
                        onChanged: (_) {
                          ref
                              .read(todoListProvider.notifier)
                              .toggleComplete(todo.id);
                        },
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          todo.isFavourite ? Icons.star : Icons.star_border,
                        ),
                        onPressed: () {
                          ref
                              .read(todoListProvider.notifier)
                              .toggleFavourite(todo.id);
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
