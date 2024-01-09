import 'package:flutter/material.dart';
import 'package:shop/models/pedido.dart'; // Importa tus modelos aquí
import 'package:intl/intl.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PedidoPage extends StatefulWidget {
  const PedidoPage({Key? key}) : super(key: key);

  @override
  State<PedidoPage> createState() => _PedidoPageState();
}

class _PedidoPageState extends State<PedidoPage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _initNotificationHandling();
  }

  void _initNotificationHandling() {
    _firebaseMessaging.requestPermission();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _showNotificationDialog(message);
    });
  }

  Future<void> _showNotificationDialog(RemoteMessage message) async {
    // Verifica si el widget todavía está montado antes de mostrar el diálogo
    if (!mounted) {
      return;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text(' ${message.notification?.title ?? ''}')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(child: Text(' ${message.notification?.body ?? ''}')),
                // Puedes agregar más detalles de la notificación aquí
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 92, 83),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15.0),
            child: const Text(
              'Tus pedidos',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Pedido>>(
              future: obtenerPedidosDeUsuarioDesdeFirebase(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text(
                    'No hay pedidos...',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  );
                } else {
                  final pedidos = snapshot.data!;

                  return ListView.builder(
                    itemCount: pedidos.length,
                    itemBuilder: (context, index) {
                      final pedido = pedidos[index];

                      final formattedDate = DateFormat('dd/MM/yyyy HH:mm:ss')
                          .format(pedido.fecha);
                      final estado = pedido.estado;
                      final total = pedido.total;

                      return ListTile(
                        tileColor: Colors.white,
                        title: Text(
                          'Pedido ${pedido.numero}',
                          textAlign: TextAlign.center,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Fecha y Hora: $formattedDate',
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'Estado: $estado',
                              style: TextStyle(
                                fontSize: 15,
                                color: pedido.estado == 'Pendiente'
                                    ? Colors.red
                                    : (pedido.estado == 'Listo'
                                        ? const Color.fromARGB(255, 38, 144, 42)
                                        : Colors.deepPurple),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Total: $total',
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                            const Text(
                              'Productos del Pedido:',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: pedido.productos.map((item) {
                                final nombreProducto = item.productop.name;
                                final cantidad = item.cantidad;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Producto: $nombreProducto - Cantidad: $cantidad',
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                            const Divider(
                              color: Colors.black38,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
