class Producto {
  final String nombre;
  final num precio;
  final String descripcion;
  final String categoria;
  final bool disponible;
  final String imagePath;

  Producto({
    required this.nombre,
    required this.precio,
    required this.descripcion,
    required this.categoria,
    required this.disponible,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'precio': precio,
      'categoria': categoria,
      'descripcion': descripcion,
      'disponible': disponible,
      'imagePath': imagePath,
    };
  }
}
