import 'dart:convert';
import 'package:http/http.dart' as http;

class WallData {
  String fetchUrl;
  Future getData(String query, int width, int height) async {
    width = 1080;
    height = 1920;
    if (query == "") {
      fetchUrl =
          "https://wallhaven.cc/api/v1/search?categories=100&purity=100&resolutions=${width}x${height}&sorting=random&order=desc&page=1";
    } else {
      fetchUrl =
          "https://wallhaven.cc/api/v1/search?q=$query&categories=100&purity=100&resolutions=${width}x${height}&sorting=random&order=desc&page=1";
    }
    http.Response response = await http.get(fetchUrl);
    if (response.statusCode == 200) {
      var fetchData = jsonDecode(response.body);
      int wallpPages;
      int currentPage;
      List wallpapersLinks = [];
      List wallpapersThumbs = [];
      List wallpapersColors = [];
      List wallpapers = fetchData["data"];
      Map meta = fetchData["meta"];
      currentPage = meta["current_page"];
      wallpPages = meta["last_page"];
      if (wallpPages >= 5) {
        wallpPages = 5;
      }
      for (int i = 0; i < wallpapers.length; i++) {
        print(
            '${wallpapers[i]["dimension_x"]}x${wallpapers[i]["dimension_y"]}');
        wallpapersLinks.add(wallpapers[i]["path"].toString());
        wallpapersThumbs.add(wallpapers[i]["thumbs"]["original"].toString());
        try {
          wallpapersColors
              .add(wallpapers[i]["colors"][0].toString().substring(1));
        } catch (e) {
          wallpapersColors.add("FFFFFF");
        }
      }
      for (int i = 2; i <= 5; i++) {
        if (currentPage == wallpPages) {
          break;
        } else {
          if (query == "") {
            fetchUrl =
                "https://wallhaven.cc/api/v1/search?categories=100&purity=100&resolutions=${width}x${height}&sorting=random&order=desc&page=$i";
          } else {
            fetchUrl =
                "https://wallhaven.cc/api/v1/search?q=$query&categories=100&purity=100&resolutions=${width}x${height}&sorting=random&order=desc&page=$i";
          }
          http.Response response = await http.get(fetchUrl);
          if (response.statusCode == 200) {
            var fetchData = jsonDecode(response.body);
            wallpapers = fetchData["data"];
            meta = fetchData["meta"];
            currentPage = meta["current_page"];
            for (int i = 0; i < wallpapers.length; i++) {
              // print(wallpapers[i]["path"]);
              wallpapersLinks.add(wallpapers[i]["path"].toString());
              wallpapersThumbs
                  .add(wallpapers[i]["thumbs"]["original"].toString());
              try {
                wallpapersColors
                    .add(wallpapers[i]["colors"][0].toString().substring(1));
              } catch (e) {
                wallpapersColors.add("FFFFFF");
              }
            }
          } else {
            print(response.statusCode);
            throw 'Cannot Fetch Data';
          }
        }
      }
      Map wallheavenData = {
        "links": wallpapersLinks,
        "thumbs": wallpapersThumbs,
        "colors": wallpapersColors
      };
      // print(wallheavenData.toString());
      return wallheavenData;
    } else {
      print(response.statusCode);
      throw 'Cannot Fetch Data';
    }
  }
}