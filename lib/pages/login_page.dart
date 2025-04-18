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
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Cooperativa Gualaquiza'),
      //   centerTitle: true,
      // ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: theme.primary),
          ),
          // Container(
          //   margin: const EdgeInsets.only(top: 26),
          //   height: MediaQuery.of(context).size.height,
          //   width: MediaQuery.of(context).size.width,
          //   decoration: BoxDecoration(
          //     color: theme.primary,
          //     borderRadius: const BorderRadius.only(
          //       topLeft: Radius.elliptical(40, 25),
          //       topRight: Radius.elliptical(40, 25),
          //     ),
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.black.withAlpha(51),
          //         spreadRadius: 4,
          //         blurRadius: 35,
          //         offset: const Offset(0, 5), // changes position of shadow
          //       ),
          //     ],
          //   ),
          // ),
          Container(
            margin: const EdgeInsets.only(top: 85),
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: theme.background,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.elliptical(40, 25),
                topRight: Radius.elliptical(40, 25),
              ),
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/coop.png',
                    width:
                        double.infinity, // ajusta el tamaño según lo necesites
                  ),

                  const SizedBox(height: 80),

                  // const Text(
                  //   'Bienvenido',
                  //   style: TextStyle(
                  //     fontSize: 32,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.black87,
                  //   ),
                  // ),
                  const SizedBox(height: 40),

                  // Botón
                  SizedBox(
                    width: double.infinity,
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
                              const SnackBar(
                                content: Text('An unexpected error occurred.'),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2F2F2F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      // icon: Image.network(
                      //   'https://img.icons8.com/color/48/000000/microsoft.png',
                      //   width: 24,
                      //   height: 24,
                      // ),
                      icon: Image.asset(
                        'assets/microsoft.png',
                        width: 24,
                        height: 24,
                      ),
                      label: const Text(
                        'Sign in with Microsoft',
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
