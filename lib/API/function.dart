
import 'dart:convert';

import 'package:car_provider/API/url.dart';
import 'package:flutter/cupertino.dart';
import 'login.dart';
import 'model.dart';
import 'package:http/http.dart' as http;

Future<List<CarData>> getData() async {
  print('func called');
  print('this is access token : ${URLS.accessToken}');

  try {
    final response = await http.get(
      Uri.parse('http://192.168.0.152:8000/api/cars/'),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer ${URLS.accessToken}'
      },
    );
    print('get method status code ${response.statusCode}');
    if (response.statusCode != 200) {
      throw http.ClientException(response.reasonPhrase ?? response.body);
    }
    print(response.statusCode);
    print(response.reasonPhrase??response.body);
    final data = jsonDecode(response.body);
    print('this is get data $data');
    List<CarData> carData = [];
    for (var item in data['data']) {
      carData.add(CarData.fromJson(item));
    }
    print('this is carData $carData');
    return carData; ////

    // final listOfCarsData = data['data'].map((element) {
    //   return CarData.fromJson(element);
    // });
    // return listOfCarsData;
  } on Exception catch (e) {
    debugPrint(e.toString());
    rethrow;
  }
}

Future<void> loginOrSignUp({
  required String username,
  required String password,
  required String email,
  required bool isLogin,

})async {
  final body = {
    'username': username,
    'password': password,
  };


  if (isLogin) {
    // Perform login

    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.152:8000/api/login/'),
        headers: {
          'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> loginDetails = jsonDecode(response.body);
        URLS.refreshToken = loginDetails['data']['refresh_token'];
        URLS.accessToken = loginDetails['data']['access_token'];
        URLS.userid=loginDetails['data']['user']['id'];
        URLS.userName=loginDetails ['data']['user']['username'];

        print(loginDetails);
        print('logged in');
      }

      else {
        // Login failed
        print('Login failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during login: $e');
    }
  } else {
    // Perform signup
    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.152:8000/api/login/'),
        body: {'username': username, 'password': password, 'email': email},
      );
      if (response.statusCode == 200) {
        // Signup successful
        print('Signup successful');
      } else {
        // Signup failed
        print('Signup failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during signup: $e');
    }
  }
}
Future<bool> postData({
  required String carName,
  required String carVersion,
  required String carModel,
}) async {
  Map<String, String> data = {
    "car_name": carName,
    "car_version": carVersion,
    "car_model": carModel,
  };
  try {
    final jsonData = jsonEncode(data); // Convert the data map to JSON format
    final response = await http.post(
      Uri.parse(
          'http://192.168.0.152:8000/api/cars/'), // Use the URL from URLS.carsList
      headers: {
        'Content-Type': 'application/json', // Use JSON content type
        'authorization': 'Bearer ${URLS.accessToken}'
      },
      body: jsonData, // Send JSON data in the request body
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to post data: ${response.statusCode}  error is:${response.body}');
    }
    return true;
  } on Exception catch (e) {
    debugPrint('this is catch error - ${e.toString()}');
    return false;
  }
}
Future<void> deleteDataFromApi({required int id}) async {
  try {
    final response = await http.delete(
      Uri.parse(
          'http://192.168.0.152:8000/api/cars/'), // Replace 'your_api_endpoint' with the actual endpoint
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer ${URLS.accessToken}'
        // Add any additional headers if required
      },
      body: jsonEncode({'id': id}), // Encode the id as JSON in the request body
    );

    if (response.statusCode == 200) {
      // Data successfully deleted
      print('Data successfully deleted');
    } else {
      // Failed to delete data
      print('Failed to delete data: ${response.statusCode}');
      print('reason for failing data:${response.reasonPhrase}');
    }
  } catch (e) {
    // Exception occurred
    print('Exception occurred while deleting data: $e');
  }
}
Future<bool> postLikeData({
  required bool like,
  required int
  id, // Add a parameter to indicate if it's a like or unlike operation
}) async {
  final Map<String, dynamic> data = {
    "like": like, // Add the like parameter to the data map
  };

  try {
    final jsonData = jsonEncode(data); // Convert the data map to JSON format
    final response = await http.post(
      Uri.parse(
          'http://192.168.0.152:8000/api/cars/$id/like/'), // Use the URL from URLS.likeUrl
      headers: {
        'Content-Type': 'application/json', // Use JSON content type
        'authorization': 'Bearer ${URLS.accessToken}'
      },
      body: jsonData, // Send JSON data in the request body
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to post data: ${response.statusCode}  error is:${response.body}');
    }
    return true;
  } on Exception catch (e) {
    debugPrint('this is catch error - ${e.toString()}');
    return false;
  }
}



Future<void> postDislikeData({
  required int id,
}) async {
  try {
    final response = await http.delete(
        Uri.parse('http://192.168.0.152:8000/api/cars/$id/like/'),
        headers: {
          'Content-Type': 'application/json',
          'authorization':
          'Bearer ${URLS.accessToken}', // Replace with your access token
        },
        body: jsonEncode({'id': id}));

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to post data: ${response.statusCode}  error is:${response.body}');
    }

    //final Map<String, dynamic> responseData = jsonDecode(response.body);
    //final int newDislikeCount = responseData['dislikeCount'];

    // Update dislike count based on the like/dislike action
    //print('New Dislike Count: $newDislikeCount'); // Just for testing, you can remove this line
  } on Exception catch (e) {
    print('Error: $e');
  }
}
Future<void> postCommentData({
  required String comment,
  required int carId,

  // Add a parameter to indicate the item ID for commenting
}) async {
  final Map<String, dynamic> data = {
    "comment": comment,
    "user": URLS.userid,
    "car":carId,

    // Add the comment parameter to the data map
  };

  try {
    final jsonData = jsonEncode(data); // Convert the data map to JSON format
    final response = await http.post(
      Uri.parse(
          'http://192.168.0.155:8000/api/comments/'), // Use the comment URL
      headers: {
        'Content-Type': 'application/json', // Use JSON content type
        'Authorization': 'Bearer ${URLS.accessToken}'
      },
      body: jsonData, // Send JSON data in the request body
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to post comment: ${response.statusCode}  error is:${response.body}');
    }
  } on Exception catch (e) {
    print('Error posting comment: $e');
  }
}
