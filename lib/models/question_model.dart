class QuizModel {
  final String question;
  final Map<String, String> options;
  final Map<String, int> optionScore;
  QuizModel(
      {required this.options,
      required this.question,
      required this.optionScore});
  factory QuizModel.fromJson(Map<String, dynamic> json) =>
      _quizModelFromJson(json);
  Map<String, dynamic> toJson() => _quizModelToJson(this);
}

QuizModel _quizModelFromJson(Map<String, dynamic> json) {
  return QuizModel(
    question: json['question'] as String,
    options: json['options'] as Map<String, String>,
    optionScore: json['optionScore'] as Map<String, int>,
  );
}

Map<String, dynamic> _quizModelToJson(QuizModel instance) => <String, dynamic>{
      'question': instance.question,
      'options': instance.options,
      'optionScore': instance.optionScore,
    };
