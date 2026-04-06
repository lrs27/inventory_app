import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/item_form.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final itemsRef = FirebaseFirestore.instance.collection('items');

    return Scaffold(
      appBar: AppBar(title: const Text("Inventory")),

      body: StreamBuilder<QuerySnapshot>(
        stream: itemsRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading items"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No items yet"));
          }

          final docs = snapshot.data!.docs;
          final itemCount = docs.length; // <-- COUNT ITEMS

          return Column(
            children: [
              // ITEM COUNT DISPLAY
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Total Items: $itemCount",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // LIST OF ITEMS
              Expanded(
                child: ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final name = data['name'] ?? 'Unnamed';
                    final price = data['price'] ?? 0;

                    return ListTile(
                      title: Text(name),
                      subtitle: Text("Price: \$${price.toString()}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => itemsRef.doc(docs[index].id).delete(),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => ItemForm(
                            docId: docs[index].id,
                            initialName: name,
                            initialPrice: price.toString(),
                            onSubmit: (updatedName, updatedPrice) {
                              itemsRef.doc(docs[index].id).update({
                                'name': updatedName,
                                'price': double.parse(updatedPrice),
                              });
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => ItemForm(
              onSubmit: (name, price) {
                itemsRef.add({'name': name, 'price': double.parse(price)});
              },
            ),
          );
        },
      ),
    );
  }
}
