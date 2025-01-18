import 'package:flutter/material.dart';
import '../models/new_books.dart';
import '../services/api_services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NewBooksPage extends StatefulWidget {
  @override
  _NewBooksPageState createState() => _NewBooksPageState();
}

class _NewBooksPageState extends State<NewBooksPage> {
  late Future<List<BukuMasuk>> futureNewBooks;

  @override
  void initState() {
    super.initState();
    futureNewBooks = ApiService.fetchNewBooks();
  }

  Future<void> _refreshNewBooks() async {
    setState(() {
      futureNewBooks = ApiService.fetchNewBooks();
    });
  }

  Future<Map<String, dynamic>> fetchDetails(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load details from $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buku Masuk'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddBookDialog(context);
            },
          ),
        ],
      ),
      body: FutureBuilder<List<BukuMasuk>>(
        future: futureNewBooks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final newBooks = snapshot.data!;
            return ListView.builder(
              itemCount: newBooks.length,
              itemBuilder: (context, index) {
                final entry = newBooks[index];
                return FutureBuilder<Map<String, dynamic>>(
                  future: Future.wait([
                    fetchDetails(entry.idbuku),
                    fetchDetails(entry.idpenerbit),
                  ]).then((results) {
                    return {
                      'buku': results[0],
                      'penerbit': results[1],
                    };
                  }),
                  builder: (context, detailsSnapshot) {
                    if (detailsSnapshot.connectionState == ConnectionState.waiting) {
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(width: 10),
                              Text(
                                'Loading details...',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (detailsSnapshot.hasError) {
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Icon(Icons.error, color: Colors.red, size: 24),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Error loading details: ${detailsSnapshot.error}',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (detailsSnapshot.hasData) {
                      final details = detailsSnapshot.data!;
                      final buku = details['buku'];
                      final penerbit = details['penerbit'];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.book, color: Colors.blue, size: 24),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      buku['nama'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.business, color: Colors.green, size: 20),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Penerbit: ${penerbit['nama']}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.format_list_numbered, color: Colors.orange, size: 20),
                                  SizedBox(width: 10),
                                  Text(
                                    'Jumlah: ${entry.jumlah}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'No details available',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  void _showAddBookDialog(BuildContext context) {
    final TextEditingController idBukuController = TextEditingController();
    final TextEditingController idPenerbitController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Buku Masuk'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: idBukuController,
                  decoration: InputDecoration(labelText: 'ID Buku'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: idPenerbitController,
                  decoration: InputDecoration(labelText: 'ID Penerbit'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: quantityController,
                  decoration: InputDecoration(labelText: 'Jumlah'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                final newBook = BukuMasuk(
                  idtrans: 0,
                  idbuku: idBukuController.text,
                  idpenerbit: idPenerbitController.text,
                  jumlah: int.tryParse(quantityController.text) ?? 0,
                );

                await ApiService.addNewBook(newBook);
                Navigator.of(context).pop();
                await _refreshNewBooks();
              },
              child: Text('Tambah'),
            ),
          ],
        );
      },
    );
  }
}
