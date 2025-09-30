import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

class PokedexApp extends StatelessWidget {
  const PokedexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokédex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const PokedexHomeScreen(),
    );
  }
}
