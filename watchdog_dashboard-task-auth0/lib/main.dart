import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:watchdog_dashboard/config.dart';
import 'package:watchdog_dashboard/firebase_options.dart';
import 'package:watchdog_dashboard/modules/home/ui/security_dashboard.dart';
import 'package:watchdog_dashboard/modules/login/bloc/user_bloc.dart';
import 'package:watchdog_dashboard/modules/login/ui/login_page.dart';
import 'package:watchdog_dashboard/theme.dart';
import 'package:watchdog_dashboard/util.dart';

import 'modules/home/ui/dispatcher_dashboard.dart';
import 'modules/login/model/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme =
        createTextTheme(context, "Inter Tight", "Chau Philomene One");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      title: 'WatchDog',
      debugShowCheckedModeBanner: false,
      theme: theme.light().copyWith(
            appBarTheme: const AppBarTheme(
              color: Colors.transparent,
              centerTitle: false,
            ),
          ),
      scrollBehavior: ScrollConfiguration.of(context).copyWith(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: UserBloc.instance,
      builder: (context, value, child) {
        switch (value.type) {
          case UserType.guest:
            return const LoginPage();
          case UserType.dispatcher:
            return const DispatcherDashboard();
          case UserType.security:
            return const SecurityDashboard();
        }
      },
    );
  }
}
