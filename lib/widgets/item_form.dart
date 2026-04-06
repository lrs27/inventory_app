import 'package:flutter/material.dart';

class ItemForm extends StatefulWidget {
  final String? docId;
  final String? initialName;
  final String? initialPrice;
  final String? initialQuantity;

  final Function(String name, String price, String quantity) onSubmit;

  const ItemForm({
    super.key,
    this.docId,
    this.initialName,
    this.initialPrice,
    this.initialQuantity,
    required this.onSubmit,
  });

  @override
  State<ItemForm> createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameCtrl;
  late TextEditingController priceCtrl;
  late TextEditingController quantityCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.initialName ?? "");
    priceCtrl = TextEditingController(text: widget.initialPrice ?? "");
    quantityCtrl = TextEditingController(text: widget.initialQuantity ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.docId == null ? "Add Item" : "Edit Item"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // NAME
            TextFormField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Item Name"),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Name cannot be empty";
                }
                return null;
              },
            ),

            // PRICE
            TextFormField(
              controller: priceCtrl,
              decoration: const InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Price is required";
                }
                if (double.tryParse(value) == null) {
                  return "Enter a valid number";
                }
                return null;
              },
            ),

            // QUANTITY
            TextFormField(
              controller: quantityCtrl,
              decoration: const InputDecoration(labelText: "Quantity"),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Quantity is required";
                }
                if (int.tryParse(value) == null) {
                  return "Enter a valid whole number";
                }
                return null;
              },
            ),
          ],
        ),
      ),

      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: const Text("Save"),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSubmit(
                nameCtrl.text.trim(),
                priceCtrl.text.trim(),
                quantityCtrl.text.trim(),
              );
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
