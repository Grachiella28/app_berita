import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app_berita/pages/register.dart';
import 'package:app_berita/services/auth_service.dart';
import 'package:app_berita/pages/home.dart';
import 'package:app_berita/navigation/Bottomnav.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                Text(
                  "Login here",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[400],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Welcome back you've\nbeen missed!",
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Email
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.grey[300]),
                    filled: true,
                    fillColor: Colors.white10,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),

                // Password
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.grey[300]),
                    filled: true,
                    fillColor: Colors.white10,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 8),

                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          final TextEditingController resetEmailController =
                              TextEditingController();

                          return AlertDialog(
                            backgroundColor: Colors.grey[900],
                            title: Text(
                              "Reset Password",
                              style: TextStyle(color: Colors.white),
                            ),
                            content: TextField(
                              controller: resetEmailController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: "Enter your email",
                                hintStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: Colors.grey[850],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  final email =
                                      resetEmailController.text.trim();
                                  if (email.isNotEmpty) {
                                    try {
                                      await _authService.sendPasswordReset(
                                        email,
                                      );
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Reset email sent to $email",
                                          ),
                                        ),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Error: ${e.toString()}",
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: Text(
                                  "Send",
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                      // forgot password logic
                    },
                    child: const Text(
                      "Forgot your password?",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),

                // Error message
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.redAccent),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Sign in button
                ElevatedButton(
                  onPressed: () async {
                    final result = await _authService.signIn(
                      email: _emailController.text.trim(),
                      password: _passwordController.text,
                    );

                    if (result == null) {
                      // Jika sukses login, arahkan ke halaman Home (atau dashboard)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Login successful!')),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BottomNav(),
                        ),
                      );
                      // Navigator.pushReplacement(...); ← jika sudah punya halaman Home
                    } else {
                      // Tampilkan pesan error
                      setState(() {
                        _errorMessage = result;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    "Sign in",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),

                // Create new account
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Register()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text("Create new account"),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
