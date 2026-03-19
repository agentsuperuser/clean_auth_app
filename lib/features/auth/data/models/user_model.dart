import 'package:flutter_clean_auth/features/auth/domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({required super.id, required super.email, required super.name});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name
    };
  }
}