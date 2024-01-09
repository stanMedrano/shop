import 'package:flutter/material.dart';
import 'package:shop/models/pedido_restaurante.dart';

class RestauranteScreen extends StatefulWidget {
  const RestauranteScreen({super.key});

  @override
  _RestauranteScreenState createState() => _RestauranteScreenState();
}

class _RestauranteScreenState extends State<RestauranteScreen> {
  List<Pedido> listaDePedidos = [];
  Pedido? pedidoSeleccionado;

  @override
  void initState() {
    super.initState();
    cargarPedidos();
  }

  void cargarPedidos() async {
    final pedidos = await obtenerPedidosDesdeFirebase();
    setState(() {
      listaDePedidos = pedidos;
    });
  }

  Future<void> _mostrarAlertDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Pedido Listo'),
          content: const Text('El pedido ha sido marcado como completo.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext)
                    .pop(); // Cierra la alerta usando el contexto del AlertDialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gestión de Pedidos',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            'Pedidos Pendientes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            flex: 3,
            child: listaDePedidos.isEmpty
                ? const Center(
                    child: Text(
                      'No hay pedidos pendientes',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: listaDePedidos.length,
                    itemBuilder: (context, index) {
                      final pedido = listaDePedidos[index];

                      return ListTile(
                        shape: const RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black26)),
                        title: Text(
                          'Pedido #${pedido.numero} - ${pedido.estado} - ${pedido.correoUsuario}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 19,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Fecha: ${pedido.fecha.toString()}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                            if (pedido.opcionEntrega != null)
                              Text(
                                'Tipo de Entrega: ${pedido.opcionEntrega}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            pedidoSeleccionado = pedido;
                          });
                        },
                      );
                    },
                  ),
          ),
          if (pedidoSeleccionado != null)
            Expanded(
              flex: 4,
              child: Container(
                color: Colors.black,
                child: Column(
                  children: [
                    Text(
                      'Productos del Pedido #${pedidoSeleccionado!.numero}:',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          color: Colors.white),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white30,
                        child: ListView.builder(
                          itemCount: pedidoSeleccionado!.productos.length,
                          itemBuilder: (context, index) {
                            final producto =
                                pedidoSeleccionado!.productos[index];
                            return ListTile(
                              title: Text(
                                producto.nombre,
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                'Cantidad: ${producto.cantidad}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              final currentContext = context;
                              // Marcar el pedido como "Listo"
                              await actualizarEstadoPedido(
                                  pedidoSeleccionado!.id, 'Listo');
                              setState(() {
                                // Actualiza el estado en la lista local
                                pedidoSeleccionado!.estado = 'Listo';
                              });

                              // Muestra una alerta
                              showDialog(
                                context: currentContext,
                                builder: (BuildContext dialogContext) {
                                  return AlertDialog(
                                    title: const Text('Pedido Listo'),
                                    content: const Text(
                                        'El pedido ha sido marcado como completo.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(dialogContext)
                                              .pop(); // Cierra la alerta usando la referencia al contexto almacenado
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 1, 82, 3)),
                            ),
                            child: const Text(
                              'Listo',
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              // Marcar el pedido como "Completo"
                              await actualizarEstadoPedido(
                                  pedidoSeleccionado!.id, 'Completo');
                              setState(() {
                                // Llamar a la función para marcar el pedido como "Listo"
                                pedidoSeleccionado!.estado = 'Completo';
                              });
                              // Muestra una alerta
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Pedido Completo'),
                                    content: const Text(
                                        'El pedido ha sido marcado como completo.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Cierra la alerta
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.black),
                            ),
                            child: const Text('Completo'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
