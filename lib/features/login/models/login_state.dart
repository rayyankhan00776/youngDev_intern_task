enum LoginStatus { initial, loading, success, error }

class LoginState {
  final LoginStatus status;
  final String? errorMessage;
  final bool isAuthenticated;

  LoginState({
    this.status = LoginStatus.initial,
    this.errorMessage,
    this.isAuthenticated = false,
  });

  LoginState copyWith({
    LoginStatus? status,
    String? errorMessage,
    bool? isAuthenticated,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}
