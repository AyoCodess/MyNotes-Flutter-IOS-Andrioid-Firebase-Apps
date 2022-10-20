// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth show User;
import 'package:flutter/material.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;
  const AuthUser({required this.isEmailVerified});

  factory AuthUser.fromFirebaseUser(FirebaseAuth.User user) =>
      AuthUser(isEmailVerified: user.emailVerified);

  // factory AuthUser.fromAny(user) => AuthUser(user.emailVerified);
}
