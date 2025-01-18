import 'package:flutter/material.dart';
import '../models/books.dart';
import '../services/api_services.dart';
import 'package:intl/intl.dart';

class BooksPage extends StatefulWidget {
  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  late Future<List<Buku>> futureBooks;

  @override
  void initState() {
    super.initState();
    futureBooks = ApiService.fetchBooks();
  }

  Future<void> _refreshBooks() async {
    setState(() {
      futureBooks = ApiService.fetchBooks();
    });
  }

  String _formatCurrency(String value) {
    final number = int.tryParse(value.replaceAll(',', '')) ?? 0;
    return NumberFormat('#,###').format(number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Buku'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Add Book',
            onPressed: () {
              _showAddBookDialog();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Buku>>(
        future: futureBooks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final books = snapshot.data!;
            return RefreshIndicator(
              onRefresh: _refreshBooks,
              child: ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  return Card(
                    margin: EdgeInsets.all(10.0),
                    elevation: 4,
                    child: ListTile(
                      leading: Icon(Icons.book, color: Colors.blue),
                      title: Text(
                        book.nama,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        'Harga: Rp. ${book.harga}\nStok: ${book.stok}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Hapus Buku',
                        onPressed: () {
                          _showDeleteBookDialog(book.idbuku);
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  void _showAddBookDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController stockController = TextEditingController();

    priceController.addListener(() {
      String formattedValue = _formatCurrency(priceController.text);
      if (formattedValue != priceController.text) {
        priceController.value = TextEditingValue(
          text: formattedValue,
          selection: TextSelection.fromPosition(
            TextPosition(offset: formattedValue.length),
          ),
        );
      }
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Buku Baru'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Nama Buku'),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Harga'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: stockController,
                  decoration: InputDecoration(labelText: 'Stok Buku'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final newBook = Buku(
                  idbuku: 0,
                  nama: nameController.text,
                  harga: int.parse(priceController.text),
                  stok: int.parse(stockController.text),
                );

                await ApiService.addBook(newBook);
                Navigator.of(context).pop();
                _refreshBooks();
              },
              child: Text('Tambah'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteBookDialog(int bookId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Hapus Buku'),
          content: Text('Apakah kamu yakin untuk menghapus buku ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await ApiService.deleteBook(bookId);
                  Navigator.of(context).pop();
                  _refreshBooks();
                } catch (error) {
                  Navigator.of(context).pop();
                  _showErrorDialog(error.toString());
                }
              },
              child: Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
