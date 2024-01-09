import 'package:cloud_firestore/cloud_firestore.dart';

class Pedido {
  final String id;
  String estado;
  final DateTime fecha;
  final int numero;
  final List<PedidoItem> productos;
  final String userID;
  final String correoUsuario;
  final String direccion;
  final int telefono;
  final String? opcionEntrega;

  Pedido({
    required this.id,
    required this.estado,
    required this.fecha,
    required this.numero,
    required this.productos,
    required this.userID,
    required this.correoUsuario,
    required this.direccion,
    required this.telefono,
    required this.opcionEntrega,
  });
}

class PedidoItem {
  final String nombre;
  final int cantidad;

  PedidoItem({required this.nombre, required this.cantidad});
}

final firestore = FirebaseFirestore.instance;

Future<List<Pedido>> obtenerPedidosDesdeFirebase() async {
  try {
    final querySnapshot = await firestore.collection('pedidos').get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      final productos = (data['productos'] as List<dynamic>)
          .map((producto) => PedidoItem(
                nombre: producto['nombre'],
                cantidad: producto['cantidad'],
              ))
          .toList();

      return Pedido(
        id: doc.id,
        estado: data['estado'],
        fecha: (data['fecha'] as Timestamp).toDate(),
        numero: data['numero'],
        productos: productos,
        userID: data['userID'],
        correoUsuario: data['correoUsuario'],
        direccion: data['direccion'],
        telefono: data['telefono'],
        opcionEntrega: data['opcionEntrega'],
      );
    }).toList();
  } catch (error) {
    print('Error al obtener pedidos desde Firebase: $error');
    return [];
  }
}

Future<void> actualizarEstadoPedido(String pedidoID, String nuevoEstado) async {
  try {
    await firestore
        .collection('pedidos')
        .doc(pedidoID)
        .update({'estado': nuevoEstado});
  } catch (error) {
    print('Error al actualizar el estado del pedido: $error');
  }
}
