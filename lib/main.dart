import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

// Import halaman
import 'package:app_berita/pages/login.dart';
import 'package:app_berita/pages/splashscreen.dart';
import 'package:app_berita/navigation/bottomnav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GlobalNet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
        colorScheme: ColorScheme.dark().copyWith(
          primary: Colors.green,
          secondary: Colors.greenAccent,
        ),
      ),
      home: const SplashAndAuthRouter(),
    );
  }
}

// Splash screen + Routing berdasarkan login status
class SplashAndAuthRouter extends StatefulWidget {
  const SplashAndAuthRouter({super.key});

  @override
  State<SplashAndAuthRouter> createState() => _SplashAndAuthRouterState();
}

class _SplashAndAuthRouterState extends State<SplashAndAuthRouter> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();

    // Tampilkan splash selama 3 detik
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _showSplash = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return const MySplashScreen();
    }

    // Setelah splash, cek status login
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: CircularProgressIndicator(color: Colors.green)),
          );
        } else if (snapshot.hasData) {
          return const BottomNav(); // Jika user sudah login
        } else {
          return const Login(); // Jika belum login
        }
      },
    );
  }
}
