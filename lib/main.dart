import 'package:eva/home_page.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData == true) {
            final user = snapshot.data;
            return HomePage(user: user);
          } else {
            return const MyHomePage(title: 'Cooperativa Gualaquiza');
          }
        },
      ),
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
