import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/pet.dart';
import '../services/api_service.dart';

class AddPetScreen extends StatefulWidget {
  @override
  _AddPetScreenState createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
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

  Future<void> _addPet() async {
    if (_formKey.currentState!.validate()) {
      try {
        DateTime checkInDate =
            DateFormat('yyyy-MM-dd').parse(_checkInDateController.text);
        DateTime expectedCheckOutDate = DateFormat('yyyy-MM-dd')
            .parse(_expectedCheckOutDateController.text);
        int totalDays = int.parse(_totalDaysController.text);
        int totalExpectedDays = int.parse(_totalExpectedDaysController.text);

        Pet pet = Pet(
          tutorName: _tutorNameController.text,
          tutorContact: _tutorContactController.text,
          species: _speciesController.text,
          breed: _breedController.text,
          checkInDate: checkInDate,
          totalDays: totalDays,
          expectedCheckOutDate: expectedCheckOutDate,
          totalExpectedDays: totalExpectedDays,
        );

        await apiService.addPet(pet);
        Navigator.pop(context,
            true); // Retornar 'true' para indicar que o pet foi adicionado
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Falha ao adicionar pet: $e'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Pet'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
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
                decoration: InputDecoration(labelText: 'Data de Entrada'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira a data de entrada';
                  }
                  return null;
                },
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101));
                  if (picked != null) {
                    setState(() {
                      _checkInDateController.text =
                          DateFormat('yyyy-MM-dd').format(picked);
                    });
                  }
                },
              ),
              TextFormField(
                controller: _totalDaysController,
                decoration: InputDecoration(labelText: 'Diárias até o momento'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira as diárias até o momento';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _expectedCheckOutDateController,
                decoration: InputDecoration(labelText: 'Previsão de Saída'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira a previsão de saída';
                  }
                  return null;
                },
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101));
                  if (picked != null) {
                    setState(() {
                      _expectedCheckOutDateController.text =
                          DateFormat('yyyy-MM-dd').format(picked);
                    });
                  }
                },
              ),
              TextFormField(
                controller: _totalExpectedDaysController,
                decoration:
                    InputDecoration(labelText: 'Diárias Totais Previstas'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira as diárias totais previstas';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addPet,
                child: Text('Adicionar Pet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
