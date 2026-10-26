import 'package:flutter/material.dart';
import 'database_helper.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _type = 'Pengeluaran'; // Default pilihan

  void _saveTransaction() async {
    if (_titleController.text.isNotEmpty && _amountController.text.isNotEmpty) {
      Map<String, dynamic> transaction = {
        'title': _titleController.text,
        'amount': int.parse(_amountController.text),
        'type': _type,
        'date': DateTime.now().toString(),
      };
      
      await DatabaseHelper.instance.insertTransaction(transaction);
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Transaksi Berhasil Disimpan!')));
      Navigator.pop(context, true); // Kembali ke halaman sebelumnya bawa sinyal 'true'
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Transaksi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Nama Transaksi (Misal: Makan Siang)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Jumlah Uang (Misal: 50000)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _type,
              items: ['Pengeluaran', 'Pemasukan'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _type = newValue!;
                });
              },
              decoration: const InputDecoration(labelText: 'Jenis Transaksi', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveTransaction,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: const Text('Simpan Transaksi'),
            )
          ],
        ),
      ),
    );
  }
}