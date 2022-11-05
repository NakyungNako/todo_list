class Todo {
  int? id;
  String? title;
  String? description;
  DateTime? date;
  bool? status;

  Todo({
    this.id,
    this.title,
    this.description,
    this.date,
    this.status,
  }) {
    id = id;
    title = title;
    description = description;
    date = date;
    status = status;
  }

  toJson() {
    return {
      "id": id,
      "description": description,
      "title": title,
      "date": date.toString(),
      "status": status
    };
  }

  fromJson(jsonData) {
    return Todo(
        id: jsonData['id'],
        title: jsonData['title'],
        description: jsonData['description'],
        date: DateTime.parse(jsonData['date']),
        status: jsonData['status'],
    );
  }
}