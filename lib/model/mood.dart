import 'dart:convert';

class Mood {
  final String id;
  final String content;
  final int mood;
  final DateTime date;
  Mood({
    this.id,
    this.content,
    this.mood,
    this.date,
  });

  Mood copyWith({
    String id,
    String content,
    int mood,
    DateTime date,
  }) {
    return Mood(
      id: id ?? this.id,
      content: content ?? this.content,
      mood: mood ?? this.mood,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'mood': mood,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory Mood.fromMap(Map<String, dynamic> map) {
    return Mood(
      id: map['\$id'],
      content: map['content'],
      mood: map['mood'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Mood.fromJson(String source) => Mood.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Mood(id: $id, content: $content, mood: $mood, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Mood &&
      other.id == id &&
      other.content == content &&
      other.mood == mood &&
      other.date == date;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      content.hashCode ^
      mood.hashCode ^
      date.hashCode;
  }
}
