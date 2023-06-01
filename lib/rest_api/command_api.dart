import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:social_hive_client/model/boundaries/object_boundary.dart';
import 'package:social_hive_client/rest_api/user_api.dart';

import 'base_api.dart';

class CommandApi extends BaseApi {
  /// get all events that the user is participating in
  Future<ObjectBoundary?> getMyUserDetailsByEmail(String email) async {
    UserApi().updateRole('MINIAPP_USER');
    // Create command
    Map<String, dynamic> command = {
      "commandId": {},
      "command": "GET_USER_DETAILS_BY_EMAIL",
      "targetObject": {
        "objectId": {
          "superapp": superApp,
          "internalObjectId": demoObjectInternalObjectId
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
    UserApi().updateRole('SUPERAPP_USER');

    if (response.statusCode != 200) {
      debugPrint('LOG --- Failed to load UserDetails. Response Type: ${response.statusCode}');
      return null;
    }


    Map<String, dynamic> responseBody = jsonDecode(response.body);
    return ObjectBoundary.fromJson(responseBody);
  }


}
