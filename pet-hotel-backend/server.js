const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
const port = 3000;

app.use(bodyParser.json());
app.use(cors());

mongoose.connect('mongodb://localhost:27017/pet_hotel', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

const petSchema = new mongoose.Schema({
  tutorName: String,
  tutorContact: String,
  species: String,
  breed: String,
  checkInDate: Date,
  totalDays: Number,
  expectedCheckOutDate: Date,
  totalExpectedDays: Number,
});

const Pet = mongoose.model('Pet', petSchema);

app.get('/pets', async (req, res) => {
  const pets = await Pet.find();
  res.json(pets);
});

app.post('/pets', async (req, res) => {
  const newPet = new Pet(req.body);
  await newPet.save();
  res.status(201).json(newPet);
});

app.delete('/pets/:id', async (req, res) => {
  await Pet.findByIdAndDelete(req.params.id);
  res.status(204).send();
});

app.put('/pets/:id', async (req, res) => {
  const updatedPet = await Pet.findByIdAndUpdate(req.params.id, req.body, {
    new: true,
  });
  res.json(updatedPet);
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}/`);
});
