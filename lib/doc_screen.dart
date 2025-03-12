import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;

class DocumentationScreen extends StatefulWidget {
  @override
  _DocumentationScreenState createState() => _DocumentationScreenState();
}

class _DocumentationScreenState extends State<DocumentationScreen> {
  String markdownData = "Загрузка документации...";

  @override
  void initState() {
    super.initState();
    fetchMarkdown();
  }

  Future<void> fetchMarkdown() async {
    final url = "https://raw.githubusercontent.com/KlyuevaMaria/flutter_calculator/refs/heads/main/README.md";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        markdownData = response.body;
      });
    } else {
      setState(() {
        markdownData = "Ошибка загрузки документации";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 60, left: 10, right: 10),
            child: Markdown(data: markdownData),
          ),
          Positioned(
            top: 20,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_back, size: 30, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
