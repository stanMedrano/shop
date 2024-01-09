import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shop/models/menu.dart';

import 'package:shop/services/firebase_service.dart';

class AgregarProductoScreen extends StatefulWidget {
  const AgregarProductoScreen({super.key});

  @override
  _AgregarProductoScreenState createState() => _AgregarProductoScreenState();
}

// Método para cerrar sesión del usuario
void signUserOut() {
  FirebaseAuth.instance.signOut();
}

class _AgregarProductoScreenState extends State<AgregarProductoScreen> {
  Future<void> _cargarImagen() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void limpiarFormulario() {
    setState(() {
      _nombre = '';
      _precio = 0.0;
      _descripcion = '';
      _categoria = '';
      _disponible = false;
      _selectedImage = null;
    });
  }

  final _formKey = GlobalKey<FormState>();
  String _nombre = '';
  double _precio = 0.0;
  String _descripcion = '';
  String _categoria = '';
  bool _disponible = false;
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Producto'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Nombre'),
                      onChanged: (value) {
                        setState(() {
                          _nombre = value;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Precio'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          _precio = double.tryParse(value) ?? 0.0;
                        });
                      },
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Descripción'),
                      onChanged: (value) {
                        setState(() {
                          _descripcion = value;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Categoría'),
                      onChanged: (value) {
                        setState(() {
                          _categoria = value;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('Disponible'),
                      value: _disponible,
                      onChanged: (value) {
                        setState(() {
                          _disponible = value!;
                        });
                      },
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                      ),
                      onPressed: () async {
                        await _cargarImagen();
                      },
                      child: const Text('Cargar Imagen'),
                    ),
                    if (_selectedImage != null)
                      Image.file(
                        _selectedImage!,
                        height: 100,
                      ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final imageURL = await _subirImagenAFirebaseStorage();
                          if (imageURL != null) {
                            final nuevoProducto = Producto(
                              nombre: _nombre,
                              precio: _precio,
                              descripcion: _descripcion,
                              categoria: _categoria,
                              disponible: _disponible,
                              imagePath: imageURL,
                            );
                            await agregarProducto(nuevoProducto);
                            // Limpia el formulario después de agregar el producto
                            limpiarFormulario();
                          }
                        }
                      },
                      child: const Text('Agregar Producto'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _subirImagenAFirebaseStorage() async {
    if (_selectedImage == null) return null;

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('imagenes/${DateTime.now().millisecondsSinceEpoch.toString()}');
    final uploadTask = storageRef.putFile(_selectedImage!);

    await uploadTask
        .whenComplete(() => print('Imagen subida a Firebase Storage'));

    return await storageRef.getDownloadURL();
  }
}
