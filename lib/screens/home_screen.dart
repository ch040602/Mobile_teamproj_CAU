import 'package:flutter/material.dart';
import 'package:webtoon/screens/platform_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black.withOpacity(0.85), // 검은색 배경에 5% 투명도
        padding: EdgeInsets.all(20.0), // 전체 패딩
        child: Column(


          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 70.0), // 상단 여백
            Text(
              "어떤 플랫폼의 웹툰을 찾아보길 원하시나요?",
              style: TextStyle(
                color: Colors.white, // 하얀 글씨
                fontSize: 20.0, // 폰트 크기
                fontWeight: FontWeight.bold, // 폰트 굵기
              ),
            ),
            SizedBox(height: 100.0), // 텍스트와 버튼 사이 여백
            platformButton(context, 'assets/naver.png', '네이버 웹툰', 'naver', 'nv'),
            SizedBox(height: 40.0), // 버튼 간 여백
            platformButton(context, 'assets/kakaoPage.png', '카카오 웹툰', 'kakaoPage', 'kp'),
            SizedBox(height: 40.0), // 버튼 간 여백
            platformButton(context, 'assets/Lezhin.png', '레진 웹툰', 'Lezhin', 'lz'),
          ],
        ),
      ),
    );
  }

  Widget platformButton(BuildContext context, String imageAsset, String buttonText, String platform, String platformTag) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0), // 버튼 아래 여백
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlatformScreen(platform: platform, platformtag: platformTag),
              fullscreenDialog: true,
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.transparent, // 휜 테두리 박스의 배경 색상
            border: Border.all(color: Colors.white), // 테두리 색상
            borderRadius: BorderRadius.circular(15.0), // 둥근 곡선 모서리
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.0),
                child: Image(
                  image: AssetImage(imageAsset),
                  width: 30.0,
                ),
              ),
              SizedBox(width: 10.0), // 이미지와 텍스트 사이 여백
              Text(
                buttonText,
                style: TextStyle(
                  color: Colors.white, // 버튼 안의 텍스트 색상
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
