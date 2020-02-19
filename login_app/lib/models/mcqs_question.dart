class MultipleChoiceQuestion {
  final String id;
  final String question;
  final String option1;
  final String option2;
  final String option3;
  final String option4;
  final int answer;

  MultipleChoiceQuestion({
    this.id,
    this.question,
    this.option1,
    this.option2,
    this.option3,
    this.option4,
    this.answer
  });

  factory MultipleChoiceQuestion.fromJson(Map<String, dynamic> json) {
    return MultipleChoiceQuestion(
      id: json['id'],
      question: json['question'],
      option1: json['option 1'],
      option2: json['option 2'],
      option3: json['option 3'],
      option4: json['option 4'],
      answer: int.parse(json['answer']),
    );
  }
}
