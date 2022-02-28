class Entry {
  int? eid;
  String? title;
  String? description;
  DateTime? date;
  int? mood;
  String? weather;

  Entry(
      {this.eid,
      this.title,
      this.description,
      this.date,
      this.mood,
      this.weather});

  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      eid: json["eid"],
      title: json["title"],
      description: json["desc"],
      date: DateTime.parse(json["date"]),
      mood: json['mood'],
      weather: json['weather'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if(eid != null) "eid": eid,
      "title": title,
      "desc": description,
      "date": date!.toIso8601String(),
      "mood": mood,
      "weather": weather,
    };
  }

  Entry copyWith({
    int? eid,
    String? title,
    String? description,
    DateTime? date,
    int? mood,
    String? weather,
  }) {
    return Entry(
      eid: this.eid,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      mood: mood ?? this.mood,
      weather: weather ?? this.weather,
    );
  }
}
