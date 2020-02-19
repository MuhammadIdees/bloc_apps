class Subjects {
  final int id;
  final String title;
  final String image;
  final int color;

  Subjects({
    this.id,
    this.title,
    this.color,
    this.image
  });

  factory Subjects.fromJson(Map<String, dynamic> json) {
    return Subjects(
      id: json['id'],
      title: json['title'],
      color: int.parse(json['color']),
      image: json['image'],
    );
  }
}
