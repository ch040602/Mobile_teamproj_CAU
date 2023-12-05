class WebtoonEpisodeModel {
  final String url, title, date, thumb;

  WebtoonEpisodeModel.fromJson(Map<String, dynamic> json)
      : url = json['url'],
        title = json['title'],
        date = json['publicationDate'],
        thumb = json['imageUrl'];
}
