import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'index.dart'; // Exporta as páginas
import 'app_state.dart';
import 'environment_values/ff_dev_environment_values.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await FFDevEnvironmentValues().initialize();

  try {
    await Supabase.initialize(
      url: FFDevEnvironmentValues().SupabaseAPIURL,
      anonKey: FFDevEnvironmentValues().SupabaseAnonKey,
    );
  } catch (e) {
    debugPrint('Erro ao inicializar o Supabase: $e');
  }

  runApp(
    const ProviderScope(
      child: CuraOSApp(),
    ),
  );
}

final _router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginWidget(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordWidget(),
    ),
    GoRoute(
      path: '/email-sent',
      builder: (context, state) {
        final email = state.uri.queryParameters['email'] ?? '';
        return EmailSentWidget(email: email);
      },
    ),
    GoRoute(
      path: '/reset-password',
      builder: (context, state) => const ResetPasswordWidget(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const Scaffold(
        body: Center(
          child: Text('Dashboard (Em breve)'),
        ),
      ),
    ),
  ],
);

class CuraOSApp extends StatefulWidget {
  const CuraOSApp({super.key});

  @override
  State<CuraOSApp> createState() => _CuraOSAppState();
}

class _CuraOSAppState extends State<CuraOSApp> {
  @override
  void initState() {
    super.initState();
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      if (event == AuthChangeEvent.passwordRecovery) {
        // Redireciona para a tela de redefinir senha quando o usuário
        // clicar no link de recuperação de senha no e-mail
        _router.go('/reset-password');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CuraOS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F172A)),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
      ),
      routerConfig: _router,
    );
  }
}
