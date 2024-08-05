class Pet {
  final String? id; // Certifique-se de que o ID pode ser nulo
  final String tutorName;
  final String tutorContact;
  final String species;
  final String breed;
  final DateTime checkInDate;
  final int totalDays;
  final DateTime expectedCheckOutDate;
  final int totalExpectedDays;

  Pet({
    this.id,
    required this.tutorName,
    required this.tutorContact,
    required this.species,
    required this.breed,
    required this.checkInDate,
    required this.totalDays,
    required this.expectedCheckOutDate,
    required this.totalExpectedDays,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['_id'], // MongoDB usa "_id" como identificador
      tutorName: json['tutorName'],
      tutorContact: json['tutorContact'],
      species: json['species'],
      breed: json['breed'],
      checkInDate: DateTime.parse(json['checkInDate']),
      totalDays: json['totalDays'],
      expectedCheckOutDate: DateTime.parse(json['expectedCheckOutDate']),
      totalExpectedDays: json['totalExpectedDays'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'tutorName': tutorName,
      'tutorContact': tutorContact,
      'species': species,
      'breed': breed,
      'checkInDate': checkInDate.toIso8601String(),
      'totalDays': totalDays,
      'expectedCheckOutDate': expectedCheckOutDate.toIso8601String(),
      'totalExpectedDays': totalExpectedDays,
    };
  }
}
