import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:login_app/constants.dart';
import 'package:login_app/models/question_model.dart';
import 'package:login_app/ui/question_screen.dart';


class QuestionRepository {

  Future<List<Question>> get(int subjectId, JsonRequest request, bool islong) async {

    print(request.type);

    Map<String, dynamic> data = {
      "subject"   : subjectId,
      "chapters"  : request.chapters,
      "years"     : request.years,
      "type"      : request.type,
      "islong"    : islong,
    };

    final questionJson = await http.post(quesJson,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: json.encode(data)
    );

    if (questionJson.statusCode == 200){
      var quesitonList = json.decode(questionJson.body) as List;
      var questions = quesitonList
          .map((categoryJson) => Question.fromJson(categoryJson))
          .toList();

        if (questions.length == 0){
          throw Exception("No Data");
        } else { 
          return questions;
        }
    } else  {
      throw Exception('Failed to load post');
    }
    
  }
}