import 'dart:convert';
import 'package:webtoon/models/webtoon_detail_model.dart';
import 'package:http/http.dart' as http;
import 'package:webtoon/models/webtoon_episode_model.dart';
import 'package:webtoon/models/webtoon_list.dart';
import 'package:webtoon/models/webtoon_model.dart';
import 'package:flutter/services.dart' show rootBundle;

List<String> daysOfWeek = ["mon", "tue", "wed", "thu", "fri", "sat", "sun"];

class ApiService {
  static Future<List<WebtoonModel>> getTodaysToons(
      String platform, String day) async {
    List<WebtoonModel> webtoonInstances = [];
    final jsonString =
        await rootBundle.loadString('assets/$platform/${platform}_$day.json');
    final List<dynamic> webtoons = jsonDecode(jsonString);
    for (var webtoon in webtoons) {
      final instance = WebtoonModel.fromJson(webtoon);
      webtoonInstances.add(instance);
    }
    return webtoonInstances;
  }

  static Future<List<WebtoonModel>> getAllToons() async {
    List<WebtoonModel> webtoonInstances = [];
    for (var day in daysOfWeek) {
      final jsonString = await rootBundle
          .loadString('assets/naver/naver_${day}.json');
      final List<dynamic> webtoons = jsonDecode(jsonString);
      for (var webtoon in webtoons) {
        final instance = WebtoonModel.fromJson(webtoon);
        webtoonInstances.add(instance);
      }
    }

    for (var day in daysOfWeek) {
      final jsonString = await rootBundle
          .loadString('assets/Lezhin/Lezhin_${day}.json');
      final List<dynamic> webtoons = jsonDecode(jsonString);
      for (var webtoon in webtoons) {
        final instance = WebtoonModel.fromJson(webtoon);
        webtoonInstances.add(instance);
      }
    }

    return webtoonInstances;
  }

  static Future<List<WebtoonEpisodeModel>> getLatestEpisodesByTitle(
      String platform, int id, String title, String plaformtag) async {
    List<WebtoonEpisodeModel> episodesInstances = [];
    final jsonString = await rootBundle
        .loadString('assets/$platform/webtoons/${plaformtag}$id.json');

    final List<dynamic> episodes = jsonDecode(jsonString);
    for (var episode in episodes) {
      episodesInstances.add(WebtoonEpisodeModel.fromJson(episode));
    }
    return episodesInstances;
  }
}
