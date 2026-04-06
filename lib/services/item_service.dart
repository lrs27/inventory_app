import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item.dart';

class ItemService {
  final CollectionReference _items = FirebaseFirestore.instance.collection(
    'items',
  );

  // Read (typed stream)
  Stream<List<Item>> getItems() {
    return _items.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Item.fromSnapshot(doc)).toList();
    });
  }

  // Create
  Future<void> addItem(Item item) async {
    await _items.add(item.toMap());
  }

  // Update
  Future<void> updateItem(Item item) async {
    await _items.doc(item.id).update(item.toMap());
  }

  // Delete
  Future<void> deleteItem(String id) async {
    await _items.doc(id).delete();
  }
}
