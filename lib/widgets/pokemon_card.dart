import 'package:flutter/material.dart';

import '../models/pokemon.dart';
import '../utils/type_color.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonCard({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final Color color = typeColor(pokemon.types.isNotEmpty ? pokemon.types.first : '');
    const double radius = 14.0;
    const double borderWidth = 2.0;
    const double nameBarHeight = 30.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: color, width: borderWidth),
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            top: 6,
            right: 8,
            child: Text(
              '#${pokemon.id.toString().padLeft(3, '0')}',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
          Positioned.fill(
            top: 10,
            left: 6,
            right: 6,
            bottom: nameBarHeight + 8,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Image.network(
                pokemon.imageUrl,
                errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, size: 28),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: nameBarHeight,
              alignment: Alignment.center,
              child: Container(
                height: nameBarHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Text(
                  pokemon.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
