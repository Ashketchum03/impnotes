import 'package:notes/services/auth/auth_exceptions.dart';
import 'package:notes/services/auth/auth_provider.dart';
import 'package:notes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();

    test('Should not be initialized to begin with', () {
      expect(provider.isInitialized, false);
    });

    test('Cannot log out if not initialized', () {
      expect(
          provider.logOut(),
          throwsA(
            const TypeMatcher<NotInitializedException>(),
          ));
    });

    test('Should be able to be initialized', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('user should be null after initialization', () {
      expect(provider.currentUser, null);
    });

    test('Should be able to initialize in less than 2 seconds', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 2)));

    test('Create user should get expected values', () async {
      /**
      final badEmailUser = await provider.createUser(
        email: 'foobar@baz.com',
        password: 'anypassword',
      );

      expect(badEmailUser,
          throwsA(const TypeMatcher<EmailAlreadyInUseAuthException>()));

      final badPasswordUser =
          await provider.createUser(email: 'someone@bar.com', password: 'any');

      expect(badPasswordUser,
          throwsA(const TypeMatcher<WeakPassWordAuthException>()));
      
      */

      final user = await provider.createUser(
          email: 'fooBarBaz@bar.com', password: 'password');

      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('Logged In user should be able to get verified', () async {
      await provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('Should be able to log in', () async {
      /** 
      final badEmailUser = await provider.logIn(
        email: 'foo@bar.com',
        password: 'anypassword',
      );

      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      final badPasswordUser =
          await provider.logIn(email: 'someone@bar.com', password: 'foobar');

      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));
      */
    });

    test('Should be able to log out and log in again', () async {
      await provider.logOut();
      await provider.logIn(
        email: 'email@gmail.com',
        password: 'password',
      );

      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'foobar@baz.com') throw EmailAlreadyInUseAuthException();
    if (password == 'any') throw WeakPassWordAuthException();
    const user = AuthUser(email: "fooBazBar@bak.com", isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'foo@bar.com') throw UserNotFoundAuthException();
    if (password == 'foobar') throw WrongPasswordAuthException();
    const user = AuthUser(email: "fooBazBar@bak.com", isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(email: "fooBazBar@bak.com", isEmailVerified: true);
    _user = newUser;
  }
}
