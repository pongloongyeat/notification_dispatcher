/// Callback signature when receiving a notification.
typedef NotificationCallback = void Function(NotificationMessage? message);

/// The message being posted/received.
typedef NotificationMessage = Map<String, dynamic>;
