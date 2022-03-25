import 'package:flutter/material.dart';
import 'package:push_notification_full_flutter/screen_second.dart';
import 'local_notify_manager.dart';

class TestNotifyScreen extends StatefulWidget {
  const TestNotifyScreen({Key? key}) : super(key: key);
  @override
  _TestNotifyScreenState createState() => _TestNotifyScreenState();
}

class _TestNotifyScreenState extends State<TestNotifyScreen> {
  @override
  void initState() {
   // LocalNotifyManager.init();
    // TODO: implement initState
    super.initState();
    localNotifyManager.setOnNotificationReceive(onNotificationReceive);
    localNotifyManager.setOnNotificationClick(onNotificationClick);
  }
  onNotificationReceive(ReceiveNotification notification){
    print('Noticati ${notification.id}');
  }
  onNotificationClick(String playload){
    Navigator.push(context, MaterialPageRoute(builder: (context) => SecondPage(payload: playload)));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Notifications'),
      ),
      body: Center(
        child: FlatButton(
          onPressed: () async{
            await localNotifyManager.showNotification();
          //  await localNotifyManager.scheduleNotification();
            //await localNotifyManager.repeatNotification();
           //await localNotifyManager.showDailyAtTimeNotification();
          //  await localNotifyManager.showWeeklyArDayTimeAtTimeNotification();
           print(DateTime.now());
          },
          child: const Text('Send Notification'),
        ),
      ),
    );
  }
}
