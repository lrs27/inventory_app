class Item {
  final String id;
  final String name;
  final double price;

  Item({required this.id, required this.name, required this.price});

  // Convert Firestore map → Item
  factory Item.fromMap(String id, Map<String, dynamic> data) {
    return Item(
      id: id,
      name: data['name'] ?? '',
      price: (data['price'] as num).toDouble(),
    );
  }

  // Convert Item → Firestore map
  Map<String, dynamic> toMap() {
    return {'name': name, 'price': price};
  }
}
