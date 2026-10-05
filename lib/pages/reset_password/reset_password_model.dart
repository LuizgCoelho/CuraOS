import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResetPasswordState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;
  
  ResetPasswordState({
    this.isLoading = false, 
    this.errorMessage,
    this.isSuccess = false,
  });

  ResetPasswordState copyWith({bool? isLoading, String? errorMessage, bool? isSuccess}) {
    return ResetPasswordState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class ResetPasswordModel extends Notifier<ResetPasswordState> {
  @override
  ResetPasswordState build() {
    return ResetPasswordState();
  }

  Future<void> resetPassword(String password, String confirmPassword) async {
    if (password.length < 8) {
      state = state.copyWith(errorMessage: "A senha deve ter no mínimo 8 caracteres.");
      return;
    }

    if (password != confirmPassword) {
      state = state.copyWith(errorMessage: "As senhas não coincidem.");
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);

    try {
      final response = await Supabase.instance.client.auth.updateUser(
        UserAttributes(
          password: password,
        ),
      );
      
      if (response.user != null) {
        state = state.copyWith(isLoading: false, isSuccess: true);
      } else {
        state = state.copyWith(
          isLoading: false, 
          errorMessage: "Falha ao atualizar a senha.",
        );
      }
    } on AuthException catch (e) {
      state = state.copyWith(
        isLoading: false, 
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false, 
        errorMessage: "Ocorreu um erro ao redefinir a senha. Tente novamente.",
      );
    }
  }
}

final resetPasswordModelProvider = NotifierProvider<ResetPasswordModel, ResetPasswordState>(() {
  return ResetPasswordModel();
});
