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
                    final quantity = data['quantity'] ?? 0;

                    return ListTile(
                      title: Text(name),
                      subtitle: Text(
                        "Price: \$${price.toString()} | Quantity: $quantity",
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          final quantity = data['quantity'] ?? 0;

                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: const Text("Delete Item"),
                                content: Text(
                                  quantity > 1
                                      ? "This item has a quantity of $quantity.\nWhat would you like to do?"
                                      : "Quantity is 1.\nDo you want to delete this item?",
                                ),
                                actions: [
                                  // OPTION 1: Decrease quantity
                                  if (quantity > 1)
                                    TextButton(
                                      child: const Text("Decrease Quantity"),
                                      onPressed: () {
                                        itemsRef.doc(docs[index].id).update({
                                          'quantity': quantity - 1,
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),

                                  // OPTION 2: Delete entire item
                                  TextButton(
                                    child: const Text("Delete Item"),
                                    onPressed: () {
                                      itemsRef.doc(docs[index].id).delete();
                                      Navigator.pop(context);
                                    },
                                  ),

                                  // CANCEL
                                  TextButton(
                                    child: const Text("Cancel"),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),

                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => ItemForm(
                            docId: docs[index].id,
                            initialName: name,
                            initialPrice: price.toString(),
                            initialQuantity: quantity.toString(),
                            onSubmit:
                                (updatedName, updatedPrice, updatedQuantity) {
                                  itemsRef.doc(docs[index].id).update({
                                    'name': updatedName,
                                    'price': double.parse(updatedPrice),
                                    'quantity': int.parse(updatedQuantity),
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
              onSubmit: (name, price, quantity) {
                itemsRef.add({
                  'name': name,
                  'price': double.parse(price),
                  'quantity': int.parse(quantity),
                });
              },
            ),
          );
        },
      ),
    );
  }
}
