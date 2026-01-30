import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:package_a/routes/package_a_router.gr.dart';

@RoutePage()
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

  void _onPressed(BuildContext context) => context.router.push(
    const DetailRoute(),
  );
}
