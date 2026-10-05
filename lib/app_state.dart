import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppState {
  final String? loggedUserId;
  final Map<String, dynamic>? userInfo;

  AppState({this.loggedUserId, this.userInfo});

  AppState copyWith({
    String? loggedUserId,
    Map<String, dynamic>? userInfo,
  }) {
    return AppState(
      loggedUserId: loggedUserId ?? this.loggedUserId,
      userInfo: userInfo ?? this.userInfo,
    );
  }
}

class AppStateNotifier extends Notifier<AppState> {
  @override
  AppState build() {
    return AppState();
  }

  void setUser(String userId, [Map<String, dynamic>? info]) {
    state = state.copyWith(loggedUserId: userId, userInfo: info);
  }

  void clearUser() {
    state = AppState();
  }
}

final appStateProvider = NotifierProvider<AppStateNotifier, AppState>(() {
  return AppStateNotifier();
});
