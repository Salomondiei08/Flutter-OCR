class RecordElement {
  final String id;
  final String name;
  final String imagePath;
  final String resaon;
  final String vistedPerson;

  Map<String, dynamic> data;
  DateTime date;

  RecordElement({
    required this.name,
    required this.imagePath,
    required this.vistedPerson,
    required this.resaon,
    required this.id,
    required this.data,
    required this.date,
  });

  // generate from json
  factory RecordElement.fromJson(Map<String, dynamic> json) {
    return RecordElement(
      name: json['name'],
      imagePath: json['imagePath'],
      vistedPerson: json['vistedPerson'],
      resaon: json['resaon'],
      id: json['id'],
      data: json['data'],
      date: json['date'],
    );
  }

  // generate to json
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imagePath': imagePath,
      'vistedPerson': vistedPerson,
      'resaon': resaon,
      'id': id,
      'data': data,
      'date': date,
    };
  }
}
