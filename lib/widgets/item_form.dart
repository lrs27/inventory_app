import 'package:flutter/material.dart';

class ItemForm extends StatefulWidget {
  final String? docId;
  final String? initialName;
  final String? initialPrice;
  final Function(String name, String price) onSubmit;

  const ItemForm({
    super.key,
    this.docId,
    this.initialName,
    this.initialPrice,
    required this.onSubmit,
  });

  @override
  State<ItemForm> createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameCtrl;
  late TextEditingController priceCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.initialName ?? "");
    priceCtrl = TextEditingController(text: widget.initialPrice ?? "");
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
            // NAME FIELD
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

            // PRICE FIELD
            TextFormField(
              controller: priceCtrl,
              decoration: const InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Price is required";
                }
                final parsed = double.tryParse(value);
                if (parsed == null || parsed <= 0) {
                  return "Enter a valid positive number";
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
              widget.onSubmit(nameCtrl.text.trim(), priceCtrl.text.trim());
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
