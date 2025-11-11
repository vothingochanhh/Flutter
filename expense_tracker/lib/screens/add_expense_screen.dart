import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../model/expense.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  double _amount = 0.0;
  String _category = 'Food'; // Giá trị mặc định

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newExpense = Expense(
        name: _name,
        amount: _amount,
        category: _category,
        date: DateTime.now(),
      );

      // Ghi vào Hộp (Box)
      Hive.box<Expense>('expenses').add(newExpense);

      // Tự động quay lại (ValueListenableBuilder ở màn hình chính sẽ tự cập nhật)
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name (e.g., Coffee)',
                ),
                validator: (val) => val!.isEmpty ? 'Enter a name' : null,
                onSaved: (val) => _name = val!,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Amount (e.g., 30000)',
                ),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? 'Enter an amount' : null,
                onSaved: (val) => _amount = double.tryParse(val!) ?? 0.0,
              ),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: ['Food', 'Transport', 'Entertainment', 'Other']
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _category = val!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
