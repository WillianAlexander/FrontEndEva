import 'package:eva/pages/login_page.dart';
import 'package:eva/pages/main_page.dart';
import 'package:eva/pages/register_page.dart';
import 'package:eva/services/user_service.dart';
import 'package:eva/theme/apptheme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Configurar persistencia de sesión como 'none'
  if (kIsWeb) {
    await FirebaseAuth.instance.setPersistence(Persistence.NONE);
  } else {
    await FirebaseAuth.instance.signOut();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eva - Cooperativa Gualaquiza',
      theme: AppTheme.light,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData == true) {
            final user = snapshot.data;
            return FutureBuilder<bool>(
              future: UserService().userExists(
                user,
              ), // Verifica si el usuario ya está registrado
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (userSnapshot.hasError ||
                    userSnapshot.data == false) {
                  // Si no está registrado, redirige al formulario de registro
                  return RegistrationPage(user: user);
                } else {
                  // Si está registrado, redirige a la página principal
                  return MainPage(user: user);
                }
              },
            );
          } else {
            return LoginPage();
          }
        },
      ),
      routes: {
        '/main': (context) => const MainPage(), // Define la ruta para MainPage
        '/login':
            (context) => const LoginPage(), // Define la ruta para LoginPage
        '/register':
            (context) => const RegistrationPage(
              user: null,
            ), // Define la ruta para RegistrationPage
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton.icon(
              onPressed: () async {
                final provider = OAuthProvider('microsoft.com');
                provider.setCustomParameters({
                  "tenant": "1c82b496-37c3-4c4b-97ca-77aa4a47ab2f",
                  "prompt": "select_account",
                });
                await FirebaseAuth.instance.signInWithProvider(provider);
              },
              label: const Text('Sign in with microsoft'),
              icon: Icon(Icons.microwave_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
