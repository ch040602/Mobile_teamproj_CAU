import 'package:flutter/material.dart';
import 'package:webtoon/models/webtoon_model.dart';
import 'package:webtoon/mycolor.dart';
import 'package:webtoon/screens/detail_screen.dart';
import 'package:webtoon/screens/favorite_screen.dart';
import 'package:webtoon/screens/search_screen.dart';
import 'package:webtoon/services/api_service.dart';
import 'package:webtoon/widgets/webtoon_widget.dart';
import 'dart:math';

List<String> daysOfWeek = ["mon", "tue", "wed", "thu", "fri", "sat", "sun"];

class PlatformScreen extends StatefulWidget {
  final String platform, platformtag;

  PlatformScreen({
    super.key,
    required this.platform,
    required this.platformtag,
  });

  @override
  State<PlatformScreen> createState() => _PlatformScreenState();
}

class _PlatformScreenState extends State<PlatformScreen> {
  late Future<List<WebtoonModel>> webtoons;
  late String platform;
  String? selectedDay = "mon";

  @override
  void initState() {
    super.initState();
    webtoons = ApiService.getTodaysToons(widget.platform, selectedDay!);
    platform = widget.platform;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.75),
        leading: Container(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0,top: 20), // 왼쪽에 살짝 여백 추가
            child: OverflowBox(
              maxWidth: 60,
              child: DropdownButton<String>(
                value: selectedDay,
                onChanged: (newValue) {
                  setState(() {
                    selectedDay = newValue;
                    webtoons = ApiService.getTodaysToons(widget.platform, selectedDay!);
                  });
                },
                items: daysOfWeek.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(fontSize:15,color: MyColor.getColor(widget.platformtag)),// 원하는 크기로 조절
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: webtoons,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var rng = Random();
            int randomNumber = rng.nextInt(snapshot.data!.length);
            return Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.75), // 검은색 배경에 75% 투명도
              ),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child:  Image.network(
                            snapshot.data![randomNumber].imageUrl,
                            headers: const {
                              "User-Agent":
                              "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
                            },
                          ),width:150,
                        ),
                Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          snapshot.data![randomNumber].title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0, // 예시로 설정한 폰트 크기
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),// 왼쪽으로 150만큼의 패딩
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
                          children: [
                            Text(
                              "작가 이름: ${snapshot.data![randomNumber].author}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.0,
                              ),
                            ),
                            SizedBox(width: 10.0), // 작가와 장르 사이 여백
                            Text(
                              "장르: ${snapshot.data![randomNumber].genre}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          snapshot.data![randomNumber].summary,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.0, // 예시로 설정한 폰트 크기
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3, // 설정한 최대 줄 수
                        ),
                      ),
                    ],
                  ),SizedBox(
                    height: 40,
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var webtoon = snapshot.data![index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Webtoon(
                            plaformtag: widget.platformtag,
                            id: webtoon.id,
                            plaform: webtoon.platform,
                            imageUrl: webtoon.imageUrl,
                            title: webtoon.title,
                            author: webtoon.author,
                            day: webtoon.day,
                            genre: webtoon.genre,
                            summary: webtoon.summary,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black.withOpacity(0.90),
        items: [
          BottomNavigationBarItem(
            icon: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero, // 이미지 버튼의 안쪽 여백을 없앰
                shape: CircleBorder(), // 버튼 모양을 원형으로 설정
              ),
              child: Image(
                image: AssetImage('assets/$platform.png'),
                width: 60.0, // 이미지 버튼의 크기를 크게 설정
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoriteScreen(),
                    fullscreenDialog: true,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero, // 아이콘 버튼의 안쪽 여백을 없앰
                shape: CircleBorder(), // 버튼 모양을 원형으로 설정
                minimumSize: Size(60.0, 60.0), // 아이콘 버튼의 크기를 크게 설정
              ),
              child: Icon(Icons.favorite),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black.withOpacity(0.75),
            icon: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(),
                    fullscreenDialog: true,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero, // 아이콘 버튼의 안쪽 여백을 없앰
                shape: CircleBorder(), // 버튼 모양을 원형으로 설정
                minimumSize: Size(60.0, 60.0), // 아이콘 버튼의 크기를 크게 설정
              ),
              child: Icon(Icons.search),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
