import 'package:flutter/material.dart';

import 'screens/login_page.dart';

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      theme: ThemeData(
        useMaterial3: true,
        platform: TargetPlatform.iOS,
        colorSchemeSeed: const Color(0xFF007AFF),
        scaffoldBackgroundColor: const Color(0xFFF2F2F7),
      ),
      home: const LoginPage(),
    );
  }
}
