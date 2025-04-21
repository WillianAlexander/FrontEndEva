import 'package:eva/pages/login/login_page.dart';
import 'package:eva/pages/main_page.dart';
import 'package:eva/pages/register/register_page.dart';
import 'package:eva/pages/register/register_report.dart';
import 'package:eva/provider/informe/informe.provider.dart';
import 'package:eva/provider/usuario/user.provider.dart';
import 'package:eva/services/user_service.dart';
import 'package:eva/theme/apptheme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Configurar persistencia de sesión como 'none'
  if (kIsWeb) {
    await FirebaseAuth.instance.setPersistence(Persistence.NONE);
  } else {
    await FirebaseAuth.instance.signOut();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UsuarioProvider()),
        ChangeNotifierProvider(create: (_) => InformeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eva - Cooperativa Gualaquiza',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es'), // Español
        Locale('en'), // Inglés (opcional)
      ],
      locale: const Locale('es'), // Establecer español como predeterminado
      theme: AppTheme.light,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData == true) {
            final user = snapshot.data;
            return FutureBuilder<bool>(
              future: UserService().userExists(
                user,
                context,
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
                  // return MainPage(user: user);
                  return RegisterReport();
                }
              },
            );
          } else {
            return LoginPage();
          }
        },
      ),
      routes: {
        '/main': (context) {
          // final user = ModalRoute.of(context)!.settings.arguments as User?;
          return RegisterReport();
        },
        '/login': (context) => const LoginPage(),
        // '/register': (context) => const RegistrationPage(user: null),
      },
      // home: RegisterReport(),
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
