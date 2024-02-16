import 'package:flutter/material.dart';
import 'package:openapi/api.dart';

enum AppUiModes { dark, light }


ValueNotifier<User> profile = ValueNotifier(User());
ValueNotifier<bool> userLoggedIn = ValueNotifier(false);
ValueNotifier<bool> isFirstLaunch = ValueNotifier(true);
ValueNotifier<AppUiModes> uiMode = ValueNotifier(AppUiModes.light);
// ValueNotifier<List<AppNotification>> notifications = ValueNotifier([]);
