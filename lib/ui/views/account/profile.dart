import 'dart:io';


import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kenmack/state.dart';
import 'package:kenmack/utils/profileUtil.dart';
import 'package:openapi/api.dart';
import 'package:path/path.dart' as path;
import 'package:stacked_services/stacked_services.dart';
import 'dart:typed_data';

import '../../../app/app.locator.dart';
import '../../../core/network/api_manager.dart';
import '../../common/app_colors.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Uint8List? _imageBytes;
  bool isUpdating = false;
  int? _selectedCountryId;
  List<CountryPOJO> _countries = [];
  final ApiManager _apiManager = ApiManager(locator<ApiClient>());

  // Use initial values from the profile state
  late TextEditingController _fullNameController = TextEditingController(text: '${profile.value.firstName} ${profile.value.lastName}');
  late TextEditingController _phoneNumberController = TextEditingController(text: '${profile.value.phone}');
  late TextEditingController _emailController = TextEditingController(text: '${profile.value.email}');

  @override
  void initState() {
    super.initState();
    fetchCountries();
    ProfileUtil().getProfile();
    initializeControllers();
  }

  void initializeControllers() {
    _fullNameController = TextEditingController(text: '${profile.value.firstName} ${profile.value.lastName}');
    _phoneNumberController = TextEditingController(text: '${profile.value.phone}');
    _emailController = TextEditingController(text: '${profile.value.email}');
  }


  void fetchCountries() async {
    try {

      _countries = await _apiManager.performApiCall(
          apiCall: () => UserControllerApi(_apiManager.apiClient).getAllCountries(),
          endpoint: 'countries'
      );

      if (_countries.isNotEmpty) {
        if(profile.value.countryPOJO != null){
          _selectedCountryId = profile.value.countryPOJO?.id;
        }else{
          _selectedCountryId = _countries.first.id;
        }
      }
      setState(() {});
    } catch (e) {
      print("Error fetching countries: $e");
    }
  }


  // void _updateProfilePicture() async {
  //   // pick photo
  //   setState(() {
  //     isUpdating = true;
  //   });
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  //
  //   if (image == null) return; // Handle null (user didn't pick an image)
  //
  //   String oldPath = image.path;
  //   String newPath = '${path.withoutExtension(oldPath)}.png';
  //   File inputFile = File(oldPath);
  //   File outputFile = File(newPath);
  //
  //   XFile? result = await FlutterImageCompress.compressAndGetFile(
  //     inputFile.path,
  //     outputFile.path,
  //     format: CompressFormat.png,
  //   );
  //
  //   if (result == null) return;
  //
  //   // Check file size
  //   final fileSize = await outputFile.length();
  //   if (fileSize > 5 * 1024 * 1024) { // 5 MB size limit
  //     locator<SnackbarService>().showSnackbar(message: "Please pick an image smaller than 5MB");
  //     setState(() {
  //       isUpdating = false;
  //     });
  //     return;
  //   }
  //
  //   try {
  //     // Prepare the request
  //     UpdateUserProfilePictureRequest request = UpdateUserProfilePictureRequest(
  //       file: await MultipartFile.fromPath( 'profile', outputFile.path),
  //     );
  //
  //   final response = await _apiManager.performApiCall(
  //         apiCall: () => UserControllerApi(_apiManager.apiClient)
  //             .updateUserProfilePicture(profile.value.id!, updateUserProfilePictureRequest: request),
  //         endpoint: 'countries'
  //     );
  //     if (response != null) {
  //       locator<SnackbarService>().showSnackbar(message: "Profile picture updated successfully");
  //       ProfileUtil().getProfile();
  //     }
  //   } catch (e) {
  //     print("Error updating profile picture: $e");
  //     locator<SnackbarService>().showSnackbar(message: "Error updating profile picture");
  //   } finally {
  //     setState(() {
  //       isUpdating = false;
  //     });
  //   }
  // }

  Future<void> _updateProfileDetails() async {
    // Implement your logic to update the profile details
    // Collect data from the TextEditingControllers and send to your backend or service
    UserDetailDTO userDetailDTO = UserDetailDTO(
      fullName: _fullNameController.text,
      phoneNumber: _phoneNumberController.text,
      countryId: _selectedCountryId,
    );

    try {
      Response response = await _apiManager.performApiCall(
        apiCall: () => UserControllerApi(_apiManager.apiClient).updateUserDetails(profile.value.id!, userDetailDTO),
        endpoint: 'user details',
      );
      ProfileUtil().getProfile();
    } catch (e) {
      print("Error fetching user profile: $e");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child:  Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
          children: <Widget>[
            SizedBox(height: 24),
            GestureDetector(
              onTap: (){},
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: _imageBytes != null ? MemoryImage(_imageBytes!) : null,
                child: _imageBytes == null ? Text('NGN') : null,
              ),
            ),
            SizedBox(height: 16),
            Text('${profile.value.firstName} ${profile.value.lastName}' ?? 'user',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('${profile.value.email}', style: Theme.of(context).textTheme.caption),
            SizedBox(height: 24),
            ListTile(
              title: Text('Profile Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
             _buildTextField(_fullNameController, 'Full Name'),
            _buildTextField(_emailController, 'email',  trailing: 'Not Verified', enabled: false),
            _buildTextField(_phoneNumberController, 'Phone Number',  trailing: 'Not Verified'),
            _buildCountryDropdown(),
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 18.0),
              child: ElevatedButton(
                onPressed: () => _updateProfileDetails,
                child: Text('Update Profile'),
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  backgroundColor: kcPrimaryColor,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ),
          ],
        ),
        )
      ),
    );
  }


  Widget _buildTextField(TextEditingController controller, String label,  {String? trailing, bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          suffixText: trailing,
        ),
        enabled: enabled, // This line will enable or disable the text field
      ),
    );
  }

  Widget _buildCountryDropdown() {
    return
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child:DropdownButtonFormField<int>(
      value: _selectedCountryId,
      onChanged: (newValue) {
        setState(() {
          _selectedCountryId = newValue;
        });
      },
      items: _countries.map<DropdownMenuItem<int>>((CountryPOJO country) {
        return DropdownMenuItem<int>(
          value: country.id,
          child: Text(country.name ?? ''),
        );
      }).toList(),
    )
      );

  }


}
