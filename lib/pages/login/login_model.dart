import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../custom_code/actions/auth_supabase_login.dart';
import '../../app_state.dart';

class LoginState {
  final bool isLoading;
  final String? errorMessage;
  
  LoginState({this.isLoading = false, this.errorMessage});

  LoginState copyWith({bool? isLoading, String? errorMessage}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class LoginModel extends Notifier<LoginState> {
  @override
  LoginState build() {
    return LoginState();
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    final result = await authSupabaseLogin(email, password);
    
    if (result['ok'] == true) {
      // Salva o ID do usuário no AppState
      ref.read(appStateProvider.notifier).setUser(result['userId']);
      
      state = state.copyWith(isLoading: false);
      return true;
    } else {
      state = state.copyWith(
          isLoading: false, errorMessage: result['message']);
      return false;
    }
  }
}

final loginModelProvider = NotifierProvider<LoginModel, LoginState>(() {
  return LoginModel();
});
