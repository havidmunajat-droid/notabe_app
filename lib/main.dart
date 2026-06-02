import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'config/routes.dart';

void main() {
  runApp(const NotaBeApp());
}

class NotaBeApp extends StatelessWidget {
  const NotaBeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'NotaBe',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, // Pakai tema custom kita
      routerConfig: AppRoutes.router, // Pakai routing kita
    );
  }
}