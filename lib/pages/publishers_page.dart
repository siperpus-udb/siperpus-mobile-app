import 'package:flutter/material.dart';
import '../models/publisher.dart';
import '../services/api_services.dart';

class PublishersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Penerbit>>(
      future: ApiService.fetchPublishers(),
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
    );
  }
}
