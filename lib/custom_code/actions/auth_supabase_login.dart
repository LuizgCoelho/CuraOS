import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

Future<Map<String, dynamic>> authSupabaseLogin(
  String email,
  String password,
) async {
  final supa = Supabase.instance.client;
  try {
    final res = await supa.auth.signInWithPassword(email: email, password: password);
    final user = res.user;

    debugPrint(user.toString());
    return {
      'ok': true,
      'userId': user?.id,
      'message': null,
      'code': null,
    };
  } on AuthException catch (e) {
    final code = e.statusCode; // pode vir null; use e.message tbm
    String msgPt;

    switch (code) {
      case '400':
        if ((e.message).toLowerCase().contains('invalid login credentials')) {
          msgPt = 'E-mail ou senha inválidos.';
        } else if ((e.message).toLowerCase().contains('email not confirmed')) {
          msgPt = 'Confirme seu e-mail para continuar.';
        } else if ((e.message).toLowerCase().contains('missing email or phone')) {
          msgPt = 'Informe e-mail e senha.';
        } else {
          msgPt = 'Não foi possível entrar. Verifique os dados e tente novamente.';
        }
        break;
      case '422':
        msgPt = 'Formato de e-mail inválido.';
        break;
      default:
        msgPt = 'Ocorreu um erro ao entrar. Tente novamente.';
    }

    return {
      'ok': false,
      'userId': null,
      'message': msgPt,
      'code': code ?? 'unknown',
    };
  } catch (_) {
    return {
      'ok': false,
      'userId': null,
      'message': 'Falha de conexão. Verifique sua internet.',
      'code': 'network',
    };
  }
}
