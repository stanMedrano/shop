class ProductoSeleccionado {
  final String nombre;
  final num precio;
  int cantidad;

  ProductoSeleccionado({
    required this.nombre,
    required this.precio,
    this.cantidad = 0,
  });
}

class ProductoEnCarrito {
  final ProductoSeleccionado producto;
  int cantidad;

  ProductoEnCarrito({required this.producto, this.cantidad = 0});
}
