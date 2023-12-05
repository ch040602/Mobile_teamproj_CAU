import 'package:flutter/material.dart';
import 'package:webtoon/models/webtoon_model.dart';
import 'package:webtoon/services/api_service.dart';
import 'package:webtoon/widgets/webtoon_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Future<List<WebtoonModel>> webtoons;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool foundwebtoon = false;
  String _searchResult = '';
  String webtoontitle = '';
  String webtoonimageUrl = '';
  String webtoonauthor = '';
  int webtoonid = 0;
  String webtoonplatform = '';
  String webtoonplatformtag = '';
  String webtoonday = '';
  String webtoongenre = '';
  String webtoonsummary = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    webtoons = ApiService.getAllToons();
  }

  void _searchWebtoon() async {
    String searchTitle = _searchController.text;

    setState(() {
      _searchResult = 'Searching...';
    });

    try {
      // Await the Future to get the list of webtoons
      List<WebtoonModel> webtoonsList = await webtoons;

      // Split the search query into individual words
      List<String> searchWords = searchTitle.split(' ');

      // Search for the webtoons with titles containing any of the search words
      List<WebtoonModel> matchingWebtoons = [];
      for (var webtoon in webtoonsList) {
        bool titleContainsSearchWord = searchWords.every(
                (word) => webtoon.title.toLowerCase().contains(word.toLowerCase()));

        if (titleContainsSearchWord) {
          matchingWebtoons.add(webtoon);
        }
      }

      if (matchingWebtoons.isNotEmpty) {
        setState(() {
          foundwebtoon = true;
          // Handle multiple matching webtoons as needed
          // For simplicity, just take the first matching webtoon
          var firstMatchingWebtoon = matchingWebtoons.first;
          webtoonauthor = firstMatchingWebtoon.author;
          webtoontitle = firstMatchingWebtoon.title;
          webtoonplatform = firstMatchingWebtoon.platform;
          webtoonday = firstMatchingWebtoon.day;
          webtoonimageUrl = firstMatchingWebtoon.imageUrl;
          webtoonid = firstMatchingWebtoon.id;
          if (firstMatchingWebtoon.platform == 'naver') {
            webtoonplatformtag = 'nv';
          } else if (firstMatchingWebtoon.platform == 'kakaoPage') {
            webtoonplatformtag = 'kp';
          } else {
            webtoonplatformtag = 'lz';
          }
          webtoongenre = firstMatchingWebtoon.genre;
          webtoonsummary = firstMatchingWebtoon.summary;
        });
      } else {
        setState(() {
          foundwebtoon = false;
          _searchResult = 'No matching webtoon found';
        });
      }
    } catch (e) {
      setState(() {
        _searchResult = 'Error occurred during search: $e';
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: Icon(Icons.search),
        title: TextFormField(
          controller: _searchController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text.';
            }
            return null;
          },
        ),
        actions: [
          ElevatedButton(
            onPressed: _searchWebtoon,
            child: Icon(Icons.input),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.dangerous))
        ],
      ),
      body: _isSearching
          ? Center(child: CircularProgressIndicator())
          : foundwebtoon
              ? Row(
                  children: [
                    Webtoon(
                        summary: webtoonsummary,
                        genre: webtoongenre,
                        imageUrl: webtoonimageUrl,
                        title: webtoontitle,
                        author: webtoonauthor,
                        id: webtoonid,
                        plaform: webtoonplatform,
                        plaformtag: webtoonplatformtag,
                        day: webtoonday),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                webtoontitle,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8), // 간격 조절
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(webtoonauthor),
                  SizedBox(height: 8), // 간격 조절
                  Text(webtoongenre),
                ],
              ),
              Container(
                width: 250,
                child: Text(
                  webtoonsummary,
                  style: TextStyle(
                    fontSize: 10,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Divider(
                height: 15,
                color: Colors.black54,
              ),
            ],
          ),
        ),
                  ],
      )
          : Container(),
    );
  }



        @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
