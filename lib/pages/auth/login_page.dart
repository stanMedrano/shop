import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop/componentes/my_button.dart';
import 'package:shop/componentes/my_textfield.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text editing controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isRestaurante = false;

//inicio de sesión de usuario
  void signUserIn() async {
    // Muestra un círculo de carga mientras se realiza el inicio de sesión.
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        // Cierra el diálogo de carga en caso de error.
        Navigator.pop(context);
        // Muestra un cuadro de diálogo con un mensaje de error.
        showErrorMessage(e.code);
      }
    }
  }

  //mesaje de error
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 92, 83),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Logo
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Lottie.asset('lib/imagenes/anima.json'),
                ),

                const SizedBox(height: 15),
                Text(
                  'Bienvenidos al menu El gustito',
                  style: TextStyle(
                    color: Colors.grey[200],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),

                //username textfield
                MyTextfield(
                  controller: emailController,
                  hinText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),

                //username textfield
                MyTextfield(
                  controller: passwordController,
                  hinText: 'Contraseña',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                // Checkbox to select the user role

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Olvido la contraseña?',
                        style: TextStyle(color: Colors.grey[300]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                //sign in button
                MyButton(
                  text: 'Ingresar',
                  onTap: signUserIn,
                ),

                const SizedBox(height: 25),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[300]),
                        ),
                      ),
                      Expanded(
                          child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[300],
                      ))
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                //not a member? Register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No estas registrado?',
                      style: TextStyle(color: Colors.grey[300], fontSize: 17),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Registrate',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
