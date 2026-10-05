import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FFDevEnvironmentValues {
  static const String currentEnvironment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'Qa',
  );

  static const bool isProduction = currentEnvironment == 'Production';
  static const bool isHomolog = currentEnvironment == 'Homolog';

  /// Mapeamento alinhado com zeroum_migration/env/:
  /// - Qa          → env/.env.qa (projeto Supabase ativo)
  /// - Homolog     → env/.env.homolog
  /// - Production  → placeholder (produção definitiva ainda não provisionada)
  static const String environmentValuesPath = isProduction
      ? 'assets/environment_values/environment_production.json'
      : isHomolog
      ? 'assets/environment_values/environment_homolog.json'
      : 'assets/environment_values/environment_qa.json';

  static final FFDevEnvironmentValues _instance =
      FFDevEnvironmentValues._internal();

  factory FFDevEnvironmentValues() {
    return _instance;
  }

  FFDevEnvironmentValues._internal();

  Future<void> initialize() async {
    try {
      final String response = await rootBundle.loadString(
        environmentValuesPath,
      );
      final data = await json.decode(response);
      _version = data['version'] ?? 'v0.0.0';
      _environment = data['environment'] ?? '';
      _SupabaseProjectRef = data['SupabaseProjectRef'] ?? '';
      _SupabaseAPIURL = data['SupabaseAPIURL'] ?? '';
      _SupabaseAnonKey = data['SupabaseAnonKey'] ?? '';
      _hereApiKey = data['hereApiKey'] ?? '';
    } catch (e) {
      debugPrint('Error loading environment values: $e');
    }
  }

  String _version = 'v0.0.0';
  String get version => _version;

  String _environment = '';
  String get environment => _environment;

  String _SupabaseProjectRef = '';
  String get SupabaseProjectRef => _SupabaseProjectRef;

  String _SupabaseAPIURL = '';
  String get SupabaseAPIURL => _SupabaseAPIURL;

  String _SupabaseAnonKey = '';
  String get SupabaseAnonKey => _SupabaseAnonKey;

  String _hereApiKey = '';
  String get hereApiKey => _hereApiKey;

  String get supabaseFunctionsBaseUrl => '$_SupabaseAPIURL/functions/v1';

  String get supabaseStorageBaseUrl =>
      '$_SupabaseAPIURL/storage/v1/object/public';
}
