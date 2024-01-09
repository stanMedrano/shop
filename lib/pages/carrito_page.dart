import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/CarritoModel.dart';
import 'package:shop/models/pedido.dart';

class CarritoScreen extends StatefulWidget {
  const CarritoScreen({super.key});

  @override
  State<CarritoScreen> createState() => _CarritoScreenState();
}

Future<void> myAsyncFunction(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('¡Gracias por su compra!'),
        content: const Text('Su pedido se ha registrado con éxito.'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cerrar'),
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el diálogo
            },
          ),
        ],
      );
    },
  );
}

//Error debe seleccionar Opcion de entrega
void showAlertDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Aceptar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

bool validarTelefonoSalvadoreno(String telefono) {
  // verifica si el número tiene 8 dígitos (ejemplo: 70001234)
  return RegExp(r'^\d{8}$').hasMatch(telefono);
}

class _CarritoScreenState extends State<CarritoScreen> {
  String? selectedDeliveryOption;
  bool showShippingForm = false;

  TextEditingController direccionController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final carritoModel = Provider.of<CarritoModel>(context,
        listen: false); // Obtén una instancia de CarritoModel
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 92, 83),
      appBar: AppBar(
        title: const Text(
          'Carrito de Compras',
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              bool confirmacion = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Cancelar Orden'),
                    content: const Text(
                        '¿Estás seguro de que deseas cancelar la orden?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancelar'),
                        onPressed: () {
                          Navigator.of(context)
                              .pop(false); // No confirma la cancelación
                        },
                      ),
                      TextButton(
                        child: const Text('Confirmar'),
                        onPressed: () {
                          Navigator.of(context)
                              .pop(true); // Confirma la cancelación
                        },
                      ),
                    ],
                  );
                },
              );

              // Si el usuario confirmó la cancelación, realiza la lógica de cancelación
              if (confirmacion == true) {
                carritoModel.limpiarCarrito();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: Consumer<CarritoModel>(
              builder: (context, carritoModel, child) {
                final carrito = carritoModel.carrito;
                return ListView.builder(
                  padding: const EdgeInsets.all(5),
                  itemCount: carrito.length,
                  itemBuilder: (context, index) {
                    final productoEnCarrito = carrito[index];
                    return ListTile(
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        // Personaliza los bordes
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(color: Colors.black, width: 0.7),
                      ),
                      title: Text(productoEnCarrito.producto.nombre),
                      subtitle: Text(
                          '\$ ${productoEnCarrito.producto.precio.toStringAsFixed(2)}  -  Cantidad: ${productoEnCarrito.cantidad}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              if (productoEnCarrito.cantidad > 1) {
                                carritoModel
                                    .quitarDelCarrito(productoEnCarrito);
                              } else {
                                // Opcional: Puedes confirmar la eliminación con un cuadro de diálogo
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                          'Eliminar producto del carrito'),
                                      content: const Text(
                                          '¿Seguro que deseas eliminar este producto del carrito?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Cancelar'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Eliminar'),
                                          onPressed: () {
                                            carritoModel.eliminarDelCarrito(
                                                productoEnCarrito);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                          ),
                          Text(productoEnCarrito.cantidad.toString()),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              carritoModel.incrementarCantidadEnCarrito(
                                  productoEnCarrito);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton<String>(
                      value: selectedDeliveryOption,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedDeliveryOption = newValue;
                          if (newValue == 'A Domicilio') {
                            showShippingForm = true;
                          } else {
                            showShippingForm = false;
                          }
                        });
                      },
                      items: <String>['En local', 'Para Llevar', 'A Domicilio']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      underline: Container(
                        height: 1,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Elige una opción de entrega',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                if (showShippingForm && selectedDeliveryOption == 'A Domicilio')
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: direccionController,
                          decoration: const InputDecoration(
                            labelText: 'Dirección',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: telefonoController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Número de Teléfono',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black12,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Consumer<CarritoModel>(
                builder: (context, carritoModel, child) {
                  final total = carritoModel.calcularTotal();
                  return Text(
                    'Total: \$ ${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.white),
                  );
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (selectedDeliveryOption != null) {
// Obtén una referencia al documento que almacena el último número de pedido
                    final lastOrderNumberDoc = FirebaseFirestore.instance
                        .collection('config')
                        .doc('last_order');

                    // Consulta el documento para obtener el número de pedido actual
                    final lastOrderSnapshot = await lastOrderNumberDoc.get();

                    if (lastOrderSnapshot.exists) {
                      // El documento existe, obtén el número actual y aumenta en 1
                      final currentOrderNumber =
                          lastOrderSnapshot['number'] as int;
                      final newOrderNumber = currentOrderNumber + 1;

                      // Actualiza el documento con el nuevo número
                      await lastOrderNumberDoc
                          .update({'number': newOrderNumber});

                      // Ahora, puedes usar 'newOrderNumber' como el número de pedido para el nuevo pedido que estás a punto de agregar
                      final userID = FirebaseAuth.instance.currentUser?.uid;
                      final user = FirebaseAuth.instance.currentUser;
                      if (userID != null && user != null) {
                        final productosEnCarrito = carritoModel.carrito;
                        final correoUsuario = user.email;
                        String direccion = 'No se necesita';
                        String telefono = '00000000';
                        double costoAdicionalEnvio = 1.50;
                        if (selectedDeliveryOption == 'A Domicilio') {
                          direccion = direccionController.text;
                          telefono = telefonoController.text;
                          bool telefonoValido =
                              validarTelefonoSalvadoreno(telefono);
                          if (!telefonoValido) {
                            // Muestra un mensaje de error si el número de teléfono no es válido
                            // ignore: use_build_context_synchronously
                            showAlertDialog(context, 'Error',
                                'Ingresa un número de teléfono salvadoreño válido de 9 digitos.');
                            return;
                          }
                        }
                        // Calcula el total de la compra
                        double total = carritoModel.calcularTotal();

                        // Calcula el total con el cargo adicional si es entrega a domicilio
                        double totalConCargoAdicional = total;
                        if (selectedDeliveryOption == 'A Domicilio') {
                          totalConCargoAdicional += costoAdicionalEnvio;
                        }

                        // Crea el nuevo pedido con el número incrementado
                        final nuevoPedido = Pedido(
                          numero: newOrderNumber,
                          userID: userID,
                          correoUsuario: correoUsuario,
                          fecha: DateTime.now(),
                          productos:
                              productosEnCarrito.map((productoEnCarrito) {
                            return PedidoItemP(
                              productop: ProductoP(
                                  name: productoEnCarrito.producto.nombre),
                              cantidad: productoEnCarrito.cantidad,
                            );
                          }).toList(),
                          estado: 'Pendiente',
                          opcionEntrega: selectedDeliveryOption,
                          direccion: direccion, // Agregar dirección al Pedido
                          telefono: int.parse(telefono),
                          total: totalConCargoAdicional,
                        );

                        // Agrega el nuevo pedido a Firestore
                        await agregarPedidoAFirebase(nuevoPedido);

                        // Limpia el carrito después de agregar el pedido
                        carritoModel.limpiarCarrito();
                        // Llama a la función para mostrar la alerta de éxito
                        await myAsyncFunction(context);
                      }
                      if (mounted) Navigator.pop(context);
                      // Cierra la pantalla actual y muestra un mensaje de éxito o realiza otra acción según tus necesidades
                    } else {
                      // Muestra un mensaje de error si no se ha seleccionado una opción de entrega
                    }
                  } else {
                    // En algún lugar de tu código...
                    showAlertDialog(context, 'Error',
                        'Debes seleccionar una opción de entrega antes de continuar.');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: const Text(
                  'Finalizar Compra',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
