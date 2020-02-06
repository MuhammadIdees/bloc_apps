import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotifications{
  FirebaseMessaging _firebaseMessaging;

  void setUpFireBase(){
    _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.subscribeToTopic('promotion');
    // _firebaseMessaging.unsubscribeFromTopic('TopicToListen');
    firebaseCloudMessagingListner();
  }

  void firebaseCloudMessagingListner(){
    if (Platform.isIOS) iOSPermission();

    _firebaseMessaging.getToken().then((token){
      print("Registration token: $token");
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async { print('on message $message'); },
      onResume: (Map<String, dynamic> message) async { print('on resume $message'); },
      onLaunch: (Map<String, dynamic> message) async { print('on launch $message'); },
    );

  }

  void iOSPermission(){
    _firebaseMessaging.requestNotificationPermissions(
      IosNotificationSettings(sound: true, badge: true, alert: true)
    );

    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings){
      print("Settings registererd: $settings");
    });
  }
}

