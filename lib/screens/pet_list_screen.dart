import 'package:flutter/material.dart';
import 'package:hoteldepet/models/pet.dart';
import 'package:hoteldepet/services/api_service.dart';
import 'package:hoteldepet/screens/add_pet_screen.dart';
import 'package:hoteldepet/screens/edit_pet_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Hotel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PetListScreen(),
    );
  }
}

class PetListScreen extends StatefulWidget {
  @override
  _PetListScreenState createState() => _PetListScreenState();
}

class _PetListScreenState extends State<PetListScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Pet>> futurePets;

  @override
  void initState() {
    super.initState();
    futurePets = apiService.fetchPets();
  }

  void refreshPets() {
    setState(() {
      futurePets = apiService.fetchPets();
    });
  }

  void deletePet(String id) async {
    try {
      await apiService.deletePet(id);
      refreshPets();
    } catch (e) {
      // Remove qualquer mensagem de erro aqui
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotel de Pet'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: refreshPets,
          ),
        ],
      ),
      body: FutureBuilder<List<Pet>>(
        future: futurePets,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum pet encontrado.'));
          } else {
            final pets = snapshot.data!;
            return ListView.builder(
              itemCount: pets.length,
              itemBuilder: (context, index) {
                final pet = pets[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Column(
                    children: [
                      ListTile(
                        title: Container(
                          color: Colors.red,
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              pet.tutorName,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        subtitle: Center(
                            child: Text('${pet.species} - ${pet.breed}')),
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPetScreen(pet: pet),
                            ),
                          );
                          if (result != null) {
                            refreshPets();
                          }
                        },
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deletePet(pet.id!),
                        ),
                      ),
                      Divider(color: Colors.grey),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPetScreen()),
          );
          if (result != null) {
            refreshPets();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
