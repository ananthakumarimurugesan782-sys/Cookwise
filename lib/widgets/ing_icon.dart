import 'package:flutter/material.dart';

const _icons = [
  ['tomato', '🍅'], ['onion', '🧅'], ['shallot', '🧅'], ['garlic', '🧄'], ['ginger', '🫚'], ['potato', '🥔'], ['carrot', '🥕'],
  ['chil', '🌶️'], ['pepper', '🫑'], ['capsicum', '🫑'], ['eggplant', '🍆'], ['brinjal', '🍆'], ['corn', '🌽'], ['peas', '🫛'], ['bean', '🫘'],
  ['lentil', '🫘'], ['dal', '🫘'], ['spinach', '🥬'], ['cabbage', '🥬'], ['lettuce', '🥬'], ['mint', '🌿'], ['cilantro', '🌿'], ['coriander', '🌿'],
  ['parsley', '🌿'], ['basil', '🌿'], ['curry leaves', '🌿'], ['cucumber', '🥒'], ['broccoli', '🥦'], ['mushroom', '🍄'], ['avocado', '🥑'],
  ['lemon', '🍋'], ['lime', '🍋'], ['orange', '🍊'], ['apple', '🍎'], ['banana', '🍌'], ['mango', '🥭'], ['coconut', '🥥'], ['pineapple', '🍍'],
  ['chicken', '🍗'], ['lamb', '🥩'], ['mutton', '🥩'], ['beef', '🥩'], ['pork', '🥩'], ['bacon', '🥓'], ['sausage', '🌭'], ['ham', '🍖'],
  ['shrimp', '🦐'], ['prawn', '🦐'], ['crab', '🦀'], ['squid', '🦑'], ['fish', '🐟'], ['salmon', '🐟'], ['tuna', '🐟'], ['egg', '🥚'],
  ['milk', '🥛'], ['cream', '🥛'], ['curd', '🥛'], ['yogurt', '🥛'], ['yoghurt', '🥛'], ['cheese', '🧀'], ['paneer', '🧀'], ['butter', '🧈'], ['ghee', '🧈'],
  ['rice', '🍚'], ['pasta', '🍝'], ['spaghetti', '🍝'], ['noodle', '🍜'], ['flour', '🌾'], ['bread', '🍞'], ['tortilla', '🫓'], ['naan', '🫓'],
  ['salt', '🧂'], ['sugar', '🍬'], ['honey', '🍯'], ['oil', '🫒'], ['olive', '🫒'], ['nut', '🥜'], ['almond', '🥜'], ['cashew', '🥜'], ['peanut', '🥜'],
  ['water', '💧'], ['wine', '🍷'], ['vinegar', '🍶'], ['sauce', '🥫'], ['paste', '🥫'], ['stock', '🍲'], ['broth', '🍲'],
  ['cumin', '🫙'], ['turmeric', '🫙'], ['masala', '🫙'], ['powder', '🫙'], ['spice', '🫙'], ['seed', '🫙'], ['cinnamon', '🫙'], ['cardamom', '🫙'],
];

String ingredientEmoji(String name) {
  final n = name.toLowerCase();
  // sauces / pastes / stocks first, so "tomato sauce" is a can, not a tomato
  for (final k in const ['sauce', 'paste', 'stock', 'broth', 'powder', 'oil']) {
    if (n.contains(k)) return _icons.firstWhere((e) => e[0] == k)[1];
  }
  for (final e in _icons) {
    if (n.contains(e[0])) return e[1];
  }
  return '🍽️';
}

class IngIcon extends StatelessWidget {
  final String name;
  const IngIcon(this.name, {super.key});
  @override
  Widget build(BuildContext context) => Container(
        width: 30, height: 30, alignment: Alignment.center,
        decoration: BoxDecoration(color: const Color(0xFFFFF6D0), shape: BoxShape.circle),
        child: Text(ingredientEmoji(name), style: const TextStyle(fontSize: 17, fontFamilyFallback: ['Segoe UI Emoji', 'Apple Color Emoji', 'Noto Color Emoji'])),
      );
}
