import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kenmack/ui/common/ui_helpers.dart';
import 'package:openapi/api.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/base64Image.dart';
import '../../common/app_colors.dart';

class ServiceDetailsPage extends StatelessWidget {
  final ServicesPOJO service;
  final bool isModal;

  const ServiceDetailsPage({
    Key? key,
    required this.service,
    this.isModal = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isModal ? null : AppBar(
        title: Text(service.title ?? 'Service title'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                Base64Image(
                  base64String: service.picture?.url,
                  width: double.infinity, // or specify a width
                  height: 211, // or specify a height
                  fit: BoxFit.cover, // adjust the fit as needed
                ),
                verticalSpaceSmall,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    service.description ?? 'No Description Provided',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
            child: ElevatedButton(
              onPressed: () => _launchURL(service.providerUri!),
              child: Text('Proceed'),
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                backgroundColor: kcPrimaryColor,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri toLaunch = Uri.parse(url);

    if (!await launchUrl(toLaunch, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }

}
