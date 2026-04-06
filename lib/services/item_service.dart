import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item.dart';

class ItemService {
  final CollectionReference _items = FirebaseFirestore.instance.collection(
    'items',
  );

  //CREATE
  Future<void> addItem(Item item) async {
    await _items.add(item.toMap());
  }

  //READ (typed real-time stream)
  Stream<List<Item>> getItems() {
    return _items.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Item.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  //UPDATE
  Future<void> updateItem(Item item) async {
    await _items.doc(item.id).update(item.toMap());
  }

  //DELETE
  Future<void> deleteItem(String id) async {
    await _items.doc(id).delete();
  }
}
