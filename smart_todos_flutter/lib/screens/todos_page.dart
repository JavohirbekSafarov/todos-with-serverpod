import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:smart_todos_client/smart_todos_client.dart';
import 'package:smart_todos_flutter/main.dart';

class TodosPage extends StatefulWidget {
  const TodosPage({super.key});

  @override
  State<TodosPage> createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  final List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    getTodos();
  }

  Future<void> getTodos() async {
    if (mounted) {
      final value = await client.todo.getTodos();
      setState(() {
        _todos.clear();
        _todos.addAll(value);
        return;
      });
    }
  }

  void changeChecked(Todo todo, int index) {
    var newTodo = todo.copyWith(isCompleted: !todo.isCompleted);
    client.todo
        .updateTodo(newTodo)
        .then((value) {
          if (mounted) {
            setState(() {
              _todos[index] = value;
            });
          }
        })
        .catchError((error) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error updating todo: $error')),
            );
          }
        });
  }

  void showAddTodoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final titleController = TextEditingController();
        final descriptionController = TextEditingController();
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Add New Todo', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      if (titleController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Title cannot be empty'),
                          ),
                        );
                        return;
                      } else if (descriptionController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Description cannot be empty'),
                          ),
                        );
                        return;
                      }
                      client.todo
                          .createTodo(
                            titleController.text,
                            descriptionController.text,
                          )
                          .then((todo) {
                            if (mounted) {
                              setState(() {
                                _todos.add(todo);
                              });
                              Navigator.of(context).pop();
                            }
                          })
                          .catchError((error) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error creating todo: $error'),
                                ),
                              );
                            }
                          });
                    },
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Create'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int _screenHeight = MediaQuery.of(context).size.height.toInt();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('My Todos'),
        actions: [
          IconButton(
            onPressed: () {
              client.auth
                  .signOutDevice()
                  .then((_) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Logged out successfully'),
                        ),
                      );
                    }
                  })
                  .catchError((error) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error logging out: $error')),
                      );
                    }
                  });
            },
            icon: const Icon(
              CupertinoIcons.power,
              size: 18,
            ),
          ),
        ],
      ),
      body: LiquidPullToRefresh(
        showChildOpacityTransition: false,
        animSpeedFactor: 5,
        height: 50,
        onRefresh: getTodos,
        color: Theme.of(context).colorScheme.primaryContainer,
        child: _todos.isNotEmpty
            /// if there are todos, show them in a ListView
            ? ListView.separated(
                itemCount: _todos.length,
                separatorBuilder: (context, index) =>
                    Container(height: 1, color: Colors.grey[300]),
                itemBuilder: (context, index) {
                  var todo = _todos[index];
                  return ListTile(
                    leading: SizedBox(
                      width: 18,
                      child: Checkbox(
                        value: todo.isCompleted,
                        onChanged: (value) => changeChecked(todo, index),
                      ),
                    ),
                    title: Text(
                      todo.title,
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    subtitle: Text(
                      todo.description ?? '',
                      style: TextStyle(color: Colors.black54, fontSize: 11),
                    ),
                    trailing: Text(
                      todo.createdAt.compareTo(
                                DateTime.now().subtract(
                                  const Duration(days: 1),
                                ),
                              ) >
                              0
                          ? todo.createdAt.toLocal().toString().substring(
                              11,
                              16,
                            )
                          : "${todo.createdAt.toLocal().toString().substring(11, 16)}\n"
                                "${todo.createdAt.toLocal().toString().substring(0, 10)}",
                      textAlign: TextAlign.end,
                    ),
                    onTap: () => changeChecked(todo, index),
                    onLongPress: () => client.todo
                        .deleteTodo(todo.id!)
                        .then((_) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Todo deleted: ${todo.title}'),
                              ),
                            );
                            getTodos();
                          }
                        })
                        .catchError((error) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error deleting todo: $error'),
                              ),
                            );
                          }
                        }),
                  );
                },
              )
            /// if there are no todos, show a friendly message
            : ListView(
                children: [
                  SizedBox(height: _screenHeight / 2 - 100),
                  Text(
                    'No todos yet',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  Text(
                    'Tap + to add your first todo!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddTodoDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
