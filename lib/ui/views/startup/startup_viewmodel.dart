import 'dart:convert';

import 'package:kenmack/app/app.router.dart';
import 'package:openapi/api.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../core/utils/local_store_dir.dart';
import '../../../core/utils/local_stotage.dart';
import '../../../state.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    await Future.delayed(const Duration(seconds: 3));


    String? token = await locator<LocalStorage>().fetch(LocalStorageDir.authToken);
    User? user = await locator<LocalStorage>().fetch(LocalStorageDir.authUser);
    bool? onboarded = await locator<LocalStorage>().fetch(LocalStorageDir.onboarded);

    if (onboarded == null || onboarded == false) {
      _navigationService.replaceWithOnboardingView();
    } else {
      if (token != null && user != null) {
        userLoggedIn.value = true;
        profile.value = user;
        _navigationService.replaceWithHomeView();
      }else{
        if(user != null){
          profile.value = user;}
        _navigationService.replaceWithLoginView();

      }


    }
  }
}
