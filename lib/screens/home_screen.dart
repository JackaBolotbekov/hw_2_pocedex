import 'package:flutter/material.dart';

import '../data/pokemon_data.dart';
import '../models/pokemon.dart';
import '../widgets/pokemon_card.dart';
import '../widgets/sort_chip.dart';
import 'pokemon_detail_screen.dart';

class PokedexHomeScreen extends StatelessWidget {
  const PokedexHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Pokemon> items = PokemonData.pokemon;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double contentMaxW = constraints.maxWidth.clamp(360.0, 560.0);
            final double contentH = constraints.maxHeight;

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentMaxW),
                child: SizedBox(
                  height: contentH,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x22000000),
                            blurRadius: 28,
                            offset: Offset(0, 10),
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                const Icon(Icons.catching_pokemon, size: 28),
                                const SizedBox(width: 8),
                                Text(
                                  'Pokédex',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 22,
                                      ),
                                ),
                                const Spacer(),
                                const SortChip(),
                              ],
                            ),
                          ),
                          const Divider(height: 1),
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, gridCons) {
                                const double hPad = 16;
                                const double vPad = 12;
                                const double spacing = 12;

                                final double gridW = gridCons.maxWidth - hPad * 2;
                                final int crossCount =
                                    (gridW / 124).floor().clamp(2, 4).toInt();

                                return GridView.builder(
                                  padding: const EdgeInsets.fromLTRB(hPad, vPad, hPad, 16),
                                  itemCount: items.length,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: spacing,
                                    mainAxisSpacing: spacing,
                                    crossAxisCount: crossCount,
                                    mainAxisExtent: 152,
                                  ),
                                  itemBuilder: (context, index) {
                                    final Pokemon pokemon = items[index];
                                    return InkWell(
                                      borderRadius: BorderRadius.circular(14),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => PokemonDetailScreen(
                                              all: items,
                                              index: index,
                                            ),
                                          ),
                                        );
                                      },
                                      child: PokemonCard(pokemon: pokemon),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
