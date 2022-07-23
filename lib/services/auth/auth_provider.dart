import 'package:notes/services/auth/auth_user.dart';

abstract class AuthProvider {
  Future<void> initialize();

  AuthUser? get currentUser;

  // login function
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });

  // create user function
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });

  // logout function
  Future<void> logOut();

  // send email verification function
  Future<void> sendEmailVerification();
}
