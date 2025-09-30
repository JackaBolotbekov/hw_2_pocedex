import 'package:flutter/material.dart';

Color typeColor(String t) {
  switch (t) {
    case 'Grass':
      return const Color(0xFF78C850);
    case 'Poison':
      return const Color(0xFFA040A0);
    case 'Fire':
      return const Color(0xFFF08030);
    case 'Water':
      return const Color(0xFF6890F0);
    case 'Electric':
      return const Color(0xFFF8D030);
    case 'Bug':
      return const Color(0xFFA8B820);
    case 'Normal':
      return const Color(0xFFA8A878);
    case 'Psychic':
      return const Color(0xFFF85888);
    case 'Steel':
      return const Color(0xFFB8B8D0);
    case 'Ghost':
      return const Color(0xFF705898);
    case 'Rock':
      return const Color(0xFFB8A038);
    default:
      return const Color(0xFF9099B1);
  }
}
