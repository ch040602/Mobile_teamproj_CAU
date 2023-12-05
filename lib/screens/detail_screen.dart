import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webtoon/models/webtoon_detail_model.dart';
import 'package:webtoon/models/webtoon_episode_model.dart';
import 'package:webtoon/services/api_service.dart';
import 'package:webtoon/widgets/episode_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatefulWidget {
  final String title,
      imageUrl,
      author,
      platform,
      platformtag,
      day,
      genre,
      summary;
  final int id;

  const DetailScreen({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.platform,
    required this.platformtag,
    required this.id,
    required this.day,
    required this.genre,
    required this.summary,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<WebtoonDetailModel> webtoon;
  late Future<List<WebtoonEpisodeModel>> episodes;
  late SharedPreferences prefs;
  bool isLiked = false;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final favoriteToons = prefs.getStringList('favoriteToons');
    if (favoriteToons != null) {
      if (favoriteToons.contains(
              "${widget.platformtag}\\${widget.platform}\\${widget.id}\\${widget.imageUrl}\\${widget.author}\\${widget.title}\\${widget.day}\\${widget.genre}\\${widget.summary}") ==
          true) {
        setState(() {
          isLiked = true;
        });
      }
    } else {
      await prefs.setStringList('favoriteToons', []);
    }
  }

  @override
  void initState() {
    super.initState();
    episodes = ApiService.getLatestEpisodesByTitle(
        widget.platform, widget.id, widget.title, widget.platformtag);
    initPrefs();
  }

  onHeartTap() async {
    final favoriteToons = prefs.getStringList('favoriteToons');
    if (favoriteToons != null) {
      if (isLiked) {
        favoriteToons.remove(
            "${widget.platformtag}\\${widget.platform}\\${widget.id}\\${widget.imageUrl}\\${widget.author}\\${widget.title}\\${widget.day}\\${widget.genre}\\${widget.summary}");
      } else {
        favoriteToons.add(
            "${widget.platformtag}\\${widget.platform}\\${widget.id}\\${widget.imageUrl}\\${widget.author}\\${widget.title}\\${widget.day}\\${widget.genre}\\${widget.summary}");
      }
      await prefs.setStringList('favoriteToons', favoriteToons);
      setState(() {
        isLiked = !isLiked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: widget.title,
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Image.network(
                    widget.imageUrl,
                    headers: const {
                      "User-Agent":
                          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
                    },
                  ),
                  width: 110,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(6,0,0,0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 20, // 원하는 크기로 조절
                        fontWeight: FontWeight.bold, // 필요에 따라 볼드 처리
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          widget.author,
                          style: TextStyle(
                            fontSize: 12, // 원하는 크기로 조절
                            fontWeight: FontWeight.normal, // 필요에 따라 볼드 처리
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          widget.genre,
                          style: TextStyle(
                            fontSize: 12, // 원하는 크기로 조절
                            fontWeight: FontWeight.normal, // 필요에 따라 볼드 처리
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: 250,
                      height: 100,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.summary,
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),

                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: onHeartTap,
                          icon: Icon(
                            isLiked
                                ? Icons.favorite
                                : Icons.favorite_outline_outlined,
                          ),
                        ),
                        FutureBuilder(
                            future: episodes,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ElevatedButton(
                                  onPressed: () async {
                                    final urlPage = Uri.parse(
                                      snapshot
                                          .data![snapshot.data!.length - 1].url,
                                    );
                                    if (await canLaunchUrl(urlPage)) {
                                      launchUrl(urlPage);
                                    } else {
                                      // ignore: avoid_print
                                      print("Can't launch $urlPage");
                                    }
                                  },
                                  child: Text('1화 보기'),
                                );
                              }
                              return Text("...");
                            }),
                        Container(
                          width: 4,
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('Together'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          FutureBuilder(
            future: episodes,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 14,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var episode = snapshot.data![index];
                      return Episode(
                        thumb: episode.thumb,
                        url: episode.url,
                        title: episode.title,
                        date: episode.date,
                      );
                    },
                  ),
                );
              }
              return Text("...");
            },
          )
        ],
      ),
    );
  }
}
