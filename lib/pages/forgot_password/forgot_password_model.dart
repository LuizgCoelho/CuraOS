import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForgotPasswordState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;
  
  ForgotPasswordState({
    this.isLoading = false, 
    this.errorMessage,
    this.isSuccess = false,
  });

  ForgotPasswordState copyWith({bool? isLoading, String? errorMessage, bool? isSuccess}) {
    return ForgotPasswordState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class ForgotPasswordModel extends Notifier<ForgotPasswordState> {
  @override
  ForgotPasswordState build() {
    return ForgotPasswordState();
  }

  Future<void> sendRecoveryEmail(String email) async {
    if (email.trim().isEmpty) {
      state = state.copyWith(errorMessage: "Por favor, insira um e-mail.");
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);

    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(
        email.trim(),
      );
      state = state.copyWith(isLoading: false, isSuccess: true);
    } on AuthException catch (e) {
      print('AuthException no resetPasswordForEmail: \${e.message}');
      state = state.copyWith(
        isLoading: false, 
        errorMessage: "Insira um e-mail válido ou verifique sua conexão.",
      );
    } catch (e) {
      print('Exception no resetPasswordForEmail: \$e');
      state = state.copyWith(
        isLoading: false, 
        errorMessage: "Insira um e-mail válido ou verifique sua conexão.",
      );
    }
  }
}

final forgotPasswordModelProvider = NotifierProvider<ForgotPasswordModel, ForgotPasswordState>(() {
  return ForgotPasswordModel();
});
