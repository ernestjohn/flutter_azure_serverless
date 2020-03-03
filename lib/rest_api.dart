import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class URLS {
  static const String POST_URL = 'https://prod-63.westeurope.logic.azure.com:443/workflows/045043bcb0604d8a8fa4cdafadd26bae/triggers/manual/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=8Xgx5KYmVSUpnjXyrU5B_01lZ_63H-xQbfh_cmPIjfQ';
  static const String GET_URL = 'https://prod-45.westeurope.logic.azure.com:443/workflows/fb85053502c7447292c73a6409ff18eb/triggers/manual/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=1TBzE0hNP0MmOp1MAP6cYKBjl1zToY8qo0qfQhPRS0g';
}

class ApiService {
  static Future<List<dynamic>> getEvents() async {
    // RESPONSE JSON :
    // [{
    //   "id": "1",
    //   "employee_name": "",
    //   "employee_salary": "0",
    //   "employee_age": "0",
    //   "profile_image": ""
    // }]
    final response = await http.get(URLS.GET_URL);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }

  static Future<bool> addEvent(body) async {
    // BODY
    // {
    //   "name": "test",
    //   "age": "23"
    // }
   // final response = await http.post(
   //   URLS.POST_URL,
    //  headers:{HttpHeaders.contentTypeHeader : ContentType.json},
    //   body: body);
    
    Map<String,String> headers = {
      'Content-type' : 'application/json', 
      'Accept': 'application/json',
    };

    final response =
        await http.post(URLS.POST_URL, body: json.encode(body), headers: headers);
    

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
