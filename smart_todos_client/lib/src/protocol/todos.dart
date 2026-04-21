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
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class Todo implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String title;

  String? description;

  bool isCompleted;

  DateTime createdAt;

  DateTime updatedAt;

  String userId;

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
