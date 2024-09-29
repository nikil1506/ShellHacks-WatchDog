import 'dart:io';

import 'package:auth0_flutter/auth0_flutter_web.dart';
import 'package:watchdog_dashboard/config.dart';
import 'package:watchdog_dashboard/modules/login/bloc/user_bloc.dart';
import 'package:watchdog_dashboard/modules/login/model/user_model.dart';

import '../../../widgets/loading_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;


  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Column(
        mainAxisSize: MainAxisSize.min,
        children: [LoadingWidget()],
      );
    }
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: context.colorScheme.secondaryContainer,
          ),
          Center(
            child: Text(
              'Watchdog Dashboard',
              style: context.textTheme.displayMedium,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Login as',
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          setState(() => loading = true);
                          await UserBloc.instance.login(UserType.dispatcher);
                          setState(() => loading = false);
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          foregroundColor: context.colorScheme.onPrimary,
                          backgroundColor: context.colorScheme.primary,
                        ),
                        child: Text(
                          "Dispatcher",
                          style: context.textTheme.titleSmall!
                              .copyWith(color: context.colorScheme.onPrimary),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() => loading = true);
                          await UserBloc.instance.login(UserType.security);
                          setState(() => loading = false);
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          foregroundColor: context.colorScheme.primary,
                          backgroundColor: context.colorScheme.onPrimary,
                        ),
                        child: Text(
                          "Security",
                          style: context.textTheme.titleSmall,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
