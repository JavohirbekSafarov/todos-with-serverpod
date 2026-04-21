import 'package:flutter/cupertino.dart';
import 'package:smart_todos_client/smart_todos_client.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:smart_todos_flutter/screens/sign_in_screen.dart';
import 'package:smart_todos_flutter/screens/todos_page.dart';

late final Client client;

late String serverUrl;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final serverUrl = "http://192.168.213.31:8080/";
  await getServerUrl();

  client = Client(serverUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = FlutterAuthSessionManager();

  client.auth.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: CupertinoColors.activeBlue,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: SignInScreen(
        child: const TodosPage(),
      ),
    );
  }
}
