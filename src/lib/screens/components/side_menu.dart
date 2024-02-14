import 'package:flutter/material.dart';
import 'package:babysleeper/constants/app_assets.dart';
import 'package:babysleeper/constants/app_colors.dart';
import 'package:babysleeper/extensions/app_lang.dart';
import 'package:babysleeper/screens/popup/about.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) => Material(
        color: Colors.grey[800],
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.only(
              top: 24 + MediaQuery.of(context).padding.top,
              bottom: 24,
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 52,
                  backgroundImage: AssetImage(AppAssets.defaultUserAvatar),
                ),
                const SizedBox(height: 12),
                Text(
                  context.translate.welcome,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      );

  Widget buildMenuItems(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 16,
        children: [
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: Text(context.translate.home),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(context.translate.about),
              onTap: () {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const AboutScreenPopup();
                  },
                );
              }),
          Divider(color: AppColors(context).appGrey),
        ],
      ),
    );
  }
}
