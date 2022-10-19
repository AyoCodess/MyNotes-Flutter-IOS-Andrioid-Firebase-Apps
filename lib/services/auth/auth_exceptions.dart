//. LOGIN EXCEPTIONS
class UserNotFoundAuthException implements Exception {}

class UserWrongPasswordAuthException implements Exception {}

class UserInvalidEmailAuthException implements Exception {}

//. REGISTER EXCEPTIONS

class UserWeakPasswordAuthException implements Exception {}

class UserEmailAlreadyInUseAuthException implements Exception {}

// . GENERAL EXCEPTIONS

class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
