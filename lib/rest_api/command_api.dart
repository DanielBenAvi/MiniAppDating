import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:social_hive_client/model/boundaries/object_boundary.dart';
import 'package:social_hive_client/model/singleton_demo_object.dart';
import 'package:social_hive_client/rest_api/user_api.dart';

import 'base_api.dart';

class CommandApi extends BaseApi {
  SingletonDemoObject demoObject = SingletonDemoObject.instance;

  Future<ObjectBoundary?> getMyUserDetailsByEmail(String email) async {
    await UserApi().updateRole('MINIAPP_USER');
    // Create command

    Map<String, dynamic> command = {
      "commandId": {},
      "command": "GET_USER_DETAILS_BY_EMAIL",
      "targetObject": {
        "objectId": {
          "superapp": superApp,
          "internalObjectId": demoObject.uuid
        }
      },
      "invokedBy": {
        "userId": {"superapp": "2023b.LiorAriely", "email": email}
      },
      "commandAttributes": {}
    };

    // Post command
    http.Response response = await http.post(
      Uri.parse('http://$host:$portNumber/superapp/miniapp/DATING'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(command),
    );
    await UserApi().updateRole('SUPERAPP_USER');

    if (response.statusCode != 200) {
      debugPrint('LOG --- Failed to load UserDetails. Response Type: ${response.statusCode}');
      return null;
    }


    Map<String, dynamic> responseBody = jsonDecode(response.body);
    return ObjectBoundary.fromJson(responseBody.entries.first.value);
  }

  Future<List<ObjectBoundary?>?> getPotentialDates(String? email, ObjectBoundary? userDetails,
      ObjectBoundary? privateDatingProfile, int pageNum) async {
    await UserApi().updateRole('MINIAPP_USER');
    // Create command
    Map<String, dynamic> command = {
      "commandId": {},
      "command": "GET_POTENTIAL_DATES",
      "targetObject": {
        "objectId": privateDatingProfile?.objectId
      },
      "invokedBy": {
        "userId": {"superapp": "2023b.LiorAriely", "email": email}
      },
      "commandAttributes": {'page': pageNum ,'size': 2, 'userDetailsId': userDetails?.objectId}
    };

    // Post command
    http.Response response = await http.post(
      Uri.parse('http://$host:$portNumber/superapp/miniapp/DATING'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(command),
    );
    await UserApi().updateRole('SUPERAPP_USER');

    if (response.statusCode != 200) {
      debugPrint('LOG --- Failed to load potential dates. Response Type: ${response.statusCode}');
      return null;
    }
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    List<ObjectBoundary?> potentialDates = [];


    responseBody.forEach((key, value) {
      List<dynamic> dataList = value as List<dynamic>;
      for (var data in dataList) {
        potentialDates.add(ObjectBoundary.fromJson(data));
      }
    });


    return potentialDates;
  }

  Future<bool?> likeDatingProfile(ObjectBoundary? myDatingProfile, ObjectBoundary? targetDatingProfile,
      String? email) async {
    await UserApi().updateRole('MINIAPP_USER');
    // Create command
    Map<String, dynamic> command = {
      "commandId": {},
      "command": "LIKE_PROFILE",
      "targetObject": {
        "objectId": targetDatingProfile?.objectId
      },
      "invokedBy": {
        "userId": {"superapp": "2023b.LiorAriely", "email": email}
      },
      "commandAttributes": {'myDatingProfileId': myDatingProfile?.objectId }
    };

    // Post command
    http.Response response = await http.post(
      Uri.parse('http://$host:$portNumber/superapp/miniapp/DATING'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(command),
    );
    await UserApi().updateRole('SUPERAPP_USER');

    if (response.statusCode != 200) {
      debugPrint('LOG --- Failed to like profile. Response Type: ${response.statusCode}');
      return null;
    }
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    return responseBody[responseBody.keys.first]['like_status'];
  }

  Future<List<ObjectBoundary?>?> getMatches(String? email, ObjectBoundary? privateDatingProfile,
      int pageNum) async {
    await UserApi().updateRole('MINIAPP_USER');
    // Create command
    Map<String, dynamic> command = {
      "commandId": {},
      "command": "GET_MATCHES",
      "targetObject": {
        "objectId": privateDatingProfile?.objectId
      },
      "invokedBy": {
        "userId": {"superapp": "2023b.LiorAriely", "email": email}
      },
      "commandAttributes": {'page': pageNum ,'size': 2}
    };

    // Post command
    http.Response response = await http.post(
      Uri.parse('http://$host:$portNumber/superapp/miniapp/DATING'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(command),
    );
    await UserApi().updateRole('SUPERAPP_USER');

    if (response.statusCode != 200) {
      debugPrint('LOG --- Failed to load Matches. Response Type: ${response.statusCode}');
      return null;
    }
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    List<ObjectBoundary?> Matches = [];


    responseBody.forEach((key, value) {
      List<dynamic> dataList = value as List<dynamic>;
      for (var data in dataList) {
        Matches.add(ObjectBoundary.fromJson(data));
      }
    });


    return Matches;
  }
  Future<bool?> unMatch(ObjectBoundary? myDatingProfile, ObjectBoundary? targetDatingProfile,
      String? email) async {
    await UserApi().updateRole('MINIAPP_USER');
    // Create command
    Map<String, dynamic> command = {
      "commandId": {},
      "command": "UNMATCH_PROFILE",
      "targetObject": {
        "objectId": targetDatingProfile?.objectId
      },
      "invokedBy": {
        "userId": {"superapp": "2023b.LiorAriely", "email": email}
      },
      "commandAttributes": {'myDatingProfileId': myDatingProfile?.objectId }
    };

    // Post command
    http.Response response = await http.post(
      Uri.parse('http://$host:$portNumber/superapp/miniapp/DATING'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(command),
    );
    await UserApi().updateRole('SUPERAPP_USER');

    if (response.statusCode != 200) {
      debugPrint('LOG --- Failed to like profile. Response Type: ${response.statusCode}');
      return null;
    }
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    return responseBody[responseBody.keys.first]['like_status'];
  }


}
