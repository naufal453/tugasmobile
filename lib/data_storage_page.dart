import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataStoragePage extends StatefulWidget {
  const DataStoragePage({super.key});

  @override
  _DataStoragePageState createState() => _DataStoragePageState();
}

class _DataStoragePageState extends State<DataStoragePage> {
  Database? _database;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _classController = TextEditingController();
  List<Map<String, dynamic>> _items = [];
  int? _selectedItemId;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    try {
      String path = join(await getDatabasesPath(), 'example.db');
      _database = await openDatabase(
        path,
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE items(id INTEGER PRIMARY KEY, name TEXT, class TEXT)',
          );
        },
        version: 1,
      );
      _loadItems();
    } catch (e) {
      print('Error initializing database: $e');
    }
  }

  Future<void> _insertItem(String name, String className) async {
    try {
      await _database?.insert(
        'items',
        {'name': name, 'class': className},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      _loadItems(); // Reload items after insertion
    } catch (e) {
      print('Error inserting item: $e');
    }
  }

  Future<void> _updateItem(int id, String name, String className) async {
    try {
      await _database?.update(
        'items',
        {'name': name, 'class': className},
        where: 'id = ?',
        whereArgs: [id],
      );
      _loadItems(); // Reload items after update
    } catch (e) {
      print('Error updating item: $e');
    }
  }

  Future<void> _deleteItem(int id) async {
    try {
      await _database?.delete(
        'items',
        where: 'id = ?',
        whereArgs: [id],
      );
      _loadItems(); // Reload items after deletion
    } catch (e) {
      print('Error deleting item: $e');
    }
  }

  Future<void> _loadItems() async {
    try {
      final List<Map<String, dynamic>> items =
          await _database?.query('items') ?? [];
      setState(() {
        _items = items;
      });
    } catch (e) {
      print('Error loading items: $e');
    }
  }

  void _showEditDialog(
      BuildContext context, int id, String name, String className) {
    _nameController.text = name;
    _classController.text = className;
    _selectedItemId = id;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama'),
              ),
              TextField(
                controller: _classController,
                decoration: const InputDecoration(labelText: 'Kelas'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_selectedItemId != null) {
                  _updateItem(_selectedItemId!, _nameController.text,
                      _classController.text);
                  _nameController.clear();
                  _classController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Simpan'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Storage'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: _classController,
              decoration: const InputDecoration(labelText: 'Kelas'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String name = _nameController.text;
                String className = _classController.text;
                if (name.isNotEmpty && className.isNotEmpty) {
                  _insertItem(name, className);
                  _nameController.clear();
                  _classController.clear();
                }
              },
              child: const Text('Tambah Data'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _items.isEmpty
                  ? const Center(child: Text('Tidak ada data'))
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 20.0, // Menambahkan ruang antara kolom
                        columns: const [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Nama')),
                          DataColumn(label: Text('Kelas')),
                          DataColumn(label: Text('Aksi')),
                        ],
                        rows: _items.map((item) {
                          return DataRow(cells: [
                            DataCell(Text(item['id'].toString())),
                            DataCell(Text(item['name'])),
                            DataCell(Text(item['class'])),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      _showEditDialog(context, item['id'],
                                          item['name'], item['class']);
                                    },
                                  ),
                                  const SizedBox(
                                      width:
                                          8.0), // Menambahkan ruang antara tombol
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      _deleteItem(item['id']);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _database?.close();
    _nameController.dispose();
    _classController.dispose();
    super.dispose();
  }
}
