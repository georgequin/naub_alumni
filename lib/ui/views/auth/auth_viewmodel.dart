import 'dart:convert';


import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:openapi/api.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../app/app.router.dart';
import '../../../app/model/repositories/repository.dart';
import '../../../core/network/api_manager.dart';
import '../../../core/network/api_response.dart';
import '../../../core/network/api_service.dart';
import '../../../core/network/handle_api_error.dart';
import '../../../core/utils/local_store_dir.dart';
import '../../../core/utils/local_stotage.dart';
import '../../../state.dart';

enum RegistrationResult { success, failure }
class AuthViewModel extends BaseViewModel {
  final log = getLogger("AuthViewModel");
  final snackBar = locator<SnackbarService>();

  final ApiManager _apiManager = ApiManager(locator<ApiClient>());
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
    getProfessions();
    String? token = await locator<LocalStorage>().fetch(LocalStorageDir.authToken);
    if (token != null && JwtDecoder.isExpired(token)) {
        userLoggedIn.value = true;
        User? userJson = await locator<LocalStorage>().fetch(LocalStorageDir.authUser);
        if (userJson != null) {
          profile.value = userJson;
        }
        locator<NavigationService>().clearStackAndShow(Routes.homeView);
        return;
    }

    if( token != null && !JwtDecoder.isExpired(token)){
      await locator<LocalStorage>().delete(LocalStorageDir.authToken);
      userLoggedIn.value = false;
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

        await locator<LocalStorage>().save(LocalStorageDir.authToken, token);
        await locator<LocalStorage>().save(LocalStorageDir.authRefreshToken, refreshToken);

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
            professionId: selectedProfessionId
            // Add other required fields here...
          );
    log.i('Attempting to register with: ${registrationRequest.toJson()}');

    try {
      // Using ApiManager to perform the API call now
      var response = await _apiManager.performApiCall(
          apiCall: () => UserControllerApi(_apiManager.apiClient).registerUser(registrationRequest),
          endpoint: 'login'
      );

      if (response != null && response.success) {
        locator<NavigationService>().clearStackAndShow(Routes.loginView);
      } else {
        snackBar.showSnackbar(message: 'Unable to signup');
      }
    } catch (e) {
      log.e('Login failed: $e');
      // Here you handle errors. The ApiManager's performApiCall method should internally handle specific cases like showing a modal on session end.

    } finally {
      setBusy(false);
    }
  }

  Future<void> getProfessions() async{
    try {
      // Using ApiManager to perform the API call now
      var response = await _apiManager.performApiCall(
          apiCall: () => ProfessionControllerApi(_apiManager.apiClient).getAllProfessions(),
          endpoint: 'get professions'
      );

      if (response != null && response.success) {
          professions = response.data;
      } else {
        snackBar.showSnackbar(message: 'couldnt get professions');
      }
    } catch (e) {
      log.e('No professions: $e');
      // Here you handle errors. The ApiManager's performApiCall method should internally handle specific cases like showing a modal on session end.
      snackBar.showSnackbar(message: e.toString());
    } finally {
      setBusy(false);
    }
  }



// void register() async {
  //   setBusy(true);
  //   try {
  //     var apiService = locator<ApiService>();
  //     var userApi = UserControllerApi(apiService.apiClient);
  //
  //     // Assuming you have collected these details from your UI
  //     var registrationRequest = UserRegistrationDTO(
  //       firstName: firstname.text,
  //       lastName: lastname.text,
  //       email: email.text,
  //       phone: phone.text,
  //       password: password.text,
  //       // Add other required fields here...
  //     );
  //
  //     var response = await userApi.registerUser(registrationRequest);
  //
  //     if (response!.success!) {
  //       // Registration successful
  //       snackBar.showSnackbar(message: 'Registration successful');
  //       locator<NavigationService>().navigateTo(Routes.loginView); // Navigate to login or another appropriate view
  //     } else {
  //       // Show error message
  //       snackBar.showSnackbar(message: response.message ?? 'Registration failed');
  //     }
  //   } on DioError catch (dioError) {
  //     handleApiError(dioError);
  //   }
  //   setBusy(false);
  // }


}
