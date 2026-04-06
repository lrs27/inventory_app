import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item.dart';

class ItemService {
  final itemsRef = FirebaseFirestore.instance.collection('items');

  // CREATE
  Future<void> addItem(Item item) async {
    await itemsRef.add(item.toMap());
  }

  // READ (typed stream)
  Stream<List<Item>> streamItems() {
    return itemsRef.snapshots().map(
      (snap) => snap.docs
          .map((d) => Item.fromMap(d.id, d.data() as Map<String, dynamic>))
          .toList(),
    );
  }

  // UPDATE
  Future<void> updateItem(Item item) async {
    await itemsRef.doc(item.id).update(item.toMap());
  }

  // DELETE
  Future<void> deleteItem(String id) async {
    await itemsRef.doc(id).delete();
  }
}
