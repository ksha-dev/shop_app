import 'package:flutter/material.dart';
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

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.of(context).pop(GroceryItem(id: DateTime.now().toString(), name: _enteredName, quantity: _enteredQuantity, category: _selectedCategory));
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
                  TextButton(onPressed: () => _formKey.currentState!.reset(), child: const Text('Reset')),
                  const SizedBox(width: 12),
                  ElevatedButton(onPressed: _saveItem, child: const Text('Add Item')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
