import 'dart:convert';
import 'dart:math';

import 'package:kenmack/app/app.router.dart';
import 'package:openapi/api.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:logger/logger.dart';
import '../../app/app.locator.dart';
import '../utils/config.dart';
import '../utils/local_store_dir.dart';
import '../utils/local_stotage.dart';

class ApiManager {
  late ApiClient apiClient;
  final NavigationService _navigationService = locator<NavigationService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();


  ApiManager(this.apiClient) {
    _initializeClient();
  }

  var logger = Logger(
    printer: PrettyPrinter(),
  );

  void _initializeClient() {
    apiClient = ApiClient(basePath: AppConfig.baseUrl);
    _setAuthorizationHeader();
  }

  Future<void> _setAuthorizationHeader() async {
    String token = await _getToken();
    if (token.isNotEmpty) {
      apiClient.addDefaultHeader('Authorization', 'Bearer $token');
    }
  }

  Future<String> _getToken() async {
    final localStorage = locator<LocalStorage>();
    String? token = await localStorage.fetch(LocalStorageDir.authToken);
    return token ?? "";
  }

  Future<dynamic> performApiCall<T>({
    required Future<T> Function() apiCall,
    bool refreshTokenIfNeeded = true,
    String? endpoint
  }) async {
    _logRequest(apiCall.toString());
    try {
      var response = await apiCall();
      _logResponse(response, endpoint);
      return response; // Return the successful response
    } catch (e) {
      _logError(e, endpoint);
      if (e is ApiException && refreshTokenIfNeeded) {
        if (e.code == 401) {
          bool refreshed = await _tryRefreshToken();
          if (refreshed) {
            return performApiCall(apiCall: apiCall, refreshTokenIfNeeded: false);
          }
        }
      }

      // Handle other errors, e.g., show error messages or dialogs
      _handleError(e);
      rethrow; // or return a default value/failure
    }
  }

  Future<bool> _tryRefreshToken() async {
    final localStorage = locator<LocalStorage>();
    String? refreshToken = await localStorage.fetch(LocalStorageDir.authRefreshToken);

    if (refreshToken == null) {
      logger.e('Refresh token not found');
      return false;
    }

    try {
      // Directly setting headers for a specific request is tricky with the generated ApiClient,
      // you might need to adjust the ApiClient to allow setting headers for individual requests
      // or use an intermediary method that ensures the header is included.
      // This example assumes an adjustment to your ApiClient or a custom method in your API class to accept headers.

      var customHeaders = {
        'Refresh-Token': refreshToken,
      };

      apiClient.addDefaultHeader('Refresh-Token', '$refreshToken');

      // Assuming you have a method to make the refresh token call that accepts custom headers
      var response = await UserControllerApi(apiClient).refreshToken();

      if (response != null && response.status == 200) {
        String? newAccessToken = response.data?.accessToken;
        String? newRefreshToken = response.data?.refreshToken ?? refreshToken;

        await localStorage.save(LocalStorageDir.authToken, newAccessToken);
        await localStorage.save(LocalStorageDir.authRefreshToken, newRefreshToken);

        // Update the API client with the new access token for subsequent requests
        apiClient.addDefaultHeader('Authorization', 'Bearer $newAccessToken');

        return true;
      } else {
        logger.e('Failed to refresh token with the provided refresh token');
        return false;
      }
    } catch (e) {
      logger.e('Error refreshing token: $e');
      return false;
    }
  }


  void _handleError(dynamic error) {
    // Example error handling
    if (error is ApiException && error.code == 401) {
      _snackbarService.showSnackbar(message: "Session expired. Please login again.");
      _navigationService.navigateToLoginView();
    } if (error is ApiException && error.code == 404 && error.message != null && error.message!.contains('email')){
      _snackbarService.showSnackbar(message: "Email address already registered. login or try another");
    }if (error is ApiException && error.code == 404 && error.message != null && error.message!.contains('phone')){
      _snackbarService.showSnackbar(message: "phone number already registered. try another");
    }
    else {
      //TODO remove the actual error
      _snackbarService.showSnackbar(message: "An error occurred. Please try again. ${error}");
    }
  }

  void _logRequest(String endpoint) {
    logger.i('Request to $endpoint');
    // Optionally log additional request details if available
  }

  void _logResponse(dynamic response, String? endpoint) {
    logger.i('Response from $endpoint: ${jsonEncode(response)}');
  }

  void _logError(dynamic error, String? endpoint) {
    logger.e('Error from $endpoint: $error');
    // Optionally log additional error details if available
  }
}
