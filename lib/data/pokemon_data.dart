import '../models/pokemon.dart';

class PokemonData {
  static final List<Pokemon> pokemon = <Pokemon>[
    const Pokemon(
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
    const Pokemon(
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
    const Pokemon(
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
    const Pokemon(
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
    const Pokemon(
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
    const Pokemon(
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
    const Pokemon(
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
    const Pokemon(
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
    const Pokemon(
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
}
