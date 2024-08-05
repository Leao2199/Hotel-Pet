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
  final _breedController = TextEditingController();
  final _checkInDateController = TextEditingController();
  final _totalDaysController = TextEditingController();
  final _expectedCheckOutDateController = TextEditingController();
  final _totalExpectedDaysController = TextEditingController();
  final ApiService apiService = ApiService();

  String? _selectedSpecies;
  final List<String> _speciesOptions = ['Cachorro', 'Gato'];

  Future<void> _addPet() async {
    if (_formKey.currentState!.validate()) {
      try {
        DateTime checkInDate =
            DateFormat('yyyy-MM-dd').parse(_checkInDateController.text);
        DateTime expectedCheckOutDate = DateFormat('yyyy-MM-dd')
            .parse(_expectedCheckOutDateController.text);
        int totalDays = int.parse(_totalDaysController.text);
        int totalExpectedDays = int.parse(_totalExpectedDaysController.text);

        Pet newPet = Pet(
          tutorName: _tutorNameController.text,
          tutorContact: _tutorContactController.text,
          species: _selectedSpecies!,
          breed: _breedController.text,
          checkInDate: checkInDate,
          totalDays: totalDays,
          expectedCheckOutDate: expectedCheckOutDate,
          totalExpectedDays: totalExpectedDays,
        );

        await apiService.addPet(newPet);

        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao adicionar pet: $e')),
        );
      }
    }
  }

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? selectedDate = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    // Exibe o DatePicker
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    // Se o usuário selecionar uma data, atualiza o controlador
    if (picked != null && picked != selectedDate) {
      setState(() {
        controller.text = formatter.format(picked);
      });
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
            children: [
              TextFormField(
                controller: _tutorNameController,
                decoration: InputDecoration(
                  labelText: 'Nome do Tutor',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o nome do tutor';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _tutorContactController,
                decoration: InputDecoration(
                  labelText: 'Contato do Tutor',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o contato do tutor';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedSpecies,
                hint: Text('Selecione a Espécie'),
                items: _speciesOptions.map((String species) {
                  return DropdownMenuItem<String>(
                    value: species,
                    child: Text(species),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSpecies = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecione a espécie';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _breedController,
                decoration: InputDecoration(
                  labelText: 'Raça',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira a raça';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _checkInDateController,
                decoration: InputDecoration(
                  labelText: 'Data de Check-In (YYYY-MM-DD)',
                  border: OutlineInputBorder(),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _selectDate(_checkInDateController);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira a data de check-in';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _totalDaysController,
                decoration: InputDecoration(
                  labelText: 'Total de Dias',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o total de dias';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _expectedCheckOutDateController,
                decoration: InputDecoration(
                  labelText: 'Data Prevista de Check-Out (YYYY-MM-DD)',
                  border: OutlineInputBorder(),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _selectDate(_expectedCheckOutDateController);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira a data prevista de check-out';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _totalExpectedDaysController,
                decoration: InputDecoration(
                  labelText: 'Total de Dias Previsto',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o total de dias previsto';
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
