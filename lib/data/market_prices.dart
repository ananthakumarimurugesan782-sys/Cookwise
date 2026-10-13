/// Chennai retail market reference prices used by the Shopping List.
/// Rates are a dated snapshot (08 Oct 2026), not a live price feed.
/// Vegetable values are ₹/kg; chicken/meat/fish values are ₹/kg.
const Map<String, double> chennaiMarketPricePerKg = {
  'onion': 80,
  'small onion': 120,
  'shallot': 70,
  'tomato': 30,
  'potato': 60,
  'carrot': 130,
  'beetroot': 80,
  'brinjal': 40,
  'eggplant': 40,
  'cabbage': 20,
  'cauliflower': 25,
  'capsicum': 60,
  'bell pepper': 60,
  'green chilli': 73,
  'chili': 73,
  'beans': 90,
  'french beans': 60,
  'peas': 80,
  'green peas': 80,
  'cucumber': 30,
  'drumstick': 260,
  'ladies finger': 60,
  'okra': 60,
  'pumpkin': 50,
  'radish': 50,
  'ridge gourd': 50,
  'snake gourd': 30,
  'bottle gourd': 35,
  'bitter gourd': 110,
  'mushroom': 300,
  'garlic': 700,
  'ginger': 100,
  'spinach': 30,
  'coriander': 20,
  'cilantro': 20,
  'curry leaves': 10,
  'mint': 70,
  'lemon': 90,
  'lime': 90,
  'corn': 25,
  'sweet potato': 120,
  'yam': 90,
  'tapioca': 60,
  'coconut': 30,
  'raw banana': 130,
  'plantain': 130,
  'chicken': 160,
  'chicken breast': 200,
  'chicken thigh': 160,
  'mutton': 845,
  'lamb': 845,
  'beef': 190,
  'pork': 415,
  'duck': 280,
  'fish': 200,
  'salmon': 715,
  'tuna': 380,
  'shrimp': 380,
  'prawn': 380,
  'crab': 475,
};

String? marketPriceFor(String ingredient) {
  final n = ingredient.toLowerCase().trim();
  for (final e in chennaiMarketPricePerKg.entries) {
    if (n == e.key || n.contains(e.key) || e.key.contains(n)) return '₹${e.value.toStringAsFixed(0)}/kg';
  }
  return null;
}

String marketIconGroup(String ingredient) {
  final n = ingredient.toLowerCase();
  const meat = ['chicken', 'mutton', 'lamb', 'beef', 'pork', 'duck', 'fish', 'salmon', 'tuna', 'shrimp', 'prawn', 'crab'];
  const produce = ['onion', 'tomato', 'potato', 'carrot', 'beet', 'brinjal', 'eggplant', 'cabbage', 'cauliflower', 'capsicum', 'pepper', 'beans', 'peas', 'cucumber', 'drumstick', 'okra', 'pumpkin', 'radish', 'gourd', 'mushroom', 'garlic', 'ginger', 'spinach', 'coriander', 'cilantro', 'curry', 'mint', 'lemon', 'lime', 'corn', 'coconut', 'banana', 'plantain', 'yam', 'tapioca'];
  if (meat.any(n.contains)) return 'meat';
  if (produce.any(n.contains)) return 'produce';
  return 'other';
}
