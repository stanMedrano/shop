import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop/componentes/my_button.dart';
import 'package:shop/componentes/my_textfield.dart';
import 'package:lottie/lottie.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text editing controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isRestaurante = false;

//Crear usuario
  void signUserUp() async {
    if (mounted) {
      // Muestra un círculo de carga mientras se realiza el registro.
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      try {
        // Verificar campos de contraseñas
        if (passwordController.text == confirmPasswordController.text) {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
          final user = FirebaseAuth.instance.currentUser;
          // Almacena el tipo de usuario en Firestore (ya sea 'cliente' o 'restaurante')
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user?.uid)
              .set({
            'role': isRestaurante ? 'restaurante' : 'cliente',
          });

          // Cierra el diálogo de carga.
          if (mounted) Navigator.pop(context);
        } else {
          // Contraseñas no coinciden
          showErrorMessage('Contraseñas no son iguales');
        }
      } on FirebaseAuthException catch (e) {
        // Error al crear el usuario
        if (mounted) Navigator.pop(context);
        // Muestra un cuadro de diálogo con un mensaje de error.
        showErrorMessage(e.code);
      }
    }
  }

  //mesaje
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

                const SizedBox(height: 10),
                Text(
                  'Crear tu cuenta',
                  style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 19,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 25),

                //username textfield
                MyTextfield(
                  controller: emailController,
                  hinText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),

                //Password textfield
                MyTextfield(
                  controller: passwordController,
                  hinText: 'Contraseña',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                //Confirm Password textfield
                MyTextfield(
                  controller: confirmPasswordController,
                  hinText: 'Confirmar Contraseña',
                  obscureText: true,
                ),
                const SizedBox(height: 10),

                //sign in button
                MyButton(
                  text: 'Crear',
                  onTap: signUserUp,
                ),

                const SizedBox(height: 25),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[300],
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
                      'Ya tienes cuenta?',
                      style: TextStyle(color: Colors.grey[300], fontSize: 17),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Iniciar sesión',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          isRestaurante = !isRestaurante;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isRestaurante
                                ? Colors.white
                                : const Color.fromARGB(255, 0, 92,
                                    83), // Cambia el color del borde
                            width: 2.0, // Ancho del borde
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: isRestaurante
                              ? const Icon(
                                  Icons.check,
                                  size: 20.0,
                                  color: Colors
                                      .white, // Cambia el color del checkmark
                                )
                              : Container(
                                  width: 20.0,
                                  height: 20.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color.fromARGB(255, 0, 92,
                                          83), // Cambia el color del círculo cuando no está seleccionado
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Soy un restaurante',
                      style: TextStyle(
                          color: isRestaurante
                              ? Colors
                                  .white // Cambia el color del texto cuando está seleccionado
                              : const Color.fromARGB(255, 0, 92,
                                  83) // Cambia el color del texto cuando no está seleccionado
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
