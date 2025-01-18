import 'package:flutter/material.dart';
import '../models/publisher.dart';
import '../services/api_services.dart';

class PublishersPage extends StatefulWidget {
  @override
  _PublishersPageState createState() => _PublishersPageState();
}

class _PublishersPageState extends State<PublishersPage> {
  Future<List<Penerbit>>? _publishersFuture;

  @override
  void initState() {
    super.initState();
    _fetchPublishers();
  }

  void _fetchPublishers() {
    setState(() {
      _publishersFuture = ApiService.fetchPublishers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Penerbit'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddPublisherDialog(context);
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Penerbit>>(
        future: _publishersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final publishers = snapshot.data!;
            return ListView.builder(
              itemCount: publishers.length,
              itemBuilder: (context, index) {
                final publisher = publishers[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.business, color: Colors.blue, size: 24),
                            SizedBox(width: 8),
                            Text(
                              publisher.nama,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _showDeletePublisherDialog(context, publisher.idpenerbit);
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.green, size: 20),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${publisher.alamat}',
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
                            Icon(Icons.phone, color: Colors.green, size: 20),
                            SizedBox(width: 8),
                            Text(
                              '${publisher.nohp}',
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
      ),
    );
  }

  void _showDeletePublisherDialog(BuildContext context, int publisherId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Hapus Penerbit'),
          content: Text('Apakah kamu yakin menghapus data ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                await ApiService.deletePublisher(publisherId);
                Navigator.of(context).pop();
                _fetchPublishers();
              },
              child: Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  void _showAddPublisherDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController addressController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Publisher'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nama Penerbit'),
              ),
              TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Alamat'),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'No Telepon'),
                keyboardType: TextInputType.phone,
              ),
            ],
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
                final newPublisher = Penerbit(
                  idpenerbit: 0,
                  nama: nameController.text,
                  alamat: addressController.text,
                  nohp: phoneController.text,
                );

                await ApiService.addPublisher(newPublisher);
                Navigator.of(context).pop();
                _fetchPublishers();
              },
              child: Text('Tambah'),
            ),
          ],
        );
      },
    );
  }
}
