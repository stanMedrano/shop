import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop/componentes/bottom_nav_bar.dart';
import 'package:shop/restaurante/agregar_producto_page.dart';

import 'package:shop/pages/bebida_page.dart';
import 'package:shop/pages/pedido_page.dart';
import 'package:shop/pages/principal_page.dart';
import 'package:shop/pages/pupusa_page.dart';
import 'package:shop/restaurante/restaurante_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

// Método para cerrar sesión del usuario
void signUserOut() {
  FirebaseAuth.instance.signOut();
}

void _navigateToAgregarProducto(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const AgregarProductoScreen(),
    ),
  );
}

void _navigateToPedidos(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const RestauranteScreen(),
    ),
  );
}

class _HomePageState extends State<HomePage> {
// Declara la lista de pedidos
  // Índice seleccionado en el bottom nav bar
  int _selectedIndex = 0;
  String? userRole; // Variable para almacenar el rol del usuario
  final user = FirebaseAuth.instance.currentUser;

  // Este método actualizará nuestro índice seleccionado
  // cuando el usuario toque en la barra inferior
  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Páginas para mostrar
  late final List<Widget> _pages;
  @override
  void initState() {
    super.initState();
    // Obtén una instancia de YourOrderClass
    _pages = [
      const PrincipalPage(),
      const PupusasScreen(),
      const BebidasScreen(),
      const PedidoPage(),
    ];
    // Obtén el rol del usuario desde Firestore
    _getUserRole();
  }

  Future<void> _getUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Utiliza la referencia a Firestore para obtener el rol del usuario
      final userDocument = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDocument.exists) {
        setState(() {
          userRole = userDocument['role'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 92, 83),
      bottomNavigationBar: MyBottomNavBar(
        onTabChange: (index) => navigateBottomBar(index),
      ),
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        title: Text(
          '!Hola!   ${user!.email!}',
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Icon(
                Icons.menu,
              ),
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey[900],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                // Logo
                DrawerHeader(
                  child: Image.asset('lib/imagenes/cocina.png'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Divider(
                    color: Colors.grey[900],
                  ),
                ),

                // Condiciona la creación de elementos según el rol del usuario
                if (userRole == 'restaurante')
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: ListTile(
                      leading: const Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                      title: const Text(
                        'Ver pedidos',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () => _navigateToPedidos(context),
                    ),
                  ),
                if (userRole == 'restaurante')
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: ListTile(
                      leading: const Icon(
                        Icons.info,
                        color: Colors.white,
                      ),
                      title: const Text(
                        'Agregar Producto',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () => _navigateToAgregarProducto(context),
                    ),
                  ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 25, bottom: 25),
              child: ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                title: Text(
                  'Salir',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: signUserOut,
              ),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
