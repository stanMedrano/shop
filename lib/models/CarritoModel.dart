import 'package:flutter/foundation.dart';
import 'package:shop/models/carrito.dart';

class CarritoModel extends ChangeNotifier {
  List<ProductoEnCarrito> carrito = [];

  // Método para limpiar el carrito
  void limpiarCarrito() {
    carrito.clear();
    notifyListeners();
  }

  void agregarAlCarrito(ProductoEnCarrito producto) {
    carrito.add(producto);
    notifyListeners(); // Notifica a los widgets que el estado ha cambiado
  }

  void quitarDelCarrito(ProductoEnCarrito producto) {
    final productoEnCarrito = carrito.firstWhere(
      (item) => item.producto.nombre == producto.producto.nombre,
      orElse: () => ProductoEnCarrito(
        producto: ProductoSeleccionado(nombre: 'prueba', precio: 0),
        cantidad: 0,
      ),
    );

    if (productoEnCarrito.cantidad > 1) {
      productoEnCarrito.cantidad--;
    } else {
      carrito.remove(productoEnCarrito);
    }
    notifyListeners();
  }

  void eliminarDelCarrito(ProductoEnCarrito producto) {
    final productoEnCarrito = carrito.firstWhere(
      (item) => item.producto.nombre == producto.producto.nombre,
      orElse: () => ProductoEnCarrito(
        producto: ProductoSeleccionado(nombre: 'prueba2', precio: 0),
        cantidad: 0,
      ),
    );

    carrito.remove(productoEnCarrito);
    notifyListeners();
  }

  void incrementarCantidadEnCarrito(ProductoEnCarrito producto) {
    final productoEnCarrito = carrito.firstWhere(
      (item) => item.producto.nombre == producto.producto.nombre,
      orElse: () => ProductoEnCarrito(
        producto: producto.producto,
        cantidad: 0,
      ),
    );

    productoEnCarrito.cantidad++;
    notifyListeners(); // Notifica a los widgets que el estado ha cambiado
  }

  double calcularTotal() {
    double total = 0.0;
    for (final productoEnCarrito in carrito) {
      total += productoEnCarrito.producto.precio * productoEnCarrito.cantidad;
    }
    return total;
  }
}
