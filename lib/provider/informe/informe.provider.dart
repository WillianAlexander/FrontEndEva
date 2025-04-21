import 'dart:convert';
import 'dart:typed_data';

import 'package:eva/provider/state/informe.state.dart';
import 'package:eva/provider/state/user.state.dart';
import 'package:eva/services/informe_service.dart';
import 'package:flutter/material.dart';

class InformeProvider with ChangeNotifier {
  final InformeService _informeService = InformeService();
  List<Informe> _informes = [];
  bool _isLoading = false;

  List<Informe> get informes => _informes;
  bool get isLoading => _isLoading;

  Future<void> obtenerInformes(Usuario? user, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _informeService.listarInformes(user, context);
      if (response != null && response.isNotEmpty) {
        final List<dynamic> data = jsonDecode(response);
        _informes = data.map((json) => Informe.fromJson(json)).toList();
      } else {
        _informes = [];
      }
    } catch (e) {
      print('Error al obtener los informes: $e');
      _informes = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> descargarInforme(
    Uint8List contenido,
    String nombreArchivo,
    BuildContext context,
  ) async {
    try {
      await _informeService.descargarInforme(contenido, nombreArchivo, context);
    } catch (e) {
      print('Error al descargar el informe: $e');
    }
  }

  Future<void> descargarYAbrirInforme(
    Uint8List contenido,
    String nombreArchivo,
    BuildContext context,
  ) async {
    try {
      await _informeService.descargarYAbrirInforme(
        contenido,
        nombreArchivo,
        context,
      );
    } catch (e) {
      print('Error al descargar el informe: $e');
    }
  }
}
