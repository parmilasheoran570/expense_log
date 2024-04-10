
import 'package:expense_logo/deshbord/provider/money_record_provider.dart';
import 'package:expense_logo/login/service/database_service.dart';
import 'package:expense_logo/login/ui/login_screen.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'provider/auth_provider.dart';
import 'util/app_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseService databaseService = DatabaseService();
  await databaseService.initDatabase();
  runApp(MyApp(databaseService: databaseService));
}
  class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.databaseService});

  final DatabaseService databaseService;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ ChangeNotifierProvider(create: (context) {
        return AuthProvider(databaseService);
      }),
        ChangeNotifierProvider(create: (context) {
          return MoneyRecordProvider(databaseService);
        }),
      ], child: MaterialApp(
      debugShowCheckedModeBanner: false, title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: appColorScheme),
        useMaterial3: true,),
      home: const LoginScreen(),),
    );
  }
}
