class Band {
  const Band({required this.id, required this.name, required this.votes});

  final String id;
  final String name;
  final int votes;

  factory Band.fromMap(Map<String, dynamic> obj) =>
      Band(id: obj['id'], name: obj['name'], votes: obj['votes']);
}
