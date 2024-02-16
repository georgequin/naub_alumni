# openapi.api.UserControllerApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**login**](UserControllerApi.md#login) | **POST** /auth/login | 
[**logout**](UserControllerApi.md#logout) | **POST** /auth/logout | 
[**refreshToken**](UserControllerApi.md#refreshtoken) | **POST** /auth/refresh-token | 
[**registerUser**](UserControllerApi.md#registeruser) | **POST** /auth/register | Receives user details and create new user


# **login**
> GlobalResponseDtoUserDataPojo login(loginRequestDTO)



### Example
```dart
import 'package:openapi/api.dart';

final api_instance = UserControllerApi();
final loginRequestDTO = LoginRequestDTO(); // LoginRequestDTO | 

try {
    final result = api_instance.login(loginRequestDTO);
    print(result);
} catch (e) {
    print('Exception when calling UserControllerApi->login: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **loginRequestDTO** | [**LoginRequestDTO**](LoginRequestDTO.md)|  | 

### Return type

[**GlobalResponseDtoUserDataPojo**](GlobalResponseDtoUserDataPojo.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **logout**
> Object logout()



### Example
```dart
import 'package:openapi/api.dart';

final api_instance = UserControllerApi();

try {
    final result = api_instance.logout();
    print(result);
} catch (e) {
    print('Exception when calling UserControllerApi->logout: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**Object**](Object.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **refreshToken**
> GlobalResponseDtoUserDataPojo refreshToken()



### Example
```dart
import 'package:openapi/api.dart';

final api_instance = UserControllerApi();

try {
    final result = api_instance.refreshToken();
    print(result);
} catch (e) {
    print('Exception when calling UserControllerApi->refreshToken: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**GlobalResponseDtoUserDataPojo**](GlobalResponseDtoUserDataPojo.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **registerUser**
> Object registerUser(userRegistrationDTO)

Receives user details and create new user

Creates new user in system

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = UserControllerApi();
final userRegistrationDTO = UserRegistrationDTO(); // UserRegistrationDTO | 

try {
    final result = api_instance.registerUser(userRegistrationDTO);
    print(result);
} catch (e) {
    print('Exception when calling UserControllerApi->registerUser: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userRegistrationDTO** | [**UserRegistrationDTO**](UserRegistrationDTO.md)|  | 

### Return type

[**Object**](Object.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)
