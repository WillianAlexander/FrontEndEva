import 'package:eva/models/user.dto.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eva/services/user_service.dart';

class RegistrationPage extends StatefulWidget {
  final User? user;

  const RegistrationPage({super.key, required this.user});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombresController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _identificacionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 10),
              TextFormField(
                controller: _nombresController,
                decoration: const InputDecoration(labelText: 'Nombres'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Campo requerido'
                            : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _apellidosController,
                decoration: const InputDecoration(labelText: 'Apellidos'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Campo requerido'
                            : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _identificacionController,
                decoration: const InputDecoration(labelText: 'Identificación'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Campo requerido'
                            : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      // Validar que widget.user no sea null
                      if (widget.user == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Error: Usuario no autenticado'),
                          ),
                        );
                        return;
                      }

                      // Crear el DTO usando el constructor de fábrica
                      final usuarioDto = UsuarioDto.fromFirebaseUser(
                        user: widget.user!,
                        nombres: _nombresController.text,
                        apellidos: _apellidosController.text,
                        identificacion: _identificacionController.text,
                      );

                      final userService = UserService();
                      final success = await userService.createUser(usuarioDto);

                      if (success) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Usuario registrado con éxito'),
                          ),
                        );
                        // Navegar a MainPage pasando el objeto User como argumento
                        Navigator.pushReplacementNamed(
                          context,
                          '/main',
                          arguments: widget.user,
                        );
                      } else {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Error al registrar usuario'),
                          ),
                        );
                      }
                    } catch (e) {
                      // Manejar cualquier excepción
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error inesperado: $e')),
                      );
                    }
                  }
                },
                child: const Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
