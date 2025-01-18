import 'package:flutter/material.dart';
import 'package:uas_mobile_testing/pages/new_books_page.dart';
import 'package:uas_mobile_testing/pages/publishers_page.dart';
import 'pages/books_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  final List<Widget> _pages = [
    PublishersPage(),
    BooksPage(),
    NewBooksPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SiPerpus'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Penerbit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Buku',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.new_releases),
            label: 'Baru Datang',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.grey[850],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
