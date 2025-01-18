import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/books.dart';
import '../models/publisher.dart';
import '../models/new_books.dart';

class ApiService {
  static Future<List<Buku>> fetchBooks() async {
    final response = await http.get(Uri.parse('https://e7d6-36-68-8-254.ngrok-free.app/books/'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      final List<dynamic> booksList = responseBody['books'];
      return booksList.map((json) => Buku.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }

  static Future<void> addBook(Buku book) async {
    final response = await http.post(
      Uri.parse('https://e7d6-36-68-8-254.ngrok-free.app/books/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'nama': book.nama,
        'harga': book.harga,
        'stok': book.stok,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add book');
    }
  }

  static Future<void> deleteBook(int bookId) async {
    final response = await http.delete(
      Uri.parse('https://e7d6-36-68-8-254.ngrok-free.app/books/$bookId/'),
    );

    if (response.statusCode == 204) {
      // Successfully deleted
      print('Book deleted successfully');
    } else {
      // Handle errors
      throw Exception('Failed to delete book. Status: ${response.statusCode}');
    }
  }


  static Future<List<Penerbit>> fetchPublishers() async {
    final response = await http.get(Uri.parse('https://e7d6-36-68-8-254.ngrok-free.app/publishers'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      final List<dynamic> publishersList = responseBody['publishers'];
      return publishersList.map((json) => Penerbit.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load publishers');
    }
  }

  static Future<List<BukuMasuk>> fetchNewBooks() async {
    final response = await http.get(Uri.parse('https://e7d6-36-68-8-254.ngrok-free.app/new-books/'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);

      if (responseBody['new-books'] != null) {
        final List<dynamic> newBooksList = responseBody['new-books'];
        return newBooksList.map((json) => BukuMasuk.fromJson(json)).toList();
      } else {
        throw Exception('Key "new-books" not found or contains null data');
      }
    } else {
      throw Exception('Failed to load new books');
    }
  }
}