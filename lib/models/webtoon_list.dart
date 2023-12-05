class WebtoonListModel {
  final String platformName, day, webtoonList;

  WebtoonListModel.fromJson(Map<String, dynamic> json)
      : platformName = json['platformName'],
        day = json['day'],
        webtoonList = json['webtoonList'];
}
