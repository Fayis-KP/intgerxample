// class ListModel {
//   int userId;
//   int id;
//   String title;
//   String body;
//
//   ListModel({
//     required this.userId,
//     required this.id,
//     required this.title,
//     required this.body,
//   });
//
//   factory ListModel.fromJson(Map<String, dynamic> json) => ListModel(
//     userId: json["userId"],
//     id: json["id"],
//     title: json["title"],
//     body: json["body"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "userId": userId,
//     "id": id,
//     "title": title,
//     "body": body,
//   };
//
//   static List<ListModel> fromJsonList(List<dynamic> jsonList) {
//     return jsonList.map((json) => ListModel.fromJson(json)).toList();
//   }
// }

class ListModel {
  int userId;
  int id; // Made mutable to allow editing
  String title; // Made mutable to allow editing
  String body; // Made mutable to allow editing

  ListModel({required this.userId, required this.id, required this.title, required this.body});

  factory ListModel.fromJson(Map<String, dynamic> json) {
    return ListModel(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }

  static List<ListModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ListModel.fromJson(json)).toList();
  }
}
