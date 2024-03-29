require("dotenv").config();

const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const app = express();
const path = require("path");
const City = require("./models/city.model");
const Trip = require("./models/trip.model");

app.use(cors());
mongoose.set("debug", true);
mongoose
  .connect(
    `mongodb+srv://${process.env.DB_USER}:${process.env.DB_PASS}` +
      `@${process.env.DB_HOST}/${process.env.DB_NAME}?retryWrites=true&w=majority`
  )
  .then(() => console.log("connexion ok !"))
  .catch((err) => console.error("Erreur de connexion à MongoDB:", err));

app.use(express.static(path.join(__dirname, "public")));
app.use(express.json());

app.get("/api/cities", async (req, res) => {
  try {
    const cities = await City.find({}).exec();
    res.json(cities);
  } catch (e) {
    res.status(500).json(e);
  }
});

app.get("/api/trips", async (req, res) => {
  try {
    const trips = await Trip.find({}).exec();
    res.json(trips);
  } catch (e) {
    res.status(500).json(e);
  }
});

app.post("/api/trip", async (req, res) => {
  try {
    const body = req.body;
    const trip = await new Trip(body).save();
    res.json(trip);
  } catch (e) {
    res.status(500).json(e);
  }
});

app.put("/api/trip", async (req, res) => {
  try {
    const body = req.body;
    const trip = await Trip.findOneAndUpdate({ _id: body._id }, body, {
      new: true,
    }).exec();
    res.json(trip);
  } catch (e) {
    res.status(500).json(e);
  }
});

app.listen(80);
