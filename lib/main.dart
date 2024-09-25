import 'package:flutter/material.dart';

void main() {
  runApp(MyBankApp());
}

class MyBankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplicação Bancária',
      theme: ThemeData(
        primarySwatch: Colors.blue, 
      ),
      home: TransactionListPage(),
    );
  }
}

class TransactionListPage extends StatefulWidget {
  @override
  _TransactionListPageState createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  final List<Map<String, dynamic>> transactions = [];

  void _addTransaction(String type, double amount) {
    setState(() {
      transactions.add({'type': type, 'amount': amount});
    });
  }

  void _deleteTransaction(int index) {
    setState(() {
      transactions.removeAt(index);
    });
  }

  void _navigateToFormPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionFormPage(
          onAddTransaction: _addTransaction,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lista de Transações',
          style: TextStyle(
            fontSize: 25, 
          ),
        ),
        centerTitle: true, 
        backgroundColor: Colors.blue, 
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                title: Text('Tipo: ${transactions[index]['type']}'),
                subtitle: Text('Valor: R\$ ${transactions[index]['amount'].toStringAsFixed(2)}'),
                trailing: IconButton(
                  icon: const Icon(Icons.close, color: Colors.red), 
                  onPressed: () => _deleteTransaction(index),
                  tooltip: 'Excluir Transação',
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToFormPage(context),
        child: const Icon(Icons.add),
        tooltip: 'Adicionar Transação',
      ),
    );
  }
}

class TransactionFormPage extends StatefulWidget {
  final Function(String, double) onAddTransaction;

  TransactionFormPage({required this.onAddTransaction});

  @override
  _TransactionFormPageState createState() => _TransactionFormPageState();
}

class _TransactionFormPageState extends State<TransactionFormPage> {
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  void _submitForm() {
    final String type = _typeController.text;
    final double? amount = double.tryParse(_amountController.text);

    if (type.isNotEmpty && amount != null) {
      widget.onAddTransaction(type, amount);
      Navigator.pop(context);
    } else {
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registro de Transação',
          style: TextStyle(
            fontSize: 25, 
          ),
        ),
        centerTitle: true, 
        backgroundColor: Colors.blue, 
        foregroundColor: Colors.white, 
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              controller: _typeController,
              decoration: InputDecoration(
                labelText: 'Tipo de Transação (Depósito/Retirada)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Valor',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Adicionar Transação'),
            ),
          ],
        ),
      ),
    );
  }
}
