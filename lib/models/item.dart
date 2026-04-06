class Item {
  final String? id; // Firestore doc ID (nullable when creating)
  final String name;
  final double price;
  final int quantity;

  Item({
    this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  // Convert Firestore document → Item object
  factory Item.fromMap(Map<String, dynamic> data, String documentId) {
    return Item(
      id: documentId,
      name: data['name'] ?? '',
      price: (data['price'] as num).toDouble(),
      quantity: data['quantity'] ?? 0,
    );
  }

  // Convert Item object → Firestore map
  Map<String, dynamic> toMap() {
    return {'name': name, 'price': price, 'quantity': quantity};
  }
}
