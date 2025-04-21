import 'package:eva/services/login_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(color: theme.primary),
          ),
          Container(
            margin: const EdgeInsets.only(top: 85),
            height: size.height,
            decoration: BoxDecoration(
              color: theme.background,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.elliptical(40, 25),
                topRight: Radius.elliptical(40, 25),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(51),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/coop.png',
                    width: double.infinity,
                    // height: 100, // Ajusta el tamaño según lo necesites
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text('Error al cargar la imagen');
                    },
                  ),

                  const SizedBox(height: 80),

                  // Botón
                  SizedBox(
                    width: 180,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final provider = OAuthProvider('microsoft.com');
                        provider.setCustomParameters({
                          "tenant": "1c82b496-37c3-4c4b-97ca-77aa4a47ab2f",
                          "prompt": "select_account",
                        });

                        try {
                          await FirebaseAuth.instance.signInWithProvider(
                            provider,
                          );
                          // final userCredential = await FirebaseAuth.instance
                          //     .signInWithProvider(provider);
                          // final credential =
                          //     userCredential.credential as AuthCredential;
                          // final accessToken = credential.accessToken;
                          // if (accessToken != '') {
                          //   final payload = LoginService().decodeToken(
                          //     accessToken!,
                          //   );
                          //   print('family_name: ${payload['family_name']}');
                          //   print('given_name: ${payload['given_name']}');
                          // }
                        } catch (e) {
                          if (e is FirebaseAuthException) {
                            // Handle specific FirebaseAuth exceptions
                            if (e.code == 'user-cancelled') {
                              // User cancelled the login
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Login cancelled by user.'),
                                ),
                              );
                            } else {
                              // Other FirebaseAuth errors
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Login failed: ${e.message}'),
                                ),
                              );
                            }
                          } else {
                            // Handle other types of exceptions
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'An unexpected error occurred: $e',
                                ),
                              ),
                            );

                            print('Not FirebaseAuthException: $e');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2F2F2F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Image.asset(
                        'assets/microsoft.png',
                        width: 24,
                        height: 24,
                      ),
                      label: const Text(
                        // 'Sign in with Microsoft',
                        'Ingresar',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
