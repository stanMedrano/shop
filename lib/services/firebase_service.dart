import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop/models/menu.dart';

Future<List<Producto>> obtenerProductosDesdeFirebase() async {
  // Accede a la instancia de Firestore
  final firestore = FirebaseFirestore.instance;

  try {
    // Recupera la colección "productos" desde Firestore
    final querySnapshot = await firestore.collection('productos').get();

    // Convierte los documentos en objetos Producto
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return Producto(
        nombre: data['nombre'],
        precio: data['precio'],
        descripcion: data['descripcion'],
        categoria: data['categoria'],
        disponible: data['disponible'],
        imagePath: data['imagePath'],
      );
    }).toList();
  } catch (error) {
    // Manejar cualquier error, como problemas de conexión
    print('Error al obtener productos desde Firebase: $error');
    return [];
  }
}

Future<List<Producto>> obtenerProductosPorCategoria(String categoria) async {
  final firestore = FirebaseFirestore.instance;

  try {
    final querySnapshot = await firestore
        .collection('productos')
        .where('categoria', isEqualTo: categoria)
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return Producto(
        nombre: data['nombre'],
        precio: data['precio'],
        descripcion: data['descripcion'],
        categoria: data['categoria'],
        disponible: data['disponible'],
        imagePath: data['imagePath'],
      );
    }).toList();
  } catch (error) {
    print('Error al obtener productos por categoría: $error');
    return [];
  }
}

Future<void> agregarProducto(Producto nuevoProducto) async {
  try {
    await FirebaseFirestore.instance
        .collection('productos')
        .add(nuevoProducto.toMap());
    print('Nuevo producto agregado');
  } catch (e) {
    print('Error al agregar el producto: $e');
  }
}
