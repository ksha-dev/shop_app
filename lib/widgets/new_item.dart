import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '/models/category.dart';
import '/models/grocery_item.dart';
import '../data/categories.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  String _enteredName = '';
  int _enteredQuantity = 1;
  Category _selectedCategory = categories[Categories.vegetables]!;
  bool _isSending = false;

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isSending = true);
      final response = await http.post(
        Uri.https('flutter---shopapp-b0f9a-default-rtdb.firebaseio.com', 'shopping_list.json'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': _enteredName, 'quantity': _enteredQuantity, 'category': _selectedCategory.title}),
      );

      final responseData = json.decode(response.body);

      if (context.mounted) Navigator.pop(context, GroceryItem(id: responseData["name"], name: _enteredName, quantity: _enteredQuantity, category: _selectedCategory));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a new item')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // instead of textfield
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(label: Text('Name')),
                onSaved: (newValue) => _enteredName = newValue!,
                validator: (value) => (value == null || value.isEmpty || value.trim().length == 1 || value.trim().length > 50) ? 'Must between 2 and 50 characters long' : null,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(label: Text('Quantity')),
                      initialValue: _enteredQuantity.toString(),
                      onSaved: (newValue) => _enteredQuantity = int.parse(newValue!),
                      validator: (value) => (value == null || value.isEmpty || int.tryParse(value) == null || int.tryParse(value)! <= 0) ? 'Must be a valid positive number' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(width: 16, height: 16, color: category.value.color),
                                const SizedBox(width: 6),
                                Text(category.value.title),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) => _selectedCategory = value!,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: _isSending ? null : () => _formKey.currentState!.reset(), child: const Text('Reset')),
                  const SizedBox(width: 12),
                  ElevatedButton(
                      onPressed: _isSending ? null : _saveItem,
                      child: _isSending
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(),
                            )
                          : const Text('Add Item')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
