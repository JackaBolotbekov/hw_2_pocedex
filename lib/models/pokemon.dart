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
