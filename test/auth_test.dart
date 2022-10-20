import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';

void main() {
  group('mock authentication', () {
    final provider = MockAuthProvider();

    test('should not be initialized by', () {
      expect(provider.isInitialized, false);
    });

    test('cannot logout if not initialized', () {
      expect(provider.logout(),
          throwsA(const TypeMatcher<NotInitializedException>()));
    });

    test('should be able to initialize', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('user should be null after initialization', () async {
      await provider.initialize();
      expect(provider.currentUser, null);
    });

    test('should be able to initialize in less than 2 seconds', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 2)));

    test('creating a user with email that already exists should fail',
        () async {
      final badEmailUser = provider.createUser(
        email: 'foo@bar.com',
        password: 'anypassword',
      );
      expect(badEmailUser,
          throwsA(const TypeMatcher<UserEmailAlreadyInUseAuthException>()));
    });

    test('user logging in with the wrong password should fail', () async {
      final badPassword = provider.createUser(
        email: 'daniel@gmail.com',
        password: 'foobar',
      );
      expect(badPassword,
          throwsA(const TypeMatcher<UserWrongPasswordAuthException>()));
    });

    test('user with valid email and password should be able to log in',
        () async {
      final user = await provider.createUser(
        email: 'daniel@gmail.com',
        password: 'anypassword',
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('logged in user should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test(' should be able to log out and login', () async {
      await provider.logout();
      await provider.login(email: 'foo', password: 'bar');

      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user, provider.currentUser);
    });
  });
}

//. MOCKS
class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isEmailVerified = false;
  bool get isInitialized => _isEmailVerified;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isEmailVerified = true;
  }

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return login(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'foo@bar.com') throw UserEmailAlreadyInUseAuthException();
    if (password == 'foobar') throw UserWrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logout() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotLoggedInAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }
}
