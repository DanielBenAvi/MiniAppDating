import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';

import 'package:social_hive_client/model/boundaries/object_boundary.dart';
import 'package:social_hive_client/model/boundaries/user_boundary.dart';
import 'package:social_hive_client/model/singleton_user.dart';
import 'package:social_hive_client/rest_api/base_api.dart';
import 'package:social_hive_client/rest_api/user_api.dart';

import '../model/PrivateDatingProfile.dart';

class ObjectApi extends BaseApi {
  Future<ObjectBoundary> postObject(ObjectBoundary objectBoundary) async {
    await UserApi().updateRole(
        'SUPERAPP_USER'); // update role to SUPERAPP_USER only SuperApp_user can create objects
    debugPrint('\n -- postObject');
    final response = await http.post(
      Uri.parse('http://$host:$portNumber/superapp/objects'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      encoding: Encoding.getByName('utf-8'),
      body: jsonEncode(objectBoundary.toJson()),
    );
    if (response.statusCode == 200) {
      ObjectBoundary objectBoundary =
      ObjectBoundary.fromJson(jsonDecode(response.body));
      SingletonUser singletonUser = SingletonUser.instance;
      debugPrint('objectBoundary: ${objectBoundary.toJson()}');
      return objectBoundary;
    } else {
      throw Exception('Failed to create Object.');
    }
  }

  Future<ObjectBoundary> getObjectBoundary(String internalObjectId) async {
    final client = RetryClient(http.Client());
    final response = await http.get(Uri.parse(
        'http://$host:$portNumber/superapp/objects/2023b.LiorAriely/$internalObjectId'));
    try {
      Map<String, dynamic> object = jsonDecode(response.body);
      return ObjectBoundary.fromJson(object);
    } finally {
      client.close();
    }
  }

  Future postObjectJson(Map<String, dynamic> objectBoundary) async {
    debugPrint('LOG --- POST Event');
    http.Response response = await http.post(
      Uri.parse('http://$host:$portNumber/superapp/objects'
          '?userSuperapp=$superApp&userEmail=${SingletonUser.instance.email}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(objectBoundary),
    );

    if (response.statusCode != 200) {
      debugPrint('LOG --- Failed to create event');
      throw Exception(response.body);
    } else {
      debugPrint('LOG --- Success to create event');
    }
  }
  ObjectBoundary createObjectBoundaryFromProfile(PrivateDatingProfile privateProfile, double lat, double lng, SingletonUser user) {


    final objectDetails = privateProfile.privateDatingProfileToMap();

    final objectBoundary = ObjectBoundary(
      objectId: ObjectId('',''),
      type: 'PrivateDatingProfile',
      alias: 'dating profile',
      active: true,
      creationTimestamp: DateTime.now(),
      location: Location(lat: lat, lng: lng),
      objectDetails: objectDetails,

      createdBy: CreatedBy(userId: UserId(superapp: '2023b.LiorAriely', email: user.email as String)),
    );

    return objectBoundary;
  }
  Future<ObjectBoundary?> postPrivateDatingProfile(
      Map<String, dynamic> privateDatingProfileMap, double lat, double lng) async {
    Map<String, dynamic> privateDatingProfile = {
      "objectId": {},
      "type": "PRIVATE_DATING_PROFILE",
      "alias": "privateDatingProfile",
      "active": true,
      "location": {"lat": lat, "lng": lng},
      "createdBy": {
        "userId": {"superapp": superApp, "email": user.email}
      },
      "objectDetails": privateDatingProfileMap,
    };
    http.Response response = await http.post(
      Uri.parse('http://$host:$portNumber/superapp/objects'
          '?userSuperapp=$superApp&userEmail=${user.email}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(privateDatingProfile),
    );

    if (response.statusCode != 200) {
      debugPrint('LOG --- Failed to create privateDatingProfile');
      return null;
    }

    Map<String, dynamic> responseBody = jsonDecode(response.body);
    return ObjectBoundary.fromJson(responseBody);
  }

  Future<bool> addChild(String internalObjectId, ObjectId childObjectId) async {
    final String? userEmail = UserApi().user.email;
    final String userSuperapp = superApp;

    Map<String, dynamic> requestBody = {
      'superapp': childObjectId.superapp,
      'internalObjectId': childObjectId.internalObjectId,
    };

    String requestBodyJson = jsonEncode(requestBody);
    debugPrint(requestBodyJson);
    debugPrint('$internalObjectId and $superApp');

    String url = 'http://$host:$portNumber/superapp/objects/$superApp/$internalObjectId/children?userSuperapp=$userSuperapp&userEmail=$userEmail';
    debugPrint('URL: $url');

    http.Response response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: requestBodyJson,
    );

    if(response.statusCode != 200){
      debugPrint("Error adding child. Status code: ${response.statusCode}");
      return false;
    }

    return true;
  }




  Future<List<ObjectBoundary>?> getChildren(String internalObjectId) async {
    int size = 1;
    int page = 0;
    final String? userEmail = UserApi().user.email;
    final String userSuperapp = superApp;
    String url = 'http://$host:$portNumber/superapp/objects/$superApp/$internalObjectId/'
        'children?userSuperapp=$userSuperapp&userEmail=$userEmail&size=$size&page=$page';

    http.Response response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Accept': 'application/json',
      },
    );

    if(response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      List<ObjectBoundary> children = jsonList.map((json) => ObjectBoundary.fromJson(json)).toList();
      return children;
    } else {
      debugPrint('Failed to get children. Status code: ${response.statusCode}');
      return null;
    }

  }








}
