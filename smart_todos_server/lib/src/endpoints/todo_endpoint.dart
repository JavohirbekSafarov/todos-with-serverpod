import 'package:serverpod/serverpod.dart';
import 'package:smart_todos_server/src/generated/protocol.dart';

class TodoEndpoint extends Endpoint {
  // Faqat autentifikatsiya qilingan foydalanuvchilar ishlatishi mumkin
  Future<List<Todo>> getTodos(Session session) async {
    // final userId = session.authenticated?.authId;
    // if (userId == null) throw Exception('Login qiling!');

    return await Todo.db.find(
      session,
     // where: (t) => t.userId.equals(userId),
      orderBy: (t) => t.createdAt,
    );
  }

  Future<Todo> createTodo(Session session, String title, String? description) async {
    // final userId = session.authenticated?.authId;
    // if (userId == null) throw Exception('Login qiling!');

    final todo = Todo(
      title: title,
      description: description,
      isCompleted: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      userId: "userId",
    );
    return await Todo.db.insertRow(session, todo);
  }

  Future<Todo> updateTodo(Session session, Todo todo) async {
    // final userId = session.authenticated?.authId;
    // if (userId == null || todo.userId != userId) {
    //   throw Exception('Bu sizning todoingiz emas!');
    // }
    await Todo.db.updateRow(session, todo);
    return todo;
  }

  Future<void> deleteTodo(Session session, int id) async {
    // final userId = session.authenticated?.authId;
    // if (userId == null) throw Exception('Login qiling!');

    await Todo.db.deleteWhere(
      session,
      where: (t) => t.id.equals(id) //& t.userId.equals(userId),
    );
  }
}