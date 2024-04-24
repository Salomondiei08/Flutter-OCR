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
}
