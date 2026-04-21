/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class Todo implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Todo._({
    this.id,
    required this.title,
    this.description,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  factory Todo({
    int? id,
    required String title,
    String? description,
    required bool isCompleted,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String userId,
  }) = _TodoImpl;

  factory Todo.fromJson(Map<String, dynamic> jsonSerialization) {
    return Todo(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String?,
      isCompleted: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isCompleted'],
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      userId: jsonSerialization['userId'] as String,
    );
  }

  static final t = TodoTable();

  static const db = TodoRepository._();

  @override
  int? id;

  String title;

  String? description;

  bool isCompleted;

  DateTime createdAt;

  DateTime updatedAt;

  String userId;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Todo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Todo copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Todo',
      if (id != null) 'id': id,
      'title': title,
      if (description != null) 'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'userId': userId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Todo',
      if (id != null) 'id': id,
      'title': title,
      if (description != null) 'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'userId': userId,
    };
  }

  static TodoInclude include() {
    return TodoInclude._();
  }

  static TodoIncludeList includeList({
    _i1.WhereExpressionBuilder<TodoTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TodoTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TodoTable>? orderByList,
    TodoInclude? include,
  }) {
    return TodoIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Todo.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Todo.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TodoImpl extends Todo {
  _TodoImpl({
    int? id,
    required String title,
    String? description,
    required bool isCompleted,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String userId,
  }) : super._(
         id: id,
         title: title,
         description: description,
         isCompleted: isCompleted,
         createdAt: createdAt,
         updatedAt: updatedAt,
         userId: userId,
       );

  /// Returns a shallow copy of this [Todo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Todo copyWith({
    Object? id = _Undefined,
    String? title,
    Object? description = _Undefined,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
  }) {
    return Todo(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      description: description is String? ? description : this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
    );
  }
}

class TodoUpdateTable extends _i1.UpdateTable<TodoTable> {
  TodoUpdateTable(super.table);

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<bool, bool> isCompleted(bool value) => _i1.ColumnValue(
    table.isCompleted,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );

  _i1.ColumnValue<String, String> userId(String value) => _i1.ColumnValue(
    table.userId,
    value,
  );
}

class TodoTable extends _i1.Table<int?> {
  TodoTable({super.tableRelation}) : super(tableName: 'todo') {
    updateTable = TodoUpdateTable(this);
    title = _i1.ColumnString(
      'title',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    isCompleted = _i1.ColumnBool(
      'isCompleted',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
    userId = _i1.ColumnString(
      'userId',
      this,
    );
  }

  late final TodoUpdateTable updateTable;

  late final _i1.ColumnString title;

  late final _i1.ColumnString description;

  late final _i1.ColumnBool isCompleted;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnString userId;

  @override
  List<_i1.Column> get columns => [
    id,
    title,
    description,
    isCompleted,
    createdAt,
    updatedAt,
    userId,
  ];
}

class TodoInclude extends _i1.IncludeObject {
  TodoInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Todo.t;
}

class TodoIncludeList extends _i1.IncludeList {
  TodoIncludeList._({
    _i1.WhereExpressionBuilder<TodoTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Todo.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Todo.t;
}

class TodoRepository {
  const TodoRepository._();

  /// Returns a list of [Todo]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Todo>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<TodoTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TodoTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TodoTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Todo>(
      where: where?.call(Todo.t),
      orderBy: orderBy?.call(Todo.t),
      orderByList: orderByList?.call(Todo.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Todo] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Todo?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<TodoTable>? where,
    int? offset,
    _i1.OrderByBuilder<TodoTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TodoTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Todo>(
      where: where?.call(Todo.t),
      orderBy: orderBy?.call(Todo.t),
      orderByList: orderByList?.call(Todo.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Todo] by its [id] or null if no such row exists.
  Future<Todo?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Todo>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Todo]s in the list and returns the inserted rows.
  ///
  /// The returned [Todo]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<Todo>> insert(
    _i1.DatabaseSession session,
    List<Todo> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<Todo>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [Todo] and returns the inserted row.
  ///
  /// The returned [Todo] will have its `id` field set.
  Future<Todo> insertRow(
    _i1.DatabaseSession session,
    Todo row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Todo>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Todo]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Todo>> update(
    _i1.DatabaseSession session,
    List<Todo> rows, {
    _i1.ColumnSelections<TodoTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Todo>(
      rows,
      columns: columns?.call(Todo.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Todo]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Todo> updateRow(
    _i1.DatabaseSession session,
    Todo row, {
    _i1.ColumnSelections<TodoTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Todo>(
      row,
      columns: columns?.call(Todo.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Todo] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Todo?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<TodoUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Todo>(
      id,
      columnValues: columnValues(Todo.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Todo]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Todo>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<TodoUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<TodoTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TodoTable>? orderBy,
    _i1.OrderByListBuilder<TodoTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Todo>(
      columnValues: columnValues(Todo.t.updateTable),
      where: where(Todo.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Todo.t),
      orderByList: orderByList?.call(Todo.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Todo]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Todo>> delete(
    _i1.DatabaseSession session,
    List<Todo> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Todo>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Todo].
  Future<Todo> deleteRow(
    _i1.DatabaseSession session,
    Todo row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Todo>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Todo>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<TodoTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Todo>(
      where: where(Todo.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<TodoTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Todo>(
      where: where?.call(Todo.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Todo] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<TodoTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Todo>(
      where: where(Todo.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
