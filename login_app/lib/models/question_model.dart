import 'dart:convert';

List<Question> questionFromJson(String str) => List<Question>.from(json.decode(str).map((x) => Question.fromJson(x)));

String questionToJson(List<Question> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Question {
    String question;
    String chapter;
    List<String> type;
    List<String> years;

    Question({
        this.question,
        this.chapter,
        this.type,
        this.years,
    });

    factory Question.fromJson(Map<String, dynamic> json) => Question(
        question: json["question"],
        chapter: json["chapter"],
        type: List<String>.from(json["type"].map((x) => x)),
        years: List<String>.from(json["years"].map((x) => x)),
    );

    Map<String, dynamic> toMap() => {
        "question": question,
        "chapter": chapter,
        "type": List<dynamic>.from(years.map((x) => x)),
        "years": List<dynamic>.from(years.map((x) => x)),
    };
}
