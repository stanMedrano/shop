import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shop/main.dart';

class FirebaseApi {
  //crear instancia de firebase messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  //funcion para inicializar notificaciones
  Future<void> initNotification() async {
    //request permission from user(will promt user)
    await _firebaseMessaging.requestPermission();

    //recuperar el token FCM para este dispositivo
    final fCMToken = await _firebaseMessaging.getToken();

    //imprimir el token (lo enviaría a su servidor)
    print('Token: $fCMToken');

    //iniciar la notificacion
    initPushNotifications();
  }

  //funcion to handle recived messages
  void handleMessage(RemoteMessage? message) {
    //si el mensaje es null no hacer nada
    if (message == null) return;

    // navegar a la pantalla de pedidos al recibir la notificacion
    navigatorKey.currentState?.pushNamed(
      '/pedido_page',
      arguments: message,
    );
  }

  //funcion to initializa background settings
  Future initPushNotifications() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
  }
}
