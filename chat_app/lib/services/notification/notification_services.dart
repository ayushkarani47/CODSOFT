import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationServices {
  //create an instance of FirebaseMessaging
  final _firebaseMessaging = FirebaseMessaging.instance;

//initialize the notification settings
  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission: ${settings.authorizationStatus}');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print(
          'User granted provisional permission: ${settings.authorizationStatus}');
    } else {
      print('User declined or has not accepted permission');
    }

    final fCMToken = await _firebaseMessaging.getToken();
    print('FirebaseMessaging token: $fCMToken');
    print('User granted permission: ${settings.authorizationStatus}');
  }

  Future<String> getDeviceToken() async {

    final String? token = await _firebaseMessaging.getToken();
    return token!;
    
  }

  void isTokenRefreshed()async {
    _firebaseMessaging.onTokenRefresh.listen((event) {
      print('Token Refreshed: $event');
    });
  }
}
