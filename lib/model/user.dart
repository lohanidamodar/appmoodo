import 'dart:convert';

import 'package:flutter/foundation.dart';

class User {
  final String id;
  final String name;
  final String email;
  final Map<String, dynamic> prefs;
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.prefs,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    Map<String, dynamic>? prefs,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      prefs: prefs ?? this.prefs,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'prefs': prefs,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['\$id'],
      name: map['name'],
      email: map['email'],
      prefs: Map<String, dynamic>.from(map['prefs']),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, prefs: $prefs)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is User &&
      o.id == id &&
      o.name == name &&
      o.email == email &&
      mapEquals(o.prefs, prefs);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      prefs.hashCode;
  }
}
