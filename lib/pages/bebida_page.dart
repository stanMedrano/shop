import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/controlles/bebidas_controller.dart';
import 'package:shop/models/CarritoModel.dart';
import 'package:shop/models/carrito.dart';
import 'package:shop/models/menu.dart';
import 'package:shop/pages/carrito_page.dart';

class BebidasScreen extends StatefulWidget {
  const BebidasScreen({Key? key}) : super(key: key);

  @override
  _BebidasScreenState createState() => _BebidasScreenState();
}

class _BebidasScreenState extends State<BebidasScreen> {
  List<Producto> bebidas = [];
  List<ProductoSeleccionado> productosSeleccionados = [];
  final BebidasController _controller = BebidasController();

  @override
  void initState() {
    super.initState();
    // Obtén los productos de la categoría "Pupusas" al iniciar la pantalla
    _obtenerProductosBebidas();
  }

  void _obtenerProductosBebidas() async {
    final productos = await _controller.obtenerProductosBebidas();

    setState(() {
      bebidas = productos;
    });
  }

  void _agregarProductoSeleccionado(ProductoSeleccionado producto) {
    _controller.agregarProductoSeleccionado(producto, productosSeleccionados);
    setState(() {});
  }

  void _quitarProductoSeleccionado(ProductoSeleccionado producto) {
    _controller.quitarProductoSeleccionado(producto, productosSeleccionados);
    setState(() {});
  }

  void _agregarProductosAlCarrito() {
    _controller.agregarProductosAlCarrito(productosSeleccionados,
        Provider.of<CarritoModel>(context, listen: false));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Productos agregados al carrito'),
      ),
    );

    productosSeleccionados.clear();
    setState(() {});
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
      backgroundColor: Colors.black12,
      body: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.all(10.0), // Añade relleno alrededor del texto
            child: const Text(
              'Disfruta de nuestras ricas bebidas',
              style: TextStyle(
                  fontSize: 18, // Tamaño de fuente personalizado
                  fontWeight: FontWeight.bold, // Texto en negrita
                  color: Colors.white),
            ),
          ),
          if (showList)
            Expanded(
              child: ListView.builder(
                itemCount: bebidas.length,
                itemBuilder: (context, index) {
                  final producto = bebidas[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      tileColor: Colors.white,
                      contentPadding: const EdgeInsets.all(4.0),
                      shape: RoundedRectangleBorder(
                        // Personaliza los bordes
                        borderRadius: BorderRadius.circular(
                            10.0), // Establece un radio específico para los bordes
                        side: const BorderSide(color: Colors.black, width: 0.7),
                      ),
                      leading: SizedBox(
                        width: 90.0,
                        height: 90.0,
                        child: Image.network(
                          producto.imagePath,
                          fit: BoxFit.contain,
                        ), // Ruta de tu imagen
                      ),
                      title: Text(producto.nombre),
                      subtitle:
                          Text('\$ ${producto.precio.toStringAsFixed(2)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                _quitarProductoSeleccionado(
                                  ProductoSeleccionado(
                                    nombre: producto.nombre,
                                    precio: producto.precio,
                                  ),
                                );
                              });
                            },
                          ),
                          Text(productosSeleccionados
                              .firstWhere(
                                (item) => item.nombre == producto.nombre,
                                orElse: () => ProductoSeleccionado(
                                    nombre: producto.nombre,
                                    precio: producto.precio),
                              )
                              .cantidad
                              .toString()),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                _agregarProductoSeleccionado(
                                  ProductoSeleccionado(
                                    nombre: producto.nombre,
                                    precio: producto.precio,
                                  ),
                                );
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.shopping_cart),
                            onPressed: () {
                              _agregarProductosAlCarrito();
                            },
                          ),
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
        backgroundColor:
            Colors.black, // Personaliza el color de fondo del botón
        child: const Icon(
          Icons.shopping_cart,
          color: Colors.white, // Personaliza el color del ícono
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
