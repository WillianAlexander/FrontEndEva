import 'dart:convert';
import 'package:eva/models/user.dto.dart';
import 'package:eva/provider/state/user.state.dart';
import 'package:eva/provider/usuario/user.provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class UserService {
  final String baseUrl = 'http://192.168.112.131:3000';

  Future<bool> createUser(UsuarioDto usuarioDto, BuildContext context) async {
    final url = Uri.parse('$baseUrl/usuarios');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuarioDto.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Usuario creado correctamente');
      if (!context.mounted) return true;
      Provider.of<UsuarioProvider>(
        context,
        listen: false,
      ).cargarDesdeJson(jsonDecode(response.body));
      return true;
    } else {
      print('Error al crear usuario: ${response.body}');
      return false;
    }
  }

  Future<bool> userExists(User? user, BuildContext context) async {
    try {
      final usuario = user!.email!.split("@")[0];

      final url = Uri.parse('$baseUrl/usuarios/${usuario.toUpperCase()}');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (response.body.isEmpty) {
          print(
            'Respuesta exitosa: ${response.statusCode} \n Usuario no encontrado! ==> ${response.body}',
          );
          return false;
        }

        print('El usuario ya existe! ==> ${response.body}');

        if (!context.mounted) return true;

        Provider.of<UsuarioProvider>(
          context,
          listen: false,
        ).cargarDesdeJson(jsonDecode(response.body));

        return true;
      } else {
        print('Usuario no existe: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error al verificar existencia de usuario: $e');
      return false;
    }
  }

  Future<Usuario?> getUserData(String usuario) async {
    try {
      final url = Uri.parse('$baseUrl/usuarios/$usuario');
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (response.body.isEmpty) {
          print(
            'Respuesta exitosa: ${response.statusCode} \n Usuario no encontrado! ==> ${response.body}',
          );
          return null;
        }

        return Usuario.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Usuario no existe: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error al obtener el usuario: $e');
    }
  }
}
