class WebtoonModel {
  final String title, imageUrl, author, genre, day, platform, summary;
  final int id;

  WebtoonModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        imageUrl = json['imageUrl'],
        author = json['author'],
        day = json['day'],
        platform = json['platform'],
        id = json['id'],
        summary = json['summary'],
        genre = json['genre'];
}
