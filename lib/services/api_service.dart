import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pet.dart';

class ApiService {
  final String baseUrl = 'http://192.168.1.10:3000';

  Future<List<Pet>> fetchPets() async {
    final response = await http.get(Uri.parse('$baseUrl/pets'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((pet) => Pet.fromJson(pet)).toList();
    } else {
      throw Exception('Failed to load pets');
    }
  }

  Future<void> addPet(Pet pet) async {
    final response = await http.post(
      Uri.parse('$baseUrl/pets'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(pet.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print("Pet added successfully: ${response.body}");
    } else {
      throw Exception('Failed to add pet: ${response.body}');
    }
  }

  Future<void> deletePet(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/pets/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete pet');
    }
  }

  Future<void> updatePet(String id, Pet updatedPet) async {
    final response = await http.put(
      Uri.parse('$baseUrl/pets/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(updatedPet.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update pet');
    }
  }
}
