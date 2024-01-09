
import 'package:shop/models/CarritoModel.dart';
import 'package:shop/models/carrito.dart';
import 'package:shop/models/menu.dart';
import 'package:shop/services/firebase_service.dart';

class PupusasController {
  Future<List<Producto>> obtenerProductosPupusas() async {
    return await obtenerProductosPorCategoria('Pupusas');
  }

  void agregarProductoSeleccionado(ProductoSeleccionado producto, List<ProductoSeleccionado> productosSeleccionados) {
    final productoExistente = productosSeleccionados.firstWhere(
      (item) => item.nombre == producto.nombre,
      orElse: () => ProductoSeleccionado(
        nombre: producto.nombre,
        precio: producto.precio,
      ),
    );
    productoExistente.cantidad++;
    if (!productosSeleccionados.contains(productoExistente)) {
      productosSeleccionados.add(productoExistente);
    }
  }

  void quitarProductoSeleccionado(ProductoSeleccionado producto, List<ProductoSeleccionado> productosSeleccionados) {
    final productoExistente = productosSeleccionados.firstWhere(
      (item) => item.nombre == producto.nombre,
      orElse: () => ProductoSeleccionado(
        nombre: producto.nombre,
        precio: producto.precio,
      ),
    );

    if (productoExistente.cantidad > 0) {
      productoExistente.cantidad--;
    }

    if (productoExistente.cantidad == 0) {
      productosSeleccionados.remove(productoExistente);
    }
  }

  void agregarProductosAlCarrito(List<ProductoSeleccionado> productosSeleccionados, CarritoModel carritoModel) {
    for (var producto in productosSeleccionados) {
      carritoModel.agregarAlCarrito(ProductoEnCarrito(
        producto: producto,
        cantidad: producto.cantidad,
      ));
    }
  }
}
