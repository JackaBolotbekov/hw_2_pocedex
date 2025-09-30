import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';

import '../models/pokemon.dart';
import '../utils/type_color.dart';

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
    final Color color = typeColor(pokemon.types.isNotEmpty ? pokemon.types.first : '');
    final Color faded = color.withOpacity(.14);

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
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: LayoutBuilder(
                    builder: (context, inner) {
                      final double width = inner.maxWidth;
                      final double headerHeight = (width * 0.62).clamp(260.0, 360.0);
                      final double imageSize = width * 0.50;
                      const double overlap = 64.0;
                      final double contentTop = headerHeight - overlap;
                      final double imageInsidePanel = imageSize * 0.45;
                      final double panelTopPadding = 20 + imageInsidePanel + 8;

                      return SizedBox(
                        height: contentH - 32,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: headerHeight,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 12,
                                    top: 8,
                                    child: IconButton(
                                      onPressed: () => Navigator.pop(context),
                                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                                    ),
                                  ),
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
                                  Positioned(
                                    right: 12,
                                    top: headerHeight * 0.22,
                                    child: Icon(
                                      Icons.catching_pokemon,
                                      size: width * 0.42,
                                      color: Colors.white.withOpacity(.18),
                                    ),
                                  ),
                                  Positioned(
                                    left: 8,
                                    top: headerHeight * 0.55,
                                    child: _NavArrow(
                                      direction: AxisDirection.left,
                                      color: Colors.white,
                                      enabled: canPrev,
                                      onTap: _goPrev,
                                    ),
                                  ),
                                  Positioned(
                                    right: 8,
                                    top: headerHeight * 0.55,
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
                            Positioned(
                              top: contentTop,
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: color, width: 2),
                                ),
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.fromLTRB(20, panelTopPadding, 20, 28),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: pokemon.types
                                            .map(
                                              (type) => Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                                child: _TypeChipSolid(label: type, color: typeColor(type)),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                      const SizedBox(height: 16),
                                      Center(
                                        child: Text(
                                          'About',
                                          style: TextStyle(
                                            color: color,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
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
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                          height: 1.45,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Center(
                                        child: Text(
                                          'Base Stats',
                                          style: TextStyle(
                                            color: color,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      _StatRow(label: 'HP', value: pokemon.stats['hp'] ?? 0, color: color, track: faded),
                                      _StatRow(label: 'ATK', value: pokemon.stats['atk'] ?? 0, color: color, track: faded),
                                      _StatRow(label: 'DEF', value: pokemon.stats['def'] ?? 0, color: color, track: faded),
                                      _StatRow(label: 'SATK', value: pokemon.stats['spa'] ?? 0, color: color, track: faded),
                                      _StatRow(label: 'SDEF', value: pokemon.stats['spd'] ?? 0, color: color, track: faded),
                                      _StatRow(label: 'SPD', value: pokemon.stats['spe'] ?? 0, color: color, track: faded),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: contentTop - imageSize * 0.55,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Image.network(
                                  pokemon.imageUrl,
                                  height: imageSize,
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
    final IconData icon = direction == AxisDirection.left ? Icons.chevron_left : Icons.chevron_right;

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
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 13,
        ),
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
          if (icon != null) ...[
            Icon(icon!, size: 20, color: Colors.grey.shade700),
            const SizedBox(height: 6),
          ],
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: multiline ? 2 : 1,
            overflow: multiline ? TextOverflow.visible : TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          const SizedBox(height: 2),
          Text(
            caption,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final Color track;

  const _StatRow({
    required this.label,
    required this.value,
    required this.color,
    required this.track,
  });

  @override
  Widget build(BuildContext context) {
    final int clampedValue = value.clamp(0, 100);
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
              clampedValue.toString().padLeft(3, '0'),
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
                    widthFactor: clampedValue / 100.0,
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
