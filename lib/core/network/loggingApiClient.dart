


import 'dart:io';

import 'package:kenmack/app/app.router.dart';
import 'package:kenmack/core/utils/config.dart';
import 'package:logger/logger.dart';
import 'package:openapi/api.dart';
// import 'package:http/src/response.dart';
import 'package:http/http.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../app/app.locator.dart';
import '../utils/local_store_dir.dart';
import '../utils/local_stotage.dart';

class LoggingApiClient extends ApiClient {
  LoggingApiClient({String basePath = AppConfig.baseUrl, Authentication? authentication})
      : super(basePath: basePath, authentication: authentication);

  final SnackbarService _snackbarService = locator<SnackbarService>();
  final NavigationService _navigationService = locator<NavigationService>();
  var logger = Logger(
    printer: PrettyPrinter(),
  );
  @override
  Future<Response> invokeAPI(
      String path,
      String method,
      List<QueryParam> queryParams,
      Object? body,
      Map<String, String> headerParams,
      Map<String, String> formParams,
      String? contentType,
      ) async {

  try {
    // Log request details
    logger.i('Request: $method $basePath$path,\n Params: $queryParams , \n Body: $body');
    // Call the superclass's invokeAPI method to perform the actual API request
    final response = await super.invokeAPI(
      path,
      method,
      queryParams,
      body,
      headerParams,
      formParams,
      contentType,
    );

    // Log the response details
    logger.i('Response from $method $basePath$path: \n Status Code: ${response.statusCode}, \n Body: ${response.bowdy}');
    return response;

  } on ApiException catch (e) {
    if (e.code == 401) {
      final refreshed = await _tryRefreshToken();
      if (refreshed) {
        return await invokeAPI(path, method, queryParams, body, headerParams, formParams, contentType);
      }
    }
    _handleError(e, '$method $path');
    rethrow;
  }
  }


  void _handleError(dynamic error, String endpoint) {
    String errorMessage = "An error occurred. Please try again.";
    if (error is ApiException) {
      switch (error.code) {
        case 401:
          errorMessage = "Session expired. Please login again.";
          _navigationService.navigateToLoginView();
          break;
        case 404:
          if (error.message?.contains('email') ?? false) {
            errorMessage = "Email address already registered. Login or try another.";
          } else if (error.message?.contains('phone') ?? false) {
            errorMessage = "Phone number already registered. Try another.";
          }
          break;
        default:
          errorMessage = error.message ?? errorMessage;
      }
    } else if (error is SocketException || error is TlsException || error is IOException || error is ClientException) {
      errorMessage = "Network error. Check your connection and try again.";
    }
    logger.e('Error from $endpoint: $error');
    _snackbarService.showSnackbar(message: errorMessage);
  }

  Future<bool> _tryRefreshToken() async {
    final localStorage = locator<LocalStorage>();
    String? refreshToken = await localStorage.fetch(LocalStorageDir.authRefreshToken);

    if (refreshToken == null) {
      logger.e('Refresh token not found');
      return false;
    }

    try {
      addDefaultHeader('Refresh-Token', refreshToken);
      var response = await UserControllerApi(this).refreshToken();

      if ( response != null && response.status == 200) {

        String? newAccessToken = response.data?.accessToken;
        String? newRefreshToken = response.data?.refreshToken;

        // Save new tokens
        await localStorage.save(LocalStorageDir.authToken, newAccessToken);
        await localStorage.save(LocalStorageDir.authRefreshToken, newRefreshToken ?? refreshToken);

        // Update the API client with the new access token
        addDefaultHeader('Authorization', 'Bearer $newAccessToken');
        logger.i('Token refreshed successfully');
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

}
