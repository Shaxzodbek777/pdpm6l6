import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<dynamic> _employees = []; // Xodimlar ro'yxati
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEmployees(); // Xodimlarni yuklash
  }

  Future<void> _fetchEmployees() async {
    try {
      // APIga GET so'rovni yuborish
      final response = await http.get(Uri.parse('API_URL'));
      // Agar so'rov muvaffaqiyatli bo'lsa
      if (response.statusCode == 200) {
        // JSON javobni almashish va xodimlar ro'yxatini o'zlashtirish
        setState(() {
          _employees = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        // Agar xato bo'lsa, xatolik haqida xabar chiqaramiz
        setState(() {
          _isLoading = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Xatolik'),
              content: Text('Xodimlar yuklanmadi. Xatolik kodi: ${response.statusCode}'),
              actions: <Widget>[
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
    } catch (error) {
      // Agar umumiy xato bo'lsa, xatolik haqida xabar chiqaramiz
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Xatolik'),
            content: Text('Xodimlar yuklanmadi. Xatolik: $error'),
            actions: <Widget>[
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Xodimlar Ro`yxati'),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: _employees.length,
          itemBuilder: (BuildContext context, int index) {
            final employee = _employees[index];
            return ListTile(
              title: Text(employee['name']),
              subtitle: Text(employee['position']),
              onTap: () {
                // Biriktirilgan ma'lumotlar bilan EmployeeDetails sahifasiga o'tamiz
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmployeeDetails(employee),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class EmployeeDetails extends StatelessWidget {
  final dynamic employee;

  EmployeeDetails(this.employee);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Xodim Tafsilotlari'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ism: ${employee['name']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Vazifasi: ${employee['position']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Yosh: ${employee['age']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Maosh: ${employee['salary']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Email: ${employee['email']}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
