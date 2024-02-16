# openapi.api.ServiceControllerApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://104.248.3.252:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getAllServices**](ServiceControllerApi.md#getallservices) | **GET** /services | 
[**getRecommendedServices**](ServiceControllerApi.md#getrecommendedservices) | **GET** /services/recommended | 


# **getAllServices**
> List<Service> getAllServices()



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

[**List<Service>**](Service.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getRecommendedServices**
> List<Service> getRecommendedServices(professionId)



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

[**List<Service>**](Service.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

