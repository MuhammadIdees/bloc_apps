import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:flutter/services.dart' show rootBundle;

import 'package:login_app/constants.dart';
import 'package:login_app/models/mcqs_question.dart';

class McqRepository {
  Future<List<MultipleChoiceQuestion>> get(String subject) async {
    // var mcqJson = await rootBundle.loadString(chemistryMCQJsonPath);
    var response = await http.get(mcqJson + subject);

    if (response.statusCode == 200){
    var mcqJsonList = json.decode(response.body) as List;
    var mcqs = mcqJsonList
        .map((categoryJson) => MultipleChoiceQuestion.fromJson(categoryJson))
        .toList();

        if (mcqs.length == 0){
          throw Exception("No Data");
        } else { 
          return mcqs;
        }
    } else  {
      throw Exception('Failed to load post');
    }
  }

}