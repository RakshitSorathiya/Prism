import 'package:Prism/routes/routing_constants.dart';
import 'package:Prism/theme/jam_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:Prism/theme/toasts.dart' as toasts;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:Prism/main.dart' as main;
import 'package:Prism/theme/themeModel.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class GeneralList extends StatefulWidget {
  @override
  _GeneralListState createState() => _GeneralListState();
}

class _GeneralListState extends State<GeneralList> {
  bool optWall = main.prefs.get('optimisedWallpapers') ?? true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'General',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        ),
        Column(
          children: [
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, ThemeViewRoute, arguments: [
                  Provider.of<ThemeModel>(context, listen: false).currentTheme
                ]);
              },
              leading: Icon(JamIcons.wrench),
              title: Text(
                "Themes",
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Proxima Nova"),
              ),
              subtitle: Text(
                "Toggle app theme",
                style: TextStyle(fontSize: 12),
              ),
            ),
            ListTile(
                leading: Icon(
                  JamIcons.pie_chart_alt,
                ),
                title: Text(
                  "Clear Cache",
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Proxima Nova"),
                ),
                subtitle: Text(
                  "Clear locally cached images",
                  style: TextStyle(fontSize: 12),
                ),
                onTap: () async {
                  DefaultCacheManager().emptyCache();
                  PaintingBinding.instance.imageCache.clear();
                  await Hive.box('wallpapers').deleteFromDisk();
                  await Hive.openBox('wallpapers');
                  await Hive.box('collections').deleteFromDisk();
                  await Hive.openBox('collections');
                  toasts.codeSend("Cleared cache!");
                }),
            SwitchListTile(
                activeColor: Color(0xFFE57697),
                secondary: Icon(
                  JamIcons.dashboard,
                ),
                value: optWall,
                title: Text(
                  "Wallpaper Optimisation",
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Proxima Nova"),
                ),
                subtitle: optWall
                    ? Text(
                        "Disabling this might lead to High Internet Usage",
                        style: TextStyle(fontSize: 12),
                      )
                    : Text(
                        "Enable this to optimise Wallpapers according to your device",
                        style: TextStyle(fontSize: 12),
                      ),
                onChanged: (bool value) async {
                  setState(() {
                    optWall = value;
                  });
                  main.prefs.put('optimisedWallpapers', value);
                }),
            ListTile(
              onTap: () {
                main.RestartWidget.restartApp(context);
              },
              leading: Icon(JamIcons.refresh),
              title: Text(
                "Restart App",
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Proxima Nova"),
              ),
              subtitle: Text(
                "Force the application to restart",
                style: TextStyle(fontSize: 12),
              ),
            ),
            ListTile(
              onTap: () {
                main.prefs.put("newDevice", true);
                main.prefs.put("newDevice2", true);
                main.RestartWidget.restartApp(context);
              },
              leading: Icon(JamIcons.help),
              title: Text(
                "Show Tutorial",
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Proxima Nova"),
              ),
              subtitle: Text(
                "Quick Guide to Prism",
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
