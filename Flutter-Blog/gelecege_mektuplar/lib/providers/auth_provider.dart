import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gelecege_mektuplar/data/models/user_model.dart';
import 'package:gelecege_mektuplar/data/repositories/auth_repository.dart';

part 'auth_provider.freezed.dart';

/// Kimlik doğrulama durumunu temsil eden mühürlü sınıf.
@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated({required UserModel user}) =
      _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.error({required String message}) = _Error;
}

/// Kimlik doğrulama state'ini yöneten StateNotifier.
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthNotifier(this._authRepository, this._ref)
    : super(const AuthState.initial()) {
    checkAuthStatus(); // Uygulama başladığında kimlik doğrulama durumunu kontrol et.
  }

  /// Uygulama başladığında veya yeniden yüklendiğinde oturum durumunu kontrol eder.
  Future<void> checkAuthStatus() async {
    state = const AuthState.loading();
    try {
      final user = await _authRepository.getMe();
      if (user != null) {
        state = AuthState.authenticated(user: user);
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.error(message: e.toString());
    }
  }

  /// Kullanıcı girişi yapar.
  Future<void> login(String email, String password) async {
    state = const AuthState.loading();
    try {
      final user = await _authRepository.login(
        email: email,
        password: password,
      );
      state = AuthState.authenticated(user: user);
    } catch (e) {
      state = AuthState.error(message: e.toString());
    }
  }

  /// Kullanıcı kaydı yapar.
  Future<void> register(String username, String email, String password) async {
    state = const AuthState.loading();
    try {
      final user = await _authRepository.register(
        username: username,
        email: email,
        password: password,
      );
      state = AuthState.authenticated(user: user);
    } catch (e) {
      state = AuthState.error(message: e.toString());
    }
  }

  /// Kullanıcı çıkışı yapar.
  Future<void> logout() async {
    state = const AuthState.loading();
    try {
      await _authRepository.logout();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(message: e.toString());
    }
  }
}

/// AuthNotifier'ı sağlamak için Riverpod StateNotifierProvider'ı.
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider), ref);
});
