part of 'notification_dispatcher.dart';

/// The class used to store a notification's payload.
final class NotificationMessage {
  const NotificationMessage._({
    required this.sender,
    required this.info,
  });

  /// The sender posting the notification
  final Object? sender;

  /// The info being posted with the notification.
  final Map<String, dynamic>? info;
}
