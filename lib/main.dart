import 'dart:ui' show FontFeature;
import 'package:flutter/material.dart';

void main() => runApp(const PokedexApp());

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

//////////////////////////// MAIN SCREEN ////////////////////////////
class PokedexHomeScreen extends StatelessWidget {
  const PokedexHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = _pokemon;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Адаптивная ширина «колонки» приложения
            final double contentMaxW = constraints.maxWidth.clamp(360.0, 560.0);

            // Высота контейнера = вся доступная высота (минус внешние паддинги)
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
                          // Header
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
                                const _SortChip(),
                              ],
                            ),
                          ),
                          const Divider(height: 1),

                          // Grid адаптивная
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, gridCons) {
                                // Внутренние отступы сетки (как в макете)
                                const double hPad = 16;
                                const double vPad = 12;
                                const double spacing = 12;

                                final double gridW = gridCons.maxWidth - hPad * 2;
                                // Желаемая ширина карточки ~124 пикс → считаем колонки
                                int crossCount = (gridW / 124).floor().clamp(2, 4);
                                // Реальная ширина тайла с учётом промежутков
                                final double tileW = (gridW - spacing * (crossCount - 1)) / crossCount;
                                // Пропорция карточки (чуть выше, чем шире)
                                final double tileH = tileW * 1.18;

                                return GridView.builder(
                                  padding: const EdgeInsets.fromLTRB(hPad, vPad, hPad, 16),
                                  itemCount: items.length,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossCount,
                                    crossAxisSpacing: spacing,
                                    mainAxisSpacing: spacing,
                                    mainAxisExtent: 152,
                                  ),
                                  itemBuilder: (context, i) {
                                    final p = items[i];
                                    return InkWell(
                                      borderRadius: BorderRadius.circular(14),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => PokemonDetailScreen(
                                              all: items,   // <-- весь список
                                              index: i,     // <-- текущий индекс
                                            ),
                                          ),
                                        );
                                      },
                                      child: PokemonCard(p),
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

class _SortChip extends StatelessWidget {
  const _SortChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('#', style: TextStyle(fontWeight: FontWeight.w700)),
          SizedBox(width: 4),
          Icon(Icons.arrow_downward, size: 16),
        ],
      ),
    );
  }
}

//////////////////////////// CARD ////////////////////////////
class PokemonCard extends StatelessWidget {
  final Pokemon p;
  const PokemonCard(this.p, {super.key});

