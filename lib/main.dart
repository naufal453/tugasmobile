import 'package:flutter/material.dart';
import 'media_page.dart'; // Impor file media_page.dart
import 'data_storage_page.dart'; // Impor file data_storage_page.dart
import 'notification_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tombol Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  void _navigateToMediaPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MediaPage()),
    );
  }

  void _navigateToDataStoragePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DataStoragePage()),
    );
  }

  void _navigateToNotificationPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotificationPage()),
    );
  }

  void _showMessage(String message) {
    print(message); // Ganti dengan dialog atau snackbar jika perlu
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Naufal 1201220446'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _navigateToMediaPage(context),
              child: Text('Tombol 1 - Buka Media'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateToDataStoragePage(context),
              child: Text('Tombol 2 - Data Storage'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateToNotificationPage(context),
              child: Text('Tombol 3 - Notification'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showMessage('Tombol 4 ditekan'),
              child: Text('Tombol 4'),
            ),
          ],
        ),
      ),
    );
  }
}
