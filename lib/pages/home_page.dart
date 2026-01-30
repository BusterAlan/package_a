import 'package:flutter/material.dart';
import 'package:package_a/pages/detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text("Package a 1")
    ),
    body: Center(child: Text("HomePage")),
    floatingActionButton: FloatingActionButton(
      onPressed: () => _onPressed(context),
      child: Icon(Icons.add_rounded),
    ),
  );

  void _onPressed(BuildContext context) => Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (context) => const DetailPage()));
}
