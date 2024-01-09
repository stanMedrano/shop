import 'package:flutter_test/flutter_test.dart';
import 'package:shop/models/CarritoModel.dart';
import 'package:shop/models/carrito.dart';

void main() {
  group('CarritoModel', () {
    test('Añadir producto al carrito', () {
      final carritoModel = CarritoModel();
      final producto = ProductoEnCarrito(
        producto: ProductoSeleccionado(nombre: 'Producto1', precio: 10.0),
        cantidad: 1,
      );

      carritoModel.agregarAlCarrito(producto);

      expect(carritoModel.carrito.length, 1);
      expect(carritoModel.carrito[0], producto);
    });

    test('Eliminar producto del carrito', () {
      final carritoModel = CarritoModel();
      final producto = ProductoEnCarrito(
        producto: ProductoSeleccionado(nombre: 'Producto2', precio: 15.0),
        cantidad: 2,
      );

      carritoModel.agregarAlCarrito(producto);
      carritoModel.eliminarDelCarrito(producto);

      expect(carritoModel.carrito.length, 0);
    });

    test('Incrementar cantidad en el carrito', () {
      final carritoModel = CarritoModel();
      final producto = ProductoEnCarrito(
        producto: ProductoSeleccionado(nombre: 'Producto3', precio: 20.0),
        cantidad: 1,
      );

      carritoModel.agregarAlCarrito(producto);
      carritoModel.incrementarCantidadEnCarrito(producto);

      expect(carritoModel.carrito[0].cantidad, 2);
    });

    // Puedes agregar más pruebas según tus necesidades
    test('Calcular total del carrito', () {
      final carritoModel = CarritoModel();
      final producto1 = ProductoEnCarrito(
        producto: ProductoSeleccionado(nombre: 'Producto1', precio: 10.0),
        cantidad: 2,
      );
      final producto2 = ProductoEnCarrito(
        producto: ProductoSeleccionado(nombre: 'Producto2', precio: 15.0),
        cantidad: 3,
      );

      carritoModel.agregarAlCarrito(producto1);
      carritoModel.agregarAlCarrito(producto2);

      final resultado = carritoModel.calcularTotal();

      expect(resultado, equals(10.0 * 2 + 15.0 * 3));
    });
  });
}
