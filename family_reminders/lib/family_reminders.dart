// Local notifications. Scheduling works on Android and iOS; the browser can only show one immediately.
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Loads the time zone database and sets the device's zone. Unknown zone: times fall back to UTC.
Future<void> initLocalTimezone() async {
  tzdata.initializeTimeZones();
  try {
    tz.setLocalLocation(tz.getLocation((await FlutterTimezone.getLocalTimezone()).identifier));
  } catch (_) {}
}

/// One notification.
class Notice {
  const Notice({required this.title, required this.body, this.expandedBody, this.payload, this.actions = const []});

  final String title;
  final String body;

  /// Longer text shown when the notification is expanded (Android). Defaults to [body].
  final String? expandedBody;

  /// Handed back when the notification is tapped.
  final String? payload;

  /// Buttons on the notification: (id, label). Tapping one opens the app and calls [LocalNotifier.onAction].
  final List<(String, String)> actions;
}

class LocalNotifier {
  LocalNotifier({required this.channelId, this.silent = false});

  /// Android notification channel; one per app is enough.
  final String channelId;

  /// No sound and no vibration: the notification just appears. (Android fixes this per channel when
  /// it is first created, so a silent app should use its own channel id from the start.)
  final bool silent;

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  /// Called with the payload when a notification is tapped while the app runs.
  void Function(String payload)? onOpen;

  /// Called with the payload and the button's id when a notification button is tapped.
  void Function(String payload, String action)? onAction;

  /// The button that opened the app, if it was opened from a notification button (set by [init]).
  String? launchAction;

  bool get canSchedule => !kIsWeb;

  /// Returns the payload if the app was launched by tapping a notification.
  Future<String?> init() async {
    try {
      _ready = await _plugin.initialize(
            settings: const InitializationSettings(
              android: AndroidInitializationSettings('@mipmap/ic_launcher'),
              // Permission is asked when reminders are switched on, not at launch.
              iOS: DarwinInitializationSettings(
                requestAlertPermission: false,
                requestBadgePermission: false,
                requestSoundPermission: false,
              ),
              web: WebInitializationSettings(),
            ),
            onDidReceiveNotificationResponse: (r) {
              if (r.payload == null) return;
              final action = r.actionId;
              action != null && action.isNotEmpty ? onAction?.call(r.payload!, action) : onOpen?.call(r.payload!);
            },
          ) ??
          false;
      if (!_ready || kIsWeb) return null;
      final launch = await _plugin.getNotificationAppLaunchDetails();
      if (launch?.didNotificationLaunchApp != true) return null;
      final action = launch!.notificationResponse?.actionId;
      launchAction = action != null && action.isNotEmpty ? action : null;
      return launch.notificationResponse?.payload;
    } catch (e) {
      debugPrint('Notifications unavailable: $e');
      return null;
    }
  }

  /// Asks for permission to notify. In the browser only if [web] is true.
  Future<bool> requestPermission({bool web = true}) async {
    if (!_ready || (kIsWeb && !web)) return false;
    try {
      if (kIsWeb) {
        return await _plugin.resolvePlatformSpecificImplementation<WebFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission() ?? false;
      }
      return await _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission() ??
          await _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(alert: true, sound: true) ??
          false;
    } catch (e) {
      debugPrint('Permission request failed: $e');
      return false;
    }
  }

  /// Replaces all pending reminders with [items]. [channelName] is shown in the system settings.
  Future<void> scheduleAll(List<(DateTime, Notice)> items, {required String channelName, String? lang}) async {
    if (!_ready || !canSchedule) return;
    // Pending ones only, so reminders already in the notification shade stay visible.
    await _plugin.cancelAllPendingNotifications();
    for (final (i, (at, notice)) in items.indexed) {
      await _plugin.zonedSchedule(
        id: i,
        scheduledDate: tz.TZDateTime.from(at, tz.local),
        title: notice.title,
        body: notice.body,
        payload: notice.payload,
        notificationDetails: _details(notice, channelName, lang),
        // A few minutes' leeway is fine for reminders and needs no exact-alarm permission.
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  /// Shows [notice] right away (also in the browser).
  Future<void> showNow(Notice notice, {required String channelName, String? lang}) async {
    if (!_ready) return;
    await _plugin.show(
      id: 999,
      title: notice.title,
      body: notice.body,
      payload: notice.payload,
      notificationDetails: _details(notice, channelName, lang),
    );
  }

  NotificationDetails _details(Notice notice, String channelName, String? lang) => NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          styleInformation: BigTextStyleInformation(notice.expandedBody ?? notice.body),
          importance: silent ? Importance.low : Importance.defaultImportance,
          priority: silent ? Priority.low : Priority.defaultPriority,
          playSound: !silent,
          enableVibration: !silent,
          silent: silent,
          actions: [for (final (id, label) in notice.actions) AndroidNotificationAction(id, label, showsUserInterface: true)],
        ),
        iOS: DarwinNotificationDetails(presentSound: !silent),
        web: WebNotificationDetails(lang: lang),
      );
}
