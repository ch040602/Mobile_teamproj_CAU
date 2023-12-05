import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webtoon/models/webtoon_model.dart';
import 'package:webtoon/mycolor.dart';
import 'package:webtoon/widgets/webtoon_widget.dart';

List<String> daysOfWeek = [
  "day",
  "mon",
  "tue",
  "wed",
  "thu",
  "fri",
  "sat",
  "sun"
];
List<String> platformList = ["all", "naver", "kakaoPage", "Lezhin"];

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  String? selectedDay = "day";
  String? selectedPlatform = "all";

  Future readFavoriteWebtoon() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteToons = prefs.getStringList('favoriteToons');

    if (favoriteToons != null) {
      return favoriteToons;
    }
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        leading: Container(
          padding: EdgeInsets.all(5.0),
          alignment: Alignment.topLeft,
          child: OverflowBox(
            maxWidth: 60,
            child: DropdownButton<String>(
              value: selectedDay,
              onChanged: (newValue) {
                setState(() {
                  selectedDay = newValue;
                });
              },
              items: daysOfWeek.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
        title: Container(
          alignment: Alignment.topLeft,
          child: DropdownButton<String>(
            value: selectedPlatform,
            onChanged: (newValue) {
              setState(() {
                selectedPlatform = newValue;
              });
            },
            items: platformList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.backspace_outlined))
        ],
      ),
      body: FutureBuilder(
        future: readFavoriteWebtoon(),
        builder: (context, snapshot) {
          final webtoonList =
              List<Widget>.generate(snapshot.data!.length, (index) {
            List<String> webtoonElements = snapshot.data![index].split('\\');
            if (selectedPlatform == 'all' && selectedDay == 'day') {
              return Container(
                decoration:BoxDecoration(
                  border: Border.all(color: MyColor.getColor(webtoonElements[0]),width: 5),
                ),
                child: Webtoon(
                    summary: webtoonElements[8],
                    genre: webtoonElements[7],
                    day: webtoonElements[6],
                    imageUrl: webtoonElements[3],
                    title: webtoonElements[5],
                    author: webtoonElements[4],
                    id: int.parse(webtoonElements[2]),
                    plaform: webtoonElements[1],
                    plaformtag: webtoonElements[0]),
              );
            } else if (selectedPlatform == webtoonElements[1] &&
                selectedDay == 'day') {
              return Container(
                  decoration:BoxDecoration(
                  border: Border.all(color: MyColor.getColor(webtoonElements[0]),width: 5),

                  ),
                  child: Webtoon(
                      summary: webtoonElements[8],
                      genre: webtoonElements[7],
                      day: webtoonElements[6],
                      imageUrl: webtoonElements[3],
                      title: webtoonElements[5],
                      author: webtoonElements[4],
                      id: int.parse(webtoonElements[2]),
                      plaform: webtoonElements[1],
                      plaformtag: webtoonElements[0]),
              );
              }else if (selectedPlatform == 'all' &&
                selectedDay == webtoonElements[6]) {
              return Container(
                  decoration:BoxDecoration(
                    border: Border.all(color: MyColor.getColor(webtoonElements[0]),width: 5),
                  ),
                  child: Webtoon(
                      summary: webtoonElements[8],
                      genre: webtoonElements[7],
                      day: webtoonElements[6],
                      imageUrl: webtoonElements[3],
                      title: webtoonElements[5],
                      author: webtoonElements[4],
                      id: int.parse(webtoonElements[2]),
                      plaform: webtoonElements[1],
                      plaformtag: webtoonElements[0]),);
            } else if (selectedPlatform == webtoonElements[1] &&
                selectedDay == webtoonElements[6]) {
              return Container(
                  decoration:BoxDecoration(
                    border: Border.all(color: MyColor.getColor(webtoonElements[0]),width: 5),
                  ),
                  child: Webtoon(
                      summary: webtoonElements[8],
                      genre: webtoonElements[7],
                      day: webtoonElements[6],
                      imageUrl: webtoonElements[3],
                      title: webtoonElements[5],
                      author: webtoonElements[4],
                      id: int.parse(webtoonElements[2]),
                      plaform: webtoonElements[1],
                      plaformtag: webtoonElements[0]),);
            } else
              return Text('');
          });
          webtoonList.removeWhere((item) => item is Text);
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(3.0),
              child: GridView.count(crossAxisCount: 3,
                  crossAxisSpacing: 0, // 가로 간격
                  mainAxisSpacing: 0,
                  children: webtoonList),
            );
          }
          return Text('...');
        },
      ),
    );
  }
}
