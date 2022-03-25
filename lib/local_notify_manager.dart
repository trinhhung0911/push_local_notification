import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;
import 'package:rxdart/rxdart.dart';


class LocalNotifyManager {

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  var initSetting;
  BehaviorSubject<ReceiveNotification> get didReceiveNotificationSubject=>
      BehaviorSubject<ReceiveNotification>();
  LocalNotifyManager.init()  {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      requestIOSPermission();
    }
    initializePlatform();
  }
  requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }
  initializePlatform() {
    var initSettingAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var inttSetingIOS = IOSInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        onDidReceiveLocalNotification: (id, title, body, payload) async {
          ReceiveNotification notification = ReceiveNotification(
              id: id, title: title, body: body, payload: payload);
          didReceiveNotificationSubject.add(notification);
        },

        );
    initSetting = InitializationSettings(android: initSettingAndroid, iOS: inttSetingIOS);
  }
  setOnNotificationReceive(Function onNotificationReceive){
    didReceiveNotificationSubject.listen((notification) {
      onNotificationReceive(notification);
    });
  }
  setOnNotificationClick(Function onNotificationClick ) async{
    await flutterLocalNotificationsPlugin.initialize(initSetting,
      onSelectNotification:(playload ) async{
      onNotificationClick(playload);
    }
    );
  }
//Show bình thường
  Future<void> showNotification() async{
    var androidChannel=const AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      'CHANNEL_DESCRIPTION',
      importance: Importance.max,
      playSound: true,
      priority: Priority.high,
      // icon: 'icon_notification_replace',
      // largeIcon: DrawableResourceAndroidBitmap('icon_large_notification'),
      timeoutAfter: 9000,
      enableLights: true,
    );
    var iosChannel=const IOSNotificationDetails();
    var platformChannel=NotificationDetails(android: androidChannel,iOS: iosChannel);
    await flutterLocalNotificationsPlugin.show(0, 'Test Title', 'Test Body',platformChannel , payload: 'New Payload' );
  }
  //show sau 1 khoảng thười gian
  Future<void> scheduleNotification() async{
    var scheduleNotificationDateTime =DateTime.now().add(Duration(seconds: 5));
    var androidChannel=const AndroidNotificationDetails(
      'CHANNEL_ID 1',
      'CHANNEL_NAME 1',
      'CHANNEL_DESCRIPTION 1',
      importance: Importance.max,
      playSound: true,
      priority: Priority.high,
      // icon: 'icon_notification_replace',
      // largeIcon: DrawableResourceAndroidBitmap('icon_large_notification'),
      timeoutAfter: 9000,
      enableLights: true,
    );
    var iosChannel=const IOSNotificationDetails();
    var platformChannel=NotificationDetails(android: androidChannel,iOS: iosChannel);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'Schedule Test Title',
        'Schedule Test Body',
        scheduleNotificationDateTime,
        platformChannel,
        payload: 'New Payload');
  }
  //show lặp lại theo 1 khoảng thời gian
  Future<void> repeatNotification() async{
    var androidChannel=const AndroidNotificationDetails(
      'CHANNEL_ID 2',
      'CHANNEL_NAME 2',
      'CHANNEL_DESCRIPTION 2',
      importance: Importance.max,
      playSound: true,
      priority: Priority.high,
      // icon: 'icon_notification_replace',
      // largeIcon: DrawableResourceAndroidBitmap('icon_large_notification'),
      timeoutAfter: 5000,
      enableLights: true,
    );
    var iosChannel=const IOSNotificationDetails();
    var platformChannel=NotificationDetails(android: androidChannel,iOS: iosChannel);
    await flutterLocalNotificationsPlugin.periodicallyShow(
        0,
        'Repeat Title',
        'Repeat Test Body',
        RepeatInterval.everyMinute,
        platformChannel,
        payload: 'New Payload' );
  }
  //đến thời gian thì show
  Future<void> showDailyAtTimeNotification() async{
    var time =const Time(6,30,0);
    var androidChannel=const AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      'CHANNEL_DESCRIPTION',
      importance: Importance.max,
      playSound: true,
      priority: Priority.high,
      // icon: 'icon_notification_replace',
      // largeIcon: DrawableResourceAndroidBitmap('icon_large_notification'),
      timeoutAfter: 5000,
      enableLights: true,
    );
    var iosChannel=const IOSNotificationDetails();
    var platformChannel=NotificationDetails(android: androidChannel,iOS: iosChannel);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
         0,
        'Daily Test Title ${time.hour}-${time.minute}-${time.second}',
        'Daily Test Body',
        time,
        platformChannel,
        payload: 'New Payload'  );
  }
  //show theo tuần
  Future<void> showWeeklyArDayTimeAtTimeNotification() async{
    var time =Time(6,33,0);
    var androidChannel=const AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      'CHANNEL_DESCRIPTION',
      importance: Importance.max,
      playSound: true,
      priority: Priority.high,
      // icon: 'icon_notification_replace',
      // largeIcon: DrawableResourceAndroidBitmap('icon_large_notification'),
      timeoutAfter: 5000,
      enableLights: true,
    );
    var iosChannel=const IOSNotificationDetails();
    var platformChannel=NotificationDetails(android: androidChannel,iOS: iosChannel);
    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        0,
        'Weekly Daily Test Title ${time.hour}-${time.minute}-${time.second}',
        'Weekly Daily Test Body',
        Day.friday,
        time,
        platformChannel,
        payload: 'New Payload'  );
  }
  //cancle
  Future<void> cancelNotification(int id) async{
    await flutterLocalNotificationsPlugin.cancel(id);
  }
  //cancle all
  Future<void> cancelAllNotification() async{
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}


LocalNotifyManager localNotifyManager=LocalNotifyManager.init();
class ReceiveNotification {
  int? id;
  String? title;
  String? body;
  String? payload;

  ReceiveNotification(
      {required this.id,
      required this.title,
      required this.body,
      required this.payload});
}
