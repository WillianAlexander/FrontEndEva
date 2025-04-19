import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class UserService {
  //final String baseUrl = 'http://10.0.2.2:3000'; // cambia por tu base real
  final String baseUrl = 'http://192.168.0.128:3000';
  // Future<Map<String, dynamic>> parseUser(User? user) async {
  //   final String nombres = user!.displayName!.split(" ").take(2).join(' ');
  //   final String apellidos = user.displayName!.split(" ").sublist(2).join(' ');
  //   final String correo = user.email!;
  //   final String usuario = user.email!.split("@")[0];
  //   return {
  //     'usuario': usuario,
  //     'nombres': nombres,
  //     'apellidos': apellidos,
  //     'correo': correo,
  //     'identificacion': '1400960850',
  //     'password': '1234567',
  //     'activo': true,
  //   };
  // }

  Future<bool> createUser({
    required String usuario,
    required String nombres,
    required String apellidos,
    required String identificacion,
    required String correo,
    required String password,
    bool? activo = true,
  }) async {
    final url = Uri.parse('$baseUrl/usuarios');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'usuario': usuario,
        'nombres': nombres,
        'apellidos': apellidos,
        'correo': correo,
        'identificacion': identificacion,
        'password': password,
        'activo': activo,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Usuario creado correctamente');
      return true;
    } else {
      print('Error al crear usuario: ${response.body}');
      return false;
    }
  }

  Future<bool> userExists(User? user) async {
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
}
