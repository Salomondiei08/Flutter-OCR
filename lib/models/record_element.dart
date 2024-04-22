class RecordElement {
  final String name;
  final String imagePath;
  final Map<String, dynamic> data;
  DateTime date;

  RecordElement({
    required this.name,
    required this.imagePath,
    required this.data,
    required this.date,
  });
}
