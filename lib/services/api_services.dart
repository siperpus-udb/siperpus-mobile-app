import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/books.dart';
import '../models/publisher.dart';
import '../models/new_books.dart';

class ApiService {
  // Write you base URL here
  static const String baseUrl = 'https://8c58-36-68-8-254.ngrok-free.app';

  static Future<List<Buku>> fetchBooks() async {
    final response = await http.get(Uri.parse('$baseUrl/books/'));
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
      Uri.parse('$baseUrl/books/'),
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
      Uri.parse('$baseUrl/books/$bookId/'),
    );

    if (response.statusCode == 204) {
      print('Book deleted successfully');
    } else {
      throw Exception('Failed to delete book. Status: ${response.statusCode}');
    }
  }

  static Future<List<Penerbit>> fetchPublishers() async {
    final response = await http.get(Uri.parse('$baseUrl/publishers'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      final List<dynamic> publishersList = responseBody['publishers'];
      return publishersList.map((json) => Penerbit.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load publishers');
    }
  }

  static Future<void> addPublisher(Penerbit publisher) async {
    final response = await http.post(
      Uri.parse('$baseUrl/publishers/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'nama': publisher.nama,
        'alamat': publisher.alamat,
        'nohp': publisher.nohp,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add publisher');
    }
  }

  static Future<void> deletePublisher(int publisherId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/publishers/$publisherId/'),
    );

    if (response.statusCode == 204) {
      print('Book deleted successfully');
    } else {
      throw Exception('Failed to delete publisher. Status: ${response.statusCode}');
    }
  }

  static Future<List<BukuMasuk>> fetchNewBooks() async {
    final response = await http.get(Uri.parse('$baseUrl/new-books/'));

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

  static Future<void> addNewBook(BukuMasuk newBook) async {
    final String fullIdBuku = '$baseUrl/books/${newBook.idbuku}/';
    final String fullIdPenerbit = '$baseUrl/publishers/${newBook.idpenerbit}/';

    final response = await http.post(
      Uri.parse('https://8c58-36-68-8-254.ngrok-free.app/new-books/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'idbuku': fullIdBuku,
        'idpenerbit': fullIdPenerbit,
        'jumlah': newBook.jumlah,
      }),
    );

    if (response.statusCode != 201) {
      print('Failed to add Buku Baru: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to add Buku Baru');
    }
  }
}