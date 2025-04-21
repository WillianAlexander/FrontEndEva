import 'dart:typed_data';

import 'package:eva/provider/informe/informe.provider.dart';
import 'package:eva/provider/state/user.state.dart';
import 'package:eva/provider/usuario/user.provider.dart';
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

    return ListView.builder(
      itemCount: informeProvider.informes.length,
      itemBuilder: (context, index) {
        final informe = informeProvider.informes[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ListTile(
            // title: Text('Periodo: ${informe.periodo}'),
            title: Text('Informe'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text('Usuario: ${informe.usuarioEntrega}'),
                Text(
                  'Fecha de entrega: ${dateFormat.format(informe.fechaEntrega)}',
                ),
                Text('Estado: ${informe.estadoId}'),
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
                    ).descargarInforme(archivo, nombreArchivo, context);
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
