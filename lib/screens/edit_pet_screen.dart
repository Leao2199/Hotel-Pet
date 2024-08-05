import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/pet.dart';
import '../services/api_service.dart';

class EditPetScreen extends StatefulWidget {
  final Pet pet;

  EditPetScreen({required this.pet});

  @override
  _EditPetScreenState createState() => _EditPetScreenState();
}

class _EditPetScreenState extends State<EditPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tutorNameController = TextEditingController();
  final _tutorContactController = TextEditingController();
  final _speciesController = TextEditingController();
  final _breedController = TextEditingController();
  final _checkInDateController = TextEditingController();
  final _totalDaysController = TextEditingController();
  final _expectedCheckOutDateController = TextEditingController();
  final _totalExpectedDaysController = TextEditingController();
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _tutorNameController.text = widget.pet.tutorName;
    _tutorContactController.text = widget.pet.tutorContact;
    _speciesController.text = widget.pet.species;
    _breedController.text = widget.pet.breed;
    _checkInDateController.text =
        DateFormat('yyyy-MM-dd').format(widget.pet.checkInDate);
    _totalDaysController.text = widget.pet.totalDays.toString();
    _expectedCheckOutDateController.text =
        DateFormat('yyyy-MM-dd').format(widget.pet.expectedCheckOutDate);
    _totalExpectedDaysController.text = widget.pet.totalExpectedDays.toString();
  }

  @override
  void dispose() {
    _tutorNameController.dispose();
    _tutorContactController.dispose();
    _speciesController.dispose();
    _breedController.dispose();
    _checkInDateController.dispose();
    _totalDaysController.dispose();
    _expectedCheckOutDateController.dispose();
    _totalExpectedDaysController.dispose();
    super.dispose();
  }

  Future<void> _updatePet() async {
    if (_formKey.currentState!.validate()) {
      DateTime checkInDate =
          DateFormat('yyyy-MM-dd').parse(_checkInDateController.text);
      DateTime expectedCheckOutDate =
          DateFormat('yyyy-MM-dd').parse(_expectedCheckOutDateController.text);
      int totalDays = int.parse(_totalDaysController.text);
      int totalExpectedDays = int.parse(_totalExpectedDaysController.text);

      Pet updatedPet = Pet(
        id: widget.pet.id,
        tutorName: _tutorNameController.text,
        tutorContact: _tutorContactController.text,
        species: _speciesController.text,
        breed: _breedController.text,
        checkInDate: checkInDate,
        totalDays: totalDays,
        expectedCheckOutDate: expectedCheckOutDate,
        totalExpectedDays: totalExpectedDays,
      );

      await apiService.updatePet(widget.pet.id!, updatedPet);

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Pet'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tutorNameController,
                decoration: InputDecoration(labelText: 'Nome do Tutor'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o nome do tutor';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _tutorContactController,
                decoration: InputDecoration(labelText: 'Contato do Tutor'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o contato do tutor';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _speciesController,
                decoration: InputDecoration(labelText: 'Espécie'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira a espécie';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _breedController,
                decoration: InputDecoration(labelText: 'Raça'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira a raça';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _checkInDateController,
                decoration:
                    InputDecoration(labelText: 'Data de Check-In (YYYY-MM-DD)'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira a data de check-in';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _totalDaysController,
                decoration: InputDecoration(labelText: 'Total de Dias'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o total de dias';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _expectedCheckOutDateController,
                decoration: InputDecoration(
                    labelText: 'Data Prevista de Check-Out (YYYY-MM-DD)'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira a data prevista de check-out';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _totalExpectedDaysController,
                decoration:
                    InputDecoration(labelText: 'Total de Dias Previsto'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o total de dias previsto';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updatePet,
                child: Text('Atualizar Pet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
