import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Episode extends StatelessWidget {
  final String url, title, date, thumb;

  const Episode({
    super.key,
    required this.thumb,
    required this.url,
    required this.title,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final urlPage = Uri.parse(
          url,
        );
        if (await canLaunchUrl(urlPage)) {
          launchUrl(urlPage);
        } else {
          // ignore: avoid_print
          print("Can't launch $urlPage");
        }
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    child: Image.network(
                      thumb,
                      headers: const {
                        "User-Agent":
                            "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(title),
                ],
              ),
              Text(date),
            ],
          ),
          Divider(
            height: 15, // 선의 높이를 조절합니다.
            color: Colors.black54, // 선의 색상을 지정합니다.
          ),
        ],
      ),
    );
  }
}
