import 'package:flutter/material.dart';
import 'package:imcapp/screens/home_page.dart';

void main() {
  runApp(const IMCApp());
}

class IMCApp extends StatelessWidget {
  const IMCApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IMC APP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
