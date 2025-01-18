import 'package:flutter/material.dart';
import '../models/books.dart';
import '../services/api_services.dart';

class BooksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Buku>>(
      future: ApiService.fetchBooks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final books = snapshot.data!;
          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.nama,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Harga: Rp. ${book.harga}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.store,
                            color: book.stok > 0 ? Colors.green : Colors.red,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Stok: ${book.stok}',
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
            },
          );
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }
}
