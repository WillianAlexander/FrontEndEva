import 'package:eva/pages/informe/form_page.dart';
import 'package:flutter/material.dart';

class RegisterReport extends StatelessWidget {
  const RegisterReport({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                // Add functionality to open a menu or drawer
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: theme.primary),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.document_scanner),
              title: Text('Informes'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FormPage()),
                );
              },
            ),
            ListTile(leading: Icon(Icons.settings), title: Text('Settings')),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: theme.primary),
          ),
          Container(
            // margin: const EdgeInsets.only(top: 10),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: theme.background,
              // borderRadius: const BorderRadius.only(
              //   topLeft: Radius.elliptical(40, 25),
              //   topRight: Radius.elliptical(40, 25),
              // ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(51),
                  spreadRadius: 4,
                  blurRadius: 25,
                  offset: const Offset(0, 4), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bienvenido, ', style: const TextStyle(fontSize: 24)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
