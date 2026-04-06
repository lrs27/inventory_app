class Item {
  final String id;
  final String name;
  final double price;
  final int quantity;

  Item({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  // Convert Firestore map → Item
  factory Item.fromMap(String id, Map<String, dynamic> data) {
    return Item(
      id: id,
      name: data['name'] ?? '',
      price: (data['price'] as num).toDouble(),
      quantity: (data['quantity'] as num).toInt(),
    );
  }

  // Convert Item → Firestore map
  Map<String, dynamic> toMap() {
    return {'name': name, 'price': price, 'quantity': quantity};
  }
}
