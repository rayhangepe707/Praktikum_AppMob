import 'package:flutter/material.dart';
import 'database_helper.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  List<Map<String, dynamic>> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadRiwayat();
  }

  void _loadRiwayat() async {
    final data = await DatabaseHelper.instance.getTransactions();
    setState(() {
      _transactions = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Transaksi Semua')),
      body: _transactions.isEmpty
          ? const Center(child: Text('Belum ada riwayat transaksi.'))
          : ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final trx = _transactions[index];
                final isExpense = trx['type'] == 'Pengeluaran';
                return ListTile(
                  leading: Icon(
                    isExpense ? Icons.arrow_downward : Icons.arrow_upward, 
                    color: isExpense ? Colors.red : Colors.green
                  ),
                  title: Text(trx['title']),
                  subtitle: Text(trx['date'].toString().split(' ')[0]),
                  trailing: Text(
                    '${isExpense ? '-' : '+'} Rp ${trx['amount']}',
                    style: TextStyle(
                      color: isExpense ? Colors.red : Colors.green, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                );
              },
            ),
    );
  }
}