  @override
  Widget build(BuildContext context) {
    final c = typeColor(p.types.isNotEmpty ? p.types.first : '');
    const radius = 14.0;
    const borderW = 2.0;
    const nameBarH = 30.0; // высота нижней плашки с именем

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: c, width: borderW),
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias, // важно для «слияния» низа
      child: Stack(
        children: [
          // № в правом верхнем
          Positioned(
            top: 6,
            right: 8,
            child: Text(
              '#${p.id.toString().padLeft(3, '0')}',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: c,
              ),
            ),
          ),

          // Блок картинки: вся область над плашкой имени
          Positioned.fill(
            top: 10,              // небольшой верхний отступ как в макете
            left: 6,
            right: 6,
            bottom: nameBarH + 8, // оставить место под плашку
            child: FittedBox(
              fit: BoxFit.contain,
              child: Image.network(
                p.imageUrl,
                // размеров не задаём — FittedBox сам отмасштабирует
                errorBuilder: (_, __, ___) =>
                const Icon(Icons.image_not_supported, size: 28),
              ),
            ),
          ),

          // Нижняя плашка-«островок» (сливается с рамкой)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: nameBarH,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              // фон делаем цветом типа, как в фигме
              child: Container(
                height: nameBarH,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: c,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Text(
                  p.name,
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

//////////////////////////// DETAIL ////////////////////////////
// ---------------- DETAIL with left/right navigation ----------------
class PokemonDetailScreen extends StatefulWidget {
  final List<Pokemon> all;
  final int index;
  const PokemonDetailScreen({super.key, required this.all, required this.index});

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  late int _index;

  Pokemon get pokemon => widget.all[_index];

  @override
  void initState() {
    super.initState();
    _index = widget.index;
  }

  bool get canPrev => _index > 0;
  bool get canNext => _index < widget.all.length - 1;

  void _goPrev() {
    if (!canPrev) return;
    setState(() => _index--);
  }

  void _goNext() {
    if (!canNext) return;
    setState(() => _index++);
  }

  @override
  Widget build(BuildContext context) {
    final c = typeColor(pokemon.types.isNotEmpty ? pokemon.types.first : '');
    final faded = c.withOpacity(.14);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, cons) {
            final double contentMaxW = cons.maxWidth.clamp(360.0, 560.0);
            final double contentH = cons.maxHeight;

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentMaxW),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: LayoutBuilder(
                    builder: (context, inner) {
                      final w = inner.maxWidth;
                      final headerH = (w * 0.62).clamp(260.0, 360.0);
                      final imgSize = w * 0.50;
                      final overlap = 64.0;
                      final contentTop = headerH - overlap;

                      // сколько части изображения «заезжает» внутрь панели
                      final imageInsidePanel = imgSize * 0.45;
                      final panelTopPadding = 20 + imageInsidePanel + 8;

                      return SizedBox(
                        height: contentH - 32, // минус внешние паддинги
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Шапка
                            Container(
                              height: headerH,
                              decoration: BoxDecoration(
                                color: c,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Stack(
                                children: [
                                  // back
                                  Positioned(
                                    left: 12,
                                    top: 8,
                                    child: IconButton(
                                      onPressed: () => Navigator.pop(context),
                                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                                    ),
                                  ),
                                  // title
                                  Positioned(
                                    left: 56,
                                    top: 14,
                                    right: 96,
                                    child: Text(
                                      pokemon.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  // #id
                                  Positioned(
                                    top: 20,
                                    right: 16,
                                    child: Text(
                                      '#${pokemon.id.toString().padLeft(3, '0')}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  // watermark
                                  Positioned(
                                    right: 12,
                                    top: headerH * 0.22,
                                    child: Icon(
                                      Icons.catching_pokemon,
                                      size: w * 0.42,
                                      color: Colors.white.withOpacity(.18),
                                    ),
                                  ),

                                  // ← стрелка (лево)
                                  Positioned(
                                    left: 8,
                                    top: headerH * 0.55,
                                    child: _NavArrow(
                                      direction: AxisDirection.left,
                                      color: Colors.white,
                                      enabled: canPrev,
                                      onTap: _goPrev,
                                    ),
                                  ),
                                  // → стрелка (право)
                                  Positioned(
                                    right: 8,
                                    top: headerH * 0.55,
                                    child: _NavArrow(
                                      direction: AxisDirection.right,
                                      color: Colors.white,
                                      enabled: canNext,
                                      onTap: _goNext,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Белая панель
                            Positioned(
                              top: contentTop,
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: c, width: 2),
                                ),
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.fromLTRB(20, panelTopPadding, 20, 28),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Типы
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: pokemon.types
                                            .map((t) => Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 6),
                                          child: _TypeChipSolid(label: t, color: typeColor(t)),
                                        ))
                                            .toList(),
                                      ),
                                      const SizedBox(height: 16),

                                      // About
                                      Center(
                                        child: Text(
                                          'About',
                                          style: TextStyle(color: c, fontWeight: FontWeight.w800, fontSize: 20),
                                        ),
                                      ),
                                      const SizedBox(height: 12),

                                      // Вес / Рост / Умения
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _InfoTile(
                                              icon: Icons.monitor_weight,
                                              title: '${pokemon.weight.toStringAsFixed(1)} kg',
                                              caption: 'Weight',
                                            ),
                                          ),
                                          Container(width: 1, height: 44, color: Colors.grey.shade300),
                                          Expanded(
                                            child: _InfoTile(
                                              icon: Icons.straighten,
                                              title: '${pokemon.height.toStringAsFixed(1)} m',
                                              caption: 'Height',
                                            ),
                                          ),
                                          Container(width: 1, height: 44, color: Colors.grey.shade300),
                                          Expanded(
                                            child: _InfoTile(
                                              title: pokemon.abilities.take(2).join('\n'),
                                              caption: 'Moves',
                                              multiline: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),

                                      Text(
                                        pokemon.flavorText,
                                        style: TextStyle(color: Colors.grey.shade700, height: 1.45, fontSize: 14),
                                      ),
                                      const SizedBox(height: 20),

                                      // Base Stats
                                      Center(
                                        child: Text(
                                          'Base Stats',
                                          style: TextStyle(color: c, fontWeight: FontWeight.w800, fontSize: 20),
                                        ),
                                      ),
                                      const SizedBox(height: 10),

                                      _StatRow(label: 'HP',   value: pokemon.stats['hp']  ?? 0, color: c, track: faded),
                                      _StatRow(label: 'ATK',  value: pokemon.stats['atk'] ?? 0, color: c, track: faded),
                                      _StatRow(label: 'DEF',  value: pokemon.stats['def'] ?? 0, color: c, track: faded),
                                      _StatRow(label: 'SATK', value: pokemon.stats['spa'] ?? 0, color: c, track: faded),
                                      _StatRow(label: 'SDEF', value: pokemon.stats['spd'] ?? 0, color: c, track: faded),
                                      _StatRow(label: 'SPD',  value: pokemon.stats['spe'] ?? 0, color: c, track: faded),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Большая картинка
                            Positioned(
                              top: contentTop - imgSize * 0.55,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Image.network(
                                  pokemon.imageUrl,
                                  height: imgSize,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.image_not_supported,
                                    size: 80,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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

// Небольшая кнопка-стрелка (как в макете)
class _NavArrow extends StatelessWidget {
  final AxisDirection direction;
  final Color color;
  final bool enabled;
  final VoidCallback onTap;

  const _NavArrow({
    required this.direction,
    required this.color,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final icon = direction == AxisDirection.left
        ? Icons.chevron_left
        : Icons.chevron_right;

    return IgnorePointer(
      ignoring: !enabled,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.35,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Icon(icon, size: 28, color: color),
            ),
          ),
        ),
      ),
    );
  }
}


//////////////////////////// UI HELPERS ////////////////////////////
class _TypeChipSolid extends StatelessWidget {
  final String label;
  final Color color;
  const _TypeChipSolid({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,                                   // <-- текст больше не пустой
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 13,
        ),
      ),
    );
  }
}

// Если хочешь белый текст на сплошном цвете — вариант выше был пустым.
// Исправляем:
class _TypeChip extends StatelessWidget {
  final String label;
  final Color color;
  const _TypeChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String caption;
  final bool multiline;
  const _InfoTile({
    this.icon,
    required this.title,
    required this.caption,
    this.multiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[        // ← рисуем только если задана
            Icon(icon!, size: 20, color: Colors.grey.shade700),
            const SizedBox(height: 6),
          ],
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          const SizedBox(height: 2),
          Text(
            caption,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final int value; // 0..100
  final Color color;
  final Color track;
  const _StatRow({required this.label, required this.value, required this.color, required this.track});

  @override
  Widget build(BuildContext context) {
    final v = value.clamp(0, 100);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: Text(
              label,
              textAlign: TextAlign.right,
              style: TextStyle(color: color, fontWeight: FontWeight.w800, letterSpacing: .5),
            ),
          ),
          const SizedBox(width: 8),
          Container(width: 1, height: 20, color: Colors.grey.shade300),
          const SizedBox(width: 8),
          SizedBox(
            width: 34,
            child: Text(
              v.toString().padLeft(3, '0'),
              style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  Container(height: 8, color: track),
                  FractionallySizedBox(
                    widthFactor: v / 100.0,
                    child: Container(height: 8, color: color),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//////////////////////////// MODEL & DATA ////////////////////////////
class Pokemon {
  final int id;
  final String name;
  final List<String> types;
  final String imageUrl;
  final String flavorText;
  final double height;
  final double weight;
  final List<String> abilities;
  final Map<String, int> stats;

  const Pokemon({
    required this.id,
    required this.name,
    required this.types,
    required this.imageUrl,
    required this.flavorText,
    required this.height,
    required this.weight,
    required this.abilities,
    required this.stats,
  });
}

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

final _pokemon = <Pokemon>[
  Pokemon(
    id: 1,
    name: 'Bulbasaur',
    types: ['Grass', 'Poison'],
    imageUrl:
    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png',
    flavorText:
    'A strange seed was planted on its back at birth. The plant sprouts and grows with this Pokémon.',
    height: 0.7,
    weight: 6.9,
    abilities: ['Overgrow', 'Chlorophyll'],
    stats: {'hp': 45, 'atk': 49, 'def': 49, 'spa': 65, 'spd': 65, 'spe': 45},
  ),
  Pokemon(
    id: 4,
    name: 'Charmander',
    types: ['Fire'],
    imageUrl:
    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/4.png',
    flavorText:
    'Obviously prefers hot places. When it rains, steam is said to spout from the tip of its tail.',
    height: 0.6,
    weight: 8.5,
    abilities: ['Blaze', 'Solar Power'],
    stats: {'hp': 39, 'atk': 52, 'def': 43, 'spa': 60, 'spd': 50, 'spe': 65},
  ),
  Pokemon(
    id: 7,
    name: 'Squirtle',
    types: ['Water'],
    imageUrl:
    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/7.png',
    flavorText:
    'After birth, its back swells and hardens into a shell. Powerfully sprays foam from its mouth.',
    height: 0.5,
    weight: 9.0,
    abilities: ['Torrent', 'Rain Dish'],
    stats: {'hp': 44, 'atk': 48, 'def': 65, 'spa': 50, 'spd': 64, 'spe': 43},
  ),
  Pokemon(
    id: 12,
    name: 'Butterfree',
    types: ['Bug', 'Flying'],
    imageUrl:
    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/12.png',
    flavorText:
    'In battle, it flaps its wings at high speed to release highly toxic dust into the air.',
    height: 1.1,
    weight: 32.0,
    abilities: ['Compound Eyes', 'Tinted Lens'],
    stats: {'hp': 60, 'atk': 45, 'def': 50, 'spa': 90, 'spd': 80, 'spe': 70},
  ),
  Pokemon(
    id: 25,
    name: 'Pikachu',
    types: ['Electric'],
    imageUrl:
    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png',
    flavorText:
    'Pikachu that can generate powerful electricity have cheek sacs that are extra soft and super stretchy.',
    height: 0.4,
    weight: 6.0,
    abilities: ['Static', 'Lightning Rod'],
    stats: {'hp': 35, 'atk': 55, 'def': 40, 'spa': 50, 'spd': 50, 'spe': 90},
  ),
  Pokemon(
    id: 92,
    name: 'Gastly',
    types: ['Ghost', 'Poison'],
    imageUrl:
    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/92.png',
    flavorText:
    'A being that exists as a thin gas. It can topple an Indian elephant by enveloping the prey in two seconds.',
    height: 1.3,
    weight: 0.1,
    abilities: ['Levitate'],
    stats: {'hp': 30, 'atk': 35, 'def': 30, 'spa': 100, 'spd': 35, 'spe': 80},
  ),
  Pokemon(
    id: 132,
    name: 'Ditto',
    types: ['Normal'],
    imageUrl:
    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/132.png',
    flavorText:
    'Capable of copying an enemy’s genetic code to instantly transform itself into a duplicate of the enemy.',
    height: 0.3,
    weight: 4.0,
    abilities: ['Limber', 'Imposter'],
    stats: {'hp': 48, 'atk': 48, 'def': 48, 'spa': 48, 'spd': 48, 'spe': 48},
  ),
  Pokemon(
    id: 151,
    name: 'Mew',
    types: ['Psychic'],
    imageUrl:
    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/151.png',
    flavorText:
    'So rare that it is still said to be a mirage by many experts. Only a few people have seen it worldwide.',
    height: 0.4,
    weight: 4.0,
    abilities: ['Synchronize'],
    stats: {'hp': 100, 'atk': 100, 'def': 100, 'spa': 100, 'spd': 100, 'spe': 100},
  ),
  Pokemon(
    id: 304,
    name: 'Aron',
    types: ['Steel', 'Rock'],
    imageUrl:
    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/304.png',
    flavorText:
    'It eats iron ore - and sometimes railroad tracks - to build up the steel armor that protects its body.',
    height: 0.4,
    weight: 60.0,
    abilities: ['Sturdy', 'Rock Head'],
    stats: {'hp': 50, 'atk': 70, 'def': 100, 'spa': 40, 'spd': 40, 'spe': 30},
  ),
];