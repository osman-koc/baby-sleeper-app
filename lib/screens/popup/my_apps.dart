import 'dart:convert';
import 'dart:io';
import 'package:babysleeper/constants/app_assets.dart';
import 'package:babysleeper/constants/app_colors.dart';
import 'package:babysleeper/constants/app_settings.dart';
import 'package:babysleeper/extensions/app_lang.dart';
import 'package:babysleeper/models/ok_apps.dart';
import 'package:babysleeper/util/localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MyAppsPopup extends StatefulWidget {
  final String jsonUrl;

  const MyAppsPopup({super.key, required this.jsonUrl});

  @override
  State<MyAppsPopup> createState() => _MyAppsPopupState();
}

class _MyAppsPopupState extends State<MyAppsPopup> {
  List<OkAppItem> myAppList = [];
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    fetchDataFromUrl(widget.jsonUrl);
  }

  @override
  Widget build(BuildContext context) {
    String currentLangCode = AppLocalizations.of(context).locale.languageCode;
    return AlertDialog(
      title: Text(context.translate.myAppsTitle),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 25),
          if (isLoading)
            dataIsLoadingText(context)
          else if (isError)
            dataLoadErrorText(context)
          else
            for (var appInfo in myAppList) 
              gestureAppItem(appInfo, currentLangCode, context),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(context.translate.close),
        ),
      ],
    );
  }

  Center dataIsLoadingText(BuildContext context) {
    return Center(
      child: Text(
        context.translate.dataIsLoading,
        style:
            TextStyle(fontSize: 14, color: AppColors(context).dropdownButtonBg),
      ),
    );
  }

  Center dataLoadErrorText(BuildContext context) {
    return Center(
      child: Text(
        context.translate.dataLoadError,
        style: TextStyle(fontSize: 14, color: AppColors(context).appRed),
      ),
    );
  }

  Widget gestureAppItem(
    OkAppItem appInfo,
    String currentLangCode,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: appInfo.iconUrl.isNotEmpty
                    ? NetworkImage(appInfo.iconUrl)
                    : const AssetImage(AppAssets.defaultAppIcon)
                        as ImageProvider<Object>,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () {
                var link = Platform.isAndroid
                    ? appInfo.links.android
                    : appInfo.links.ios;
                if (link.isNotEmpty) {
                  goToMarket(Uri.parse(link));
                }
              },
              child: Text(
                currentLangCode == 'tr' ? appInfo.name.tr : appInfo.name.en,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors(context).appBlue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void fetchDataFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['apps'];
        setState(() {
          myAppList = data
              .map((app) => OkAppItem.fromJson(app))
              .where((x) => x.isPublished && x.id != AppSettings.id)
              .toList();
          isLoading = false;
        });
      } else {
        if (kDebugMode) print('Failed to load app list data');
        setState(() {
          isError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      if (kDebugMode) print(e);
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  void goToMarket(Uri uri) async {
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (kDebugMode) print('Could not launch $uri');
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }
}
