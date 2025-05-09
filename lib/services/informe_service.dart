import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:eva/provider/state/user.state.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class InformeService {
  final String baseUrl = 'http://192.168.112.131:3000';

  Future<String?> listarInformes(Usuario? user, BuildContext context) async {
    try {
      final usuario = user!.usuario;

      final url = Uri.parse('$baseUrl/informes/${usuario.toUpperCase()}');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (response.body.isEmpty) print('Lista vacia!');
        print('Listado de informes: ${jsonDecode(response.body)}');
        return response.body;
      }
    } catch (e) {
      throw Exception('Error al obtener listado de informes: $e');
    }
    return "";
  }

  Future<String> obtenerDirectorioDescargas() async {
    try {
      // Obtiene el directorio de documentos del almacenamiento interno
      final directory = await getExternalStorageDirectory();
      return directory!.path; // Devuelve la ruta del directorio
    } catch (e) {
      throw Exception('Error al obtener el directorio de descargas: $e');
    }
  }

  Future<void> descargarInforme(
    Uint8List contenido,
    String nombreArchivo,
    BuildContext context,
  ) async {
    try {
      // Obtiene el directorio de descargas
      final downloadPath = await obtenerDirectorioDescargas();
      final filePath = '$downloadPath/$nombreArchivo';

      // Escribe el archivo en el sistema de archivos
      final file = File(filePath);
      await file.writeAsBytes(contenido);

      // Muestra un mensaje de éxito
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Informe guardado en: $filePath')));
    } catch (e) {
      // Muestra un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar el informe: $e')),
      );
    }
  }

  Future<void> descargarYAbrirInforme(
    Uint8List contenido,
    String nombreArchivo,
    BuildContext context,
  ) async {
    try {
      // Obtiene el directorio temporal
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/$nombreArchivo';

      // Escribe el archivo en el sistema de archivos temporal
      final file = File(filePath);
      await file.writeAsBytes(contenido);

      // Verifica si el archivo existe y lo abre
      if (await File(filePath).exists()) {
        final result = await OpenFile.open(filePath);
        if (result.type == ResultType.done) {
          print('Archivo abierto correctamente.');
          if (!context.mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Archivo abierto: $filePath')));
        } else {
          print('No se pudo abrir el archivo.');
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No se pudo abrir el archivo.')),
          );
        }
      } else {
        print('El archivo no existe: $filePath');
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('El archivo no existe: $filePath')),
        );
      }
    } catch (e) {
      // Muestra un mensaje de error
      print(e);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al abrir el informe: $e')));
    }
  }
}
