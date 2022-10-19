//. LOGIN EXCEPTIONS
class UserNotFoundAuthException implements Exception {
  final String? message;

  UserNotFoundAuthException({this.message});

  @override
  String toString() => 'UserNotFoundAuthException: $message';
}

class UserWrongPasswordAuthException implements Exception {
  final String? message;

  UserWrongPasswordAuthException({this.message});

  @override
  String toString() => 'UserWrongPasswordAuthException: $message';
}

class UserInvalidEmailAuthException implements Exception {
  final String? message;

  UserInvalidEmailAuthException({this.message});

  @override
  String toString() => 'UserInvalidEmailAuthException: $message';
}

//. REGISTER EXCEPTIONS

class UserWeakPasswordAuthException implements Exception {
  final String? message;

  UserWeakPasswordAuthException({this.message});

  @override
  String toString() => 'UserWeakPasswordAuthException: $message';
}

class UserEmailAlreadyInUseAuthException implements Exception {
  final String? message;

  UserEmailAlreadyInUseAuthException({this.message});

  @override
  String toString() => 'UserEmailAlreadyInUseAuthException: $message';
}

// . GENERAL EXCEPTIONS

class GenericAuthException implements Exception {
  final String? message;

  GenericAuthException({this.message});

  @override
  String toString() => message ?? 'Unknown error, please try again';
}

class UserNotLoggedInAuthException implements Exception {
  final String? message;

  UserNotLoggedInAuthException({this.message});

  @override
  String toString() => 'UserNotLoggedInAuthException: ${message ?? ''}';
}
