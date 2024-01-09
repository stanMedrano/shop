import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/CarritoModel.dart';
import 'package:shop/models/carrito.dart';
import 'package:shop/models/menu.dart';
import 'package:shop/pages/carrito_page.dart';
import 'package:shop/services/firebase_service.dart';

class PrincipalPage extends StatefulWidget {
  const PrincipalPage({super.key});

  @override
  State<PrincipalPage> createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  List<Producto> favoritos = [];
  List<ProductoSeleccionado> productosSeleccionados = [];
  @override
  void initState() {
    super.initState();
    // Obtén los productos de la categoría "Favoritos" al iniciar la pantalla
    obtenerProductosFavoritos();
  }

  void obtenerProductosFavoritos() async {
    // Llama a la función para obtener productos de la categoría "Platillos"
    final productos = await obtenerProductosPorCategoria('Platillos');

    setState(() {
      favoritos = productos;
    });
  }

  // Función para actualizar la disponibilidad en Firestore

  void agregarProductosAlCarrito(Producto producto) {
    final carritoModel = Provider.of<CarritoModel>(context, listen: false);

    // Agrega el producto al carrito con una cantidad de 1
    carritoModel.agregarAlCarrito(ProductoEnCarrito(
      producto: ProductoSeleccionado(
        nombre: producto.nombre,
        precio: producto.precio,
      ),
      cantidad: 1,
    ));

    // Muestra un mensaje
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Producto agregado al carrito'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obtener la hora actual
    DateTime now = DateTime.now();
    // Definir el rango de horas en el que se mostrará la lista
    int startHour = 7;
    int endHour = 21;
    // Verificar si la hora actual está dentro del rango
    bool showList = now.hour >= startHour && now.hour < endHour;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 92, 83),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              'Bienvenidos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Productos mas vendidos🔥',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          if (showList)
            Expanded(
              child: ListView.builder(
                itemCount: favoritos.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final producto = favoritos[index];
                  return Container(
                    margin: const EdgeInsets.only(left: 10),
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 200, // Ancho deseado
                            height: 180, // Alto deseado
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                producto.imagePath,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(
                            producto.descripcion,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 17,
                            ),
                          ),
                          //precio y detalles
                          Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      producto.nombre,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    const SizedBox(height: 5),
                                    //
                                    Text(
                                      '\$ ${producto.precio.toStringAsFixed(2)}',
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 16),
                                    ),
                                  ],
                                ),

                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        agregarProductosAlCarrito(producto);
                                      });
                                    },
                                  ),
                                ), //
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          else
            Expanded(
              child: Center(
                child: Text(
                  'La lista de productos solo está disponible entre $startHour:00 y $endHour:00',
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          //
          const SizedBox(
            height: 60,
          ),
          MediaQuery.of(context).orientation == Orientation.portrait
              ? const SizedBox(
                  height:
                      65, // Altura cuando el dispositivo está en orientación vertical
                )
              : const SizedBox(
                  height:
                      2, // Altura cuando el dispositivo está en orientación horizontal
                ),

          const Padding(
            padding: EdgeInsets.only(top: 25, left: 25, right: 25),
            child: Divider(
              color: Colors.white,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navega a la pantalla del carrito
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CarritoScreen(),
            ),
          );
        },
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.shopping_cart,
          color: Colors.white, // Personaliza el color del ícono
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
