
import 'package:birca/view/onboarding/onboardingView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() => _Login();
}

class _Login extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('lib/assets/image/img_logo.png'),
            const SizedBox(
              height: 10,
            ),
            SvgPicture.asset('lib/assets/image/img_logo_text.svg'),
            const SizedBox(
              height: 64,
            ),
            GestureDetector(
              onTap: () async {
                await kakaoLogin();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const OnBoardingView()));
              },
              child:
              Image.asset('lib/assets/image/kakao_login_medium_wide.png'),
            ),
            const SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () {},
              child: Image.asset(
                'lib/assets/image/apple_login.png',
                width: 300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> kakaoLogin() async {
  // 카카오 로그인 구현 예제

// 카카오톡 실행 가능 여부 확인
// 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
  if (await isKakaoTalkInstalled()) {
    try {

      //token
      OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
      User user = await UserApi.instance.me();
      print('사용자 정보 요청 성공'
          '\n회원번호: ${user.id}'
          '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
          '\n이메일: ${user.kakaoAccount?.email}');
      print('카카오톡으로 로그인 성공 \n 토큰: ${token.accessToken}');
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');

      // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
      // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
      if (error is PlatformException && error.code == 'CANCELED') {
        return;
      }
      // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
      try {

        //token
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        User user = await UserApi.instance.me();
        print('사용자 정보 요청 성공'
            '\n회원번호: ${user.id}'
            '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
            '\n이메일: ${user.kakaoAccount?.email}');
        print('카카오계정으로 로그인 성공  \n 토큰: ${token.accessToken}');
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  } else {
    try {

      //token
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      User user = await UserApi.instance.me();
      print('사용자 정보 요청 성공'
          '\n회원번호: ${user.id}'
          '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
          '\n이메일: ${user.kakaoAccount?.email}');
      print('카카오계정으로 로그인 성공  \n 토큰: ${token.accessToken}');


    } catch (error) {
      print('카카오계정으로 로그인 실패 $error');
    }
  }
}