import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:webtoon/screens/detail_screen.dart';

class Webtoon extends StatelessWidget {
  final String title, imageUrl, author, plaform, plaformtag, day, genre, summary;
  final int id;

  const Webtoon({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.id,
    required this.plaform,
    required this.plaformtag,
    required this.day,
    required this.genre,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              genre: genre,
              summary: summary,
              platformtag: plaformtag,
              platform: plaform,
              id: id,
              imageUrl: imageUrl,
              title: title,
              author: author,
              day: day,
            ),
            fullscreenDialog: true,
          ),
        );
      },
      child: Column(
        children: [
          Hero(
            tag: title,
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Stack(
                children: [Image.network(
                  imageUrl,
                  headers: const {
                    "User-Agent":
                        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
                  },
                width: 85,
                height: 125.0,
                ),
              Positioned(
                left: 0,
                child: Image(
                
                  image: AssetImage('assets/$plaform.png'),
                  width: 20.0,
                ),
              ),
            ]),
          ),

          ),
        ],
      ),
    );
  }
}
