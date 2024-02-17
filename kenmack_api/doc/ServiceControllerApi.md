# openapi.api.ServiceControllerApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createService**](ServiceControllerApi.md#createservice) | **POST** /services/create | 
[**getAllServices**](ServiceControllerApi.md#getallservices) | **GET** /services | 
[**getRecommendedServices**](ServiceControllerApi.md#getrecommendedservices) | **GET** /services/recommended | 


# **createService**
> Object createService(serviceCreationDTO)



### Example
```dart
import 'package:openapi/api.dart';

final api_instance = ServiceControllerApi();
final serviceCreationDTO = ServiceCreationDTO(); // ServiceCreationDTO | 

try {
    final result = api_instance.createService(serviceCreationDTO);
    print(result);
} catch (e) {
    print('Exception when calling ServiceControllerApi->createService: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **serviceCreationDTO** | [**ServiceCreationDTO**](ServiceCreationDTO.md)|  | 

### Return type

[**Object**](Object.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAllServices**
> List<ServicesPOJO> getAllServices()



### Example
```dart
import 'package:openapi/api.dart';

final api_instance = ServiceControllerApi();

try {
    final result = api_instance.getAllServices();
    print(result);
} catch (e) {
    print('Exception when calling ServiceControllerApi->getAllServices: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<ServicesPOJO>**](ServicesPOJO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getRecommendedServices**
> List<ServicesPOJO> getRecommendedServices(professionId)



### Example
```dart
import 'package:openapi/api.dart';

final api_instance = ServiceControllerApi();
final professionId = 789; // int | 

try {
    final result = api_instance.getRecommendedServices(professionId);
    print(result);
} catch (e) {
    print('Exception when calling ServiceControllerApi->getRecommendedServices: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **professionId** | **int**|  | 

### Return type

[**List<ServicesPOJO>**](ServicesPOJO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

