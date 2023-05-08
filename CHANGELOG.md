<!--
### Breaking
### Features
### Fixes
### Documenetation
### Workflow
### Tests
### Others
-->

## 0.4.0

### Breaking
- Removed support for [Equatable](https://pub.dev/packages/equatable).
- Removed support for `Future`-based callbacks.
- Removed `MockNotificationDispatcher`
- `remove` has been renamed to `removeObserverWith` with the `Object observer` parameter made positional.

### Documentation
- Updated documentation for `removeObserver` and `removeObserverWith` (previously called `remove`).

### Others

- Updated example to use Flutter.

## 0.3.2

### Fix
- Fix an issue where calling `NotificationDispatcher.post` could return earlier than intended.

### Tests
- Added tests for Future callbacks.

## 0.3.1 (retracted)

### Fix
- Fix failing tests due to `Future`s running concurrently.

## 0.3.0 (retracted)

### Features
- Allow callbacks that return a `Future`.

## 0.2.1

### Others
- Updated license.

## 0.2.0

### Features
- Added a `NotificationDispatcherEquatableObserverMixin` to ensure classes that extend [Equatable](https://pub.dev/packages/equatable) are able to be differentiated when adding/removing observers. To use, make sure the mixin's `instanceKey` is part of the class's `props` property.

### Fixes
- Fixed an issue where notifications could not be differentiated between instances of the same class if its `==` operator and `hashCode` method were overriden.

### Documentation
- Updated documentation to reflect changes.

### Tests
- Added tests for observers that extend Equatable.

### Others
- Updated pubspec description.

## 0.1.0

### Features
- `NotificationDispatcher.post` now sends along a `NotificationMessage` to the observer.

### Fixes
- Fixed an issue where notifications could not be differentiated between instances of the same class.

### Documentation
- Added documentation for all `NotificationDispatcher` methods.

### Workflow
- Added CI to run tests on commit.
- Added some linting options.

## 0.0.1

- Initial pre-release.
