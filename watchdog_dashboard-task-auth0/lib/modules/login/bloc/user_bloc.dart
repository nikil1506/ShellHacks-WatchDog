import 'dart:async';

import 'package:auth0_flutter/auth0_flutter_web.dart';
import 'package:flutter/cupertino.dart';

import '../model/user_model.dart';

class UserBloc extends ValueNotifier<UserModel> {
  UserBloc(super.value);

  static UserBloc get instance => _instance ??= UserBloc(UserModel());

  static UserBloc? _instance;

  final Auth0Web auth0 = Auth0Web(
    'dev-f3fgvasvr0owwxw6.us.auth0.com',
    'vBAJBGhdJySCuFfjCklSzHmeM57NX6YA',
  );

  UserType get userType => value.type;

  Future<void> loadUser(Function(bool) callback) async {
    auth0.onLoad().then((final credentials) {
      if (credentials != null) {
        print('Logged IN ');
        print('creds $credentials ${credentials.user.customClaims}');
        value = UserModel(
          id: '',
          token: '',
          type: userType,
        );
        // Logged in!
        callback(true);
      } else {
        print('Not Logged IN ');
        callback(false);
        // Not logged in
      }
    });
  }

  Future<void> login(UserType type) async {
    final Completer<bool> completer = Completer();
    loadUser(
      (value) {
        completer.complete(value);
      },
    );
    final result = await completer.future;
    if (!result) _logIn(type);
  }

  Future<void> _logIn(UserType type) async {
    final credentials = await auth0.loginWithPopup();
    value = UserModel(
      id: '',
      token: '',
      type: type,
    );
  }

  Future<void> logOut() async {
    await auth0.logout();
    value = UserModel();
  }
}
