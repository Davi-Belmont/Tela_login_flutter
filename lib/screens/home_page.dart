
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
 
import '../controllers/home_controller.dart';
import 'login_page.dart';
 
/// Apenas DESIGN: o texto vem do HomeController.
class HomePage extends StatelessWidget {
  final HomeController controller;
 
  HomePage({super.key, required String nome})
      : controller = HomeController(nome);
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text(controller.titulo),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pushReplacement(
            context,
            CupertinoPageRoute(builder: (_) => const LoginPage()),
          ),
          child: const Text('Sair'),
        ),
      ),
      body: Center(
        child: Text(
          controller.saudacao,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
 