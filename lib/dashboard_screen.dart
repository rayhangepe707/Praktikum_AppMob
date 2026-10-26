import 'package:flutter/material.dart';
import 'database_helper.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, dynamic>> _transactions = [];
  int _totalBalance = 0;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() async {
    final data = await DatabaseHelper.instance.getTransactions();
    int balance = 0;
    for (var item in data) {
      if (item['type'] == 'Pemasukan') {
        balance += item['amount'] as int;
      } else {
        balance -= item['amount'] as int;
      }
    }
    setState(() {
      _transactions = data;
      _totalBalance = balance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(16),
            ),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total Saldo', style: TextStyle(color: Colors.white, fontSize: 16)),
                const SizedBox(height: 8),
                Text('Rp $_totalBalance', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(alignment: Alignment.centerLeft, child: Text('Transaksi Terakhir', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          ),
          Expanded(
            child: _transactions.isEmpty 
              ? const Center(child: Text('Belum ada transaksi.'))
              : ListView.builder(
                  itemCount: _transactions.length,
                  itemBuilder: (context, index) {
                    final trx = _transactions[index];
                    final isExpense = trx['type'] == 'Pengeluaran';
                    return ListTile(
                      leading: Icon(isExpense ? Icons.arrow_downward : Icons.arrow_upward, color: isExpense ? Colors.red : Colors.green),
                      title: Text(trx['title']),
                      subtitle: Text(trx['date'].toString().split(' ')[0]),
                      trailing: Text(
                        '${isExpense ? '-' : '+'} Rp ${trx['amount']}',
                        style: TextStyle(color: isExpense ? Colors.red : Colors.green, fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
        onPressed: () async {
          // Tunggu sampai halaman tambah ditutup, lalu refresh data
          final result = await Navigator.pushNamed(context, '/add');
          if (result == true) {
            _refreshData();
          }
        },
      ),
    );
  }
}