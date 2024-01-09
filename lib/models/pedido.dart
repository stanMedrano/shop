import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductoP {
  final String name;

  ProductoP({required this.name});

  factory ProductoP.fromJson(Map<String, dynamic> json) {
    return ProductoP(name: json['name']);
  }
}

class PedidoItemP {
  final ProductoP productop;
  final int cantidad;

  PedidoItemP({
    required this.productop,
    required this.cantidad,
  });

  factory PedidoItemP.fromJson(Map<String, dynamic> json) {
    return PedidoItemP(
      productop: ProductoP.fromJson(json['producto']),
      cantidad: json['cantidad'],
    );
  }
}

class Pedido {
  final int numero;
  final String userID;
  final String? correoUsuario;
  final DateTime fecha;
  final List<PedidoItemP> productos;
  final String estado;
  final String? opcionEntrega;
  final String direccion;
  final num telefono;
  final double total;

  Pedido({
    required this.numero,
    required this.userID,
    required this.correoUsuario,
    required this.fecha,
    required this.productos,
    required this.estado,
    required this.opcionEntrega,
    required this.direccion,
    required this.telefono,
    required this.total,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      numero: json['numero'],
      userID: json['userID'],
      correoUsuario: json['correoUsuario'],
      fecha: json['fecha'].toDate(),
      productos: (json['productos'] as List)
          .map((item) => PedidoItemP.fromJson(item))
          .toList(),
      estado: json['estado'],
      opcionEntrega: json['opcionEntrega'],
      direccion: json['direccion'],
      telefono: json['telefono'],
      total: json['total'],
    );
  }
}

Future<void> agregarPedidoAFirebase(Pedido pedido) async {
  final firestore = FirebaseFirestore.instance;

  final pedidoMap = {
    'numero': pedido.numero,
    'userID': pedido.userID,
    'correoUsuario': pedido.correoUsuario,
    'fecha': pedido.fecha,
    'productos': pedido.productos.map((item) {
      return {
        'nombre': item.productop.name,
        'cantidad': item.cantidad,
      };
    }).toList(),
    'estado': pedido.estado,
    'opcionEntrega': pedido.opcionEntrega,
    'direccion': pedido.direccion,
    'telefono': pedido.telefono,
    'total': pedido.total,
  };
  await firestore.collection('pedidos').add(pedidoMap);
}

Future<List<Pedido>> obtenerPedidosDeUsuarioDesdeFirebase() async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  if (user == null) {
    return [];
  }

  final userID = user.uid;

  final firestore = FirebaseFirestore.instance;
  final pedidosCollection = firestore.collection('pedidos');

  final querySnapshot =
      await pedidosCollection.where('userID', isEqualTo: userID).get();

  return querySnapshot.docs.map((doc) {
    final data = doc.data();
    final pedido = Pedido(
      numero: data['numero'],
      userID: data['userID'],
      correoUsuario: data['correoUsuario'],
      fecha: data['fecha'].toDate(),
      productos: (data['productos'] as List).map((item) {
        return PedidoItemP(
          productop: ProductoP(name: item['nombre']),
          cantidad: item['cantidad'],
        );
      }).toList(),
      estado: data['estado'],
      opcionEntrega: data['opcionEntrega'],
      direccion: data['direccion'],
      telefono: data['telefono'],
      total: data['total'],
    );
    return pedido;
  }).toList();
}
