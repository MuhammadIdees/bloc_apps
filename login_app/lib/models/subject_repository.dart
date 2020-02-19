import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'package:login_app/constants.dart';
import 'package:login_app/models/subject_category.dart';

class SubjectRepository {
  Future<List<Subjects>> get() async {
    var menuJson = await rootBundle.loadString(designPatternsJsonPath);
    var designPatternCategoryJsonList = json.decode(menuJson) as List;
    var mainMenuSections = designPatternCategoryJsonList
        .map((categoryJson) => Subjects.fromJson(categoryJson))
        .toList();

    return mainMenuSections;
  }
}