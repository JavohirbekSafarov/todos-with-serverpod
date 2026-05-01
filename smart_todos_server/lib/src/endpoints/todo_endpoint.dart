import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:smart_todos_server/src/generated/protocol.dart';

class TodoEndpoint extends Endpoint {
  Future<List<Todo>> getTodos(Session session) async {
    final userId = session.authenticated?.authUserId;
    if (userId == null) throw Exception('Login qiling!');
    return await Todo.db.find(
      session,
      where: (t) => t.userId.equals(userId.toString()),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  Future<Todo> createTodo(
    Session session,
    String title,
    String? description,
  ) async {
    final userId = session.authenticated?.authUserId;
    if (userId == null) throw Exception('Login qiling!');

    final todo = Todo(
      title: title,
      description: description,
      isCompleted: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      userId: userId.toString(),
    );
    return await Todo.db.insertRow(session, todo);
  }

  Future<Todo> updateTodo(Session session, Todo todo) async {
    final userId = session.authenticated?.authUserId;
    if (userId == null) {
      throw Exception('Login qiling!');
    }

    final existing = await Todo.db.findById(session, todo.id!);
    if (existing == null || existing.userId.toString() != userId.toString()) {
      throw Exception('Bu sizning todoingiz emas!');
    }

    todo.updatedAt = DateTime.now();
    await Todo.db.updateRow(session, todo);
    return todo;
  }

  Future<void> deleteTodo(Session session, int id) async {
    final userId = session.authenticated?.authUserId;
    if (userId == null) throw Exception('Login qiling!');

    await Todo.db.deleteWhere(
      session,
      where: (t) => t.id.equals(id) & t.userId.equals(userId.toString()),
    );
  }
}
