import 'dart:convert';


import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:kenmack/core/network/loggingApiClient.dart';
import 'package:openapi/api.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../app/app.router.dart';
import '../../../core/network/api_manager.dart';
import '../../../core/utils/local_store_dir.dart';
import '../../../core/utils/local_stotage.dart';
import '../../../state.dart';
import '../../../utils/success_page.dart';

enum RegistrationResult { success, failure }
class AuthViewModel extends BaseViewModel {
  final log = getLogger("AuthViewModel");
  final snackBar = locator<SnackbarService>();

  final ApiManager _apiManager = ApiManager(locator<LoggingApiClient>());
  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final genderController = TextEditingController();
  String? selectedGender;
  late String phoneValue = "";
  late PhoneNumber phoneNumber;
  late String countryId = "";
  final password = TextEditingController();
  final cPassword = TextEditingController();
  bool obscure = true;
  bool terms = false;
  bool remember = false;
  List<Profession> professions = [];
  int? selectedProfessionId;


  init() async {
    bool rem = await locator<LocalStorage>().fetch(LocalStorageDir.remember);
    String? lastEmail = await locator<LocalStorage>().fetch(LocalStorageDir.lastEmail);
    String? token = await locator<LocalStorage>().fetch(LocalStorageDir.authToken);
    remember = rem;
    if (remember && token != null && JwtDecoder.isExpired(token)) {
        userLoggedIn.value = true;
        UserPOJO? userJson = await locator<LocalStorage>().fetch(LocalStorageDir.authUser);
        if (userJson != null) {
          profile.value = userJson;
        }
        locator<NavigationService>().clearStackAndShow(Routes.homeView);
        return;
    }

    if( token != null && !JwtDecoder.isExpired(token)){
      await locator<LocalStorage>().delete(LocalStorageDir.authToken);
      userLoggedIn.value = false;
      locator<NavigationService>().clearStackAndShow(Routes.loginView);
    }

    if (remember) {
      String? lastEmail = await locator<LocalStorage>().fetch(LocalStorageDir.lastEmail);
      if (lastEmail != null) {
        email.text = lastEmail;
      }
    }

    rebuildUi();
  }

  void toggleRemember() {
    remember = !remember;
    rebuildUi();
  }

  void toggleObscure() {
    obscure = !obscure;
    rebuildUi();
  }

  void toggleTerms() {
    terms = !terms;
    rebuildUi();
  }

  void login() async {
    setBusy(true);

    var loginRequest = LoginRequestDTO(username: email.text, password: password.text);
    log.i('Attempting to login with: ${loginRequest.toJson()}');

    try {
      // Using ApiManager to perform the API call now
      var response = await _apiManager.performApiCall<GlobalResponseDtoUserDataPojo?>(
        apiCall: () => UserControllerApi(_apiManager.apiClient).login(loginRequest),
        endpoint: 'login'
      );
      if (response != null && response.success) {
        userLoggedIn.value = true;
        profile.value = response.data?.user;
        print('user value is ${response.data?.user}');
        String token = response.data?.accessToken ?? "";
        String refreshToken = response.data?.refreshToken ?? "";

        String userJson = jsonEncode(response.data?.user.toJson());
        await locator<LocalStorage>().save(LocalStorageDir.authUser, userJson);

        await locator<LocalStorage>().save(LocalStorageDir.authToken, token);
        await locator<LocalStorage>().save(LocalStorageDir.authUser, userJson);
        await locator<LocalStorage>().save(LocalStorageDir.authRefreshToken, refreshToken);
        locator<LocalStorage>().save(LocalStorageDir.remember, remember);
        if (remember) {
          locator<LocalStorage>().save(LocalStorageDir.lastEmail, email.text);
        } else {
          locator<LocalStorage>().delete(LocalStorageDir.lastEmail);
        }

        locator<NavigationService>().clearStackAndShow(Routes.homeView);
      } else {
        snackBar.showSnackbar(message: 'Unable to login');
      }
    } catch (e) {
      log.e('Login failed: $e');
      // Here you handle errors. The ApiManager's performApiCall method should internally handle specific cases like showing a modal on session end.
      snackBar.showSnackbar(message: e.toString());
    } finally {
      setBusy(false);
    }
  }


  void register() async {
    setBusy(true);

    var registrationRequest = UserRegistrationDTO(
            firstName: firstname.text,
            lastName: lastname.text,
            email: email.text,
            phone: phone.text,
            password: password.text,
            professionId: selectedProfessionId,
          );

    log.i('Attempting to register with: ${registrationRequest.toJson()}');

    try {

      var response = await _apiManager.performApiCall(
          apiCall: () => UserControllerApi(_apiManager.apiClient).registerUser(registrationRequest),
          endpoint: 'register'
      );

      print('value of reg response is : $response');

      if (response != null && response.success) {
        locator<NavigationService>().navigatorKey?.currentState?.pushReplacement(
            MaterialPageRoute(
              builder: (context) => SuccessPage(
                title: "Congratulations!",
                description: "Your account is ready!",
                callback: () {
                  locator<NavigationService>().clearStackAndShow(Routes.loginView);
                },
              ),
            )
        );
      } else {
        snackBar.showSnackbar(message: 'Unable to signup');
      }
    } catch (e) {
      log.e('signup failed: ${e}');
      if(e.toString().contains('Could not find a suitable class for deserialization')){
        print('controlled deserialize temporary');
        locator<NavigationService>().navigatorKey?.currentState?.pushReplacement(
            MaterialPageRoute(
              builder: (context) => SuccessPage(
                title: "Congratulations!",
                description: "Your account is ready!",
                callback: () {
                  locator<NavigationService>().clearStackAndShow(Routes.loginView);
                },
              ),
            )
        );
      }

    } finally {
      setBusy(false);
    }
  }


}
