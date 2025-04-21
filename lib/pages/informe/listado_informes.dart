import 'dart:typed_data';
import 'package:eva/provider/informe/informe.provider.dart';
import 'package:eva/provider/state/user.state.dart';
import 'package:eva/provider/usuario/user.provider.dart';
import 'package:eva/services/user_service.dart';
import 'package:eva/utils/date_formater.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListadoInformes extends StatefulWidget {
  const ListadoInformes({super.key});

  @override
  State<ListadoInformes> createState() => _ListadoInformesState();
}

class _ListadoInformesState extends State<ListadoInformes> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Usuario? user =
          Provider.of<UsuarioProvider>(context, listen: false).usuario;
      if (user != null) {
        Provider.of<InformeProvider>(
          context,
          listen: false,
        ).obtenerInformes(user, context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final informeProvider = Provider.of<InformeProvider>(context);
    final user = Provider.of<UsuarioProvider>(context).usuario;

    if (user == null) {
      return const Center(child: Text('Usuario no autenticado'));
    }

    if (informeProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (informeProvider.informes.isEmpty) {
      return const Center(child: Text('No hay informes disponibles.'));
    }

    String obtenerTextoEstado(String estado) {
      switch (estado) {
        case 'R':
          return 'Recibido';
        case 'P':
          return 'Pendiente';
        case 'E':
          return 'Evaluado';
        default:
          return 'Desconocido';
      }
    }

    return ListView.builder(
      itemCount: informeProvider.informes.length,
      itemBuilder: (context, index) {
        final informe = informeProvider.informes[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ListTile(
            // title: Text('Periodo: ${informe.periodo}'),
            title: Text('Informe Mensual'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: UserService().getUserData(informe.usuarioEntrega),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text('Cargando usuario...');
                    } else if (snapshot.hasError) {
                      return const Text('Error al cargar usuario');
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return const Text('Usuario no encontrado');
                    }

                    final usuario = snapshot.data as Usuario;
                    return Text(
                      'por: ${usuario.nombres.split(" ").first} ${usuario.apellidos.split(" ").first}',
                    );
                  },
                ),
                Text(
                  'Fecha de entrega: ${DateFormatter.format(informe.fechaEntrega)}',
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: theme.secondary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      width: 100,
                      child: Text(
                        obtenerTextoEstado(informe.estadoId),
                        style: TextStyle(
                          color: theme.surface,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.download),
              onPressed: () async {
                if (informe.contenido != null) {
                  final archivo = Uint8List.fromList(informe.contenido!);
                  final nombreArchivo = 'informe_${informe.periodo}.pdf';

                  try {
                    await Provider.of<InformeProvider>(
                      context,
                      listen: false,
                    ).descargarYAbrirInforme(archivo, nombreArchivo, context);
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error al descargar el informe: $e'),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('El informe no tiene contenido.'),
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
