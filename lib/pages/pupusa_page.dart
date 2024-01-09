import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/controlles/pupusas_controller.dart';
import 'package:shop/models/CarritoModel.dart';
import 'package:shop/models/carrito.dart';
import 'package:shop/models/menu.dart';
import 'package:shop/pages/carrito_page.dart';

class PupusasScreen extends StatefulWidget {
  const PupusasScreen({Key? key}) : super(key: key);

  @override
  _PupusasScreenState createState() => _PupusasScreenState();
}

class _PupusasScreenState extends State<PupusasScreen> {
  List<Producto> pupusas = [];
  List<ProductoSeleccionado> productosSeleccionados = [];
  final PupusasController _controller = PupusasController();

  @override
  void initState() {
    super.initState();
    // Obtener los productos de la categoría "Pupusas" al iniciar la pantalla
    _obtenerProductosPupusas();
  }

  void _obtenerProductosPupusas() async {
    final productos = await _controller.obtenerProductosPupusas();

    setState(() {
      pupusas = productos;
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
                const EdgeInsets.all(15.0), // Añade relleno alrededor del texto
            child: const Text(
              'Disfruta de nuestras ricas pupusas',
              style: TextStyle(
                  fontSize: 18, // Tamaño de fuente personalizado
                  fontWeight: FontWeight.bold,
                  color: Colors.white // Texto en negrita
                  ),
            ),
          ),
          if (showList)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(5),
                itemCount: pupusas.length,
                itemBuilder: (context, index) {
                  final producto = pupusas[index];
                  return Card(
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 100.0, // Ajusta el alto según tus necesidades
                          child: Image.network(
                            producto.imagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                        ListTile(
                          shape: const RoundedRectangleBorder(
                            // Establece un radio específico para los bordes
                            side: BorderSide(
                                color: Colors.black,
                                width: 0.7), // Establece un borde de color rojo
                          ),
                          tileColor: Colors.white,
                          title: Text(producto.nombre),
                          subtitle: Text(
                            '\$${producto.precio.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
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
                              Text(
                                productosSeleccionados
                                    .firstWhere(
                                      (item) => item.nombre == producto.nombre,
                                      orElse: () => ProductoSeleccionado(
                                          nombre: producto.nombre,
                                          precio: producto.precio),
                                    )
                                    .cantidad
                                    .toString(),
                              ),
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
                      ],
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
          const Padding(
            padding: EdgeInsets.only(top: 25, left: 25, right: 25),
            child: Divider(
              color: Colors.white,
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
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.shopping_cart,
          color: Colors.white, // Personaliza el color del ícono
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
    );
  }
}
