import 'package:eva/pages/informe/form_page.dart';
import 'package:eva/pages/informe/listado_informes.dart';
import 'package:eva/pages/main_page.dart';
import 'package:flutter/material.dart';

class RegisterReport extends StatefulWidget {
  const RegisterReport({super.key});

  @override
  State<RegisterReport> createState() => _RegisterReportState();
}

class _RegisterReportState extends State<RegisterReport> {
  // Estado para controlar la vista seleccionada
  String _selectedOption = 'home'; // Valor inicial
  bool _showInformesSubOptions =
      false; // Controla si se muestran las subopciones de "Informes"

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    // Método para obtener el contenido dinámico según la opción seleccionada
    Widget getBodyContent() {
      switch (_selectedOption) {
        case 'ingreso_informes':
          return const FormPage(); // Carga FormPage en el body
        case 'listado_informes':
          return const ListadoInformes();
        case 'settings':
          return const Center(
            child: Text(
              'Configuración de la aplicación.',
              style: TextStyle(fontSize: 18),
            ),
          );
        default:
          // return const Center(
          //   child: Text(
          //     'Bienvenido a la aplicación.',
          //     style: TextStyle(fontSize: 18),
          //   ),
          // );
          return MainPage();
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        flexibleSpace: SafeArea(
          child: Center(
            child: Transform.scale(
              alignment: Alignment.center,
              scale: 0.65,
              child: Image.asset('assets/coop.png'),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: theme.background,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(height: 125, child: CustomDrawerHeader(theme: theme)),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                setState(() {
                  _selectedOption = 'home';
                  _showInformesSubOptions = false; // Oculta las subopciones
                });
                Navigator.pop(context); // Cierra el Drawer
              },
            ),
            ExpansionTile(
              leading: const Icon(Icons.document_scanner),
              title: const Text('Informes'),
              onExpansionChanged: (expanded) {
                setState(() {
                  _showInformesSubOptions = expanded;
                });
              },
              children: [
                ListTile(
                  leading: const Icon(Icons.add),
                  title: const Text('Ingreso de informes'),
                  onTap: () {
                    setState(() {
                      _selectedOption = 'ingreso_informes';
                    });
                    Navigator.pop(context); // Cierra el Drawer
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.list),
                  title: const Text('Listado de informes'),
                  onTap: () {
                    setState(() {
                      _selectedOption = 'listado_informes';
                    });
                    Navigator.pop(context); // Cierra el Drawer
                  },
                ),
              ],
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: () {
                setState(() {
                  _selectedOption = 'settings';
                  _showInformesSubOptions = false; // Oculta las subopciones
                });
                Navigator.pop(context); // Cierra el Drawer
              },
            ),
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
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: theme.background,
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
              child: getBodyContent(), // Carga el contenido dinámico
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader({super.key, required this.theme});

  final ColorScheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      color: theme.primary, // Color de fondo
      child: Center(
        child: Transform.scale(
          alignment: Alignment.center,
          scale: 0.8,
          child: Image.asset('assets/logo.png'),
        ),
      ),
    );
  }
}
