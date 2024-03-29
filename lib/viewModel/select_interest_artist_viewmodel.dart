import 'dart:convert';
import 'dart:developer';

import 'package:birca/model/group_artist_model.dart';
import 'package:birca/model/solo_artist_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SelectInterestArtistViewModel extends ChangeNotifier {
  Dio dio = Dio();
  List<SoloArtistModel>? _soloArtist;
  List<SoloArtistModel>? get soloArtist => _soloArtist;

  List<GroupArtistModel>? _groupArtist;
  List<GroupArtistModel>? get groupArtist => _groupArtist;

  List<SoloArtistModel>? _groupMember;
  List<SoloArtistModel>? get groupMember => _groupMember;

  bool _isSelectGroupArtist = true;
  bool get isSelectGroupArtist => _isSelectGroupArtist;

  bool _isSelectSoloArtist = false;
  bool get isSelectSoloArtist => _isSelectSoloArtist;

  int _groupArtistCount = 0;
  int get groupArtistCount => _groupArtistCount;

  int _soloArtistCount = 0;
  int get soloArtistCount => _soloArtistCount;

  int _groupMemberCount = 0;
  int get groupMemberCount => _groupMemberCount;

  List<SoloArtistModel> _selectedArtist = [];
  List<SoloArtistModel> get selectedArtist => _selectedArtist;

  void updateArtistType() {
    _isSelectGroupArtist = !_isSelectGroupArtist;
    _isSelectSoloArtist = !_isSelectSoloArtist;
    notifyListeners();
  }

  void updateSelectedArtist(SoloArtistModel artist) {
    if(!_selectedArtist.contains(artist) && _selectedArtist.length < 10) {
      _selectedArtist.add(artist);
      log(_selectedArtist.toString());
      notifyListeners();
    }
  }

  void removeSelectedArtist(SoloArtistModel artist) {
    _selectedArtist.remove(artist);
    notifyListeners();
  }

  SelectInterestArtistViewModel() {
    getSoloArtist();
    getGroupArtist();
  }

  Future<void> getSoloArtist() async {
    const storage = FlutterSecureStorage();
    var baseUrl = dotenv.env['BASE_URL'];
    var token = '';
    var kakaoLoginInfo = await storage.read(key: 'kakaoLoginInfo');

    if (kakaoLoginInfo != null) {
      Map<String, dynamic> loginData = json.decode(kakaoLoginInfo);
      token = loginData['accessToken'].toString();
    }

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    try {
      Response response = await dio.get(
          '${baseUrl}api/v1/artists/solo',
          options: Options(headers: {'Authorization': 'Bearer $token'})
      );
      _soloArtist = (response.data as List).map((item) => SoloArtistModel.fromJson(item)).toList();
      _soloArtistCount = _soloArtist!.length;
      notifyListeners();
    } catch (e) {
      log("error:$e");
    }
  }

  Future<void> getGroupArtist() async {
    const storage = FlutterSecureStorage();
    var baseUrl = dotenv.env['BASE_URL'];
    var token = '';
    var kakaoLoginInfo = await storage.read(key: 'kakaoLoginInfo');

    if (kakaoLoginInfo != null) {
      Map<String, dynamic> loginData = json.decode(kakaoLoginInfo);
      token = loginData['accessToken'].toString();
    }

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    try {
      Response response = await dio.get(
          '${baseUrl}api/v1/artist-groups',
          options: Options(headers: {'Authorization': 'Bearer $token'})
      );
      _groupArtist = (response.data as List).map((item) => GroupArtistModel.fromJson(item)).toList();
      _groupArtistCount = _groupArtist!.length;
      notifyListeners();
    } catch (e) {
      log("error:$e");
    }
  }

  Future<void> getGroupMember(int groupId) async {
    const storage = FlutterSecureStorage();
    var baseUrl = dotenv.env['BASE_URL'];
    var token = '';
    var kakaoLoginInfo = await storage.read(key: 'kakaoLoginInfo');

    if (kakaoLoginInfo != null) {
      Map<String, dynamic> loginData = json.decode(kakaoLoginInfo);
      token = loginData['accessToken'].toString();
    }

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    try {
      Response response = await dio.get(
          '${baseUrl}api/v1/artist-groups/$groupId/artists',
          options: Options(headers: {'Authorization': 'Bearer $token'})
      );
      _groupMember = (response.data as List).map((item) => SoloArtistModel.fromJson(item)).toList();
      _groupMemberCount = _groupMember!.length;
      notifyListeners();
    } catch (e) {
      log("error:$e");
    }
  }

  Future<void> postInterestArtist() async {
    const storage = FlutterSecureStorage();
    var baseUrl = dotenv.env['BASE_URL'];
    var token = '';
    var kakaoLoginInfo = await storage.read(key: 'kakaoLoginInfo');

    if (kakaoLoginInfo != null) {
      Map<String, dynamic> loginData = json.decode(kakaoLoginInfo);
      token = loginData['accessToken'].toString();
    }

    List<Map<String, dynamic>> artistIdList = _selectedArtist.map((artist) {
      return {'artistId': artist.groupId};
    }).toList();

    try {
      await dio.post(
          '${baseUrl}api/v1/artists/interest',
          data: artistIdList,
          options: Options(headers: {'Authorization': 'Bearer $token'})
      );
    } catch(e) {
      log("error: $e");
    }
  }
}