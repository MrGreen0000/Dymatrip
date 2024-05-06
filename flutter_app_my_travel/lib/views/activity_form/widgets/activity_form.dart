import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:my_travel/apis/google_api.dart';
import 'package:my_travel/models/activity.model.dart';
import 'package:my_travel/providers/city_provider.dart';
import 'package:my_travel/views/activity_form/widgets/activity_%20form_image_picker.dart';
import 'package:my_travel/views/activity_form/widgets/activity_form_autocomplete.dart';
import 'package:provider/provider.dart';

class ActivityForm extends StatefulWidget {
  final String cityName;

  const ActivityForm({super.key, required this.cityName});

  @override
  State<ActivityForm> createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late FocusNode _priceFocusNode;
  late FocusNode _urlFocusNode;
  late FocusNode _addressFocusNode;
  late Activity _newActivity;
  late String? _nameInputAsync;
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _isLoading = false;

  FormState get form {
    return _formKey.currentState!;
  }

  @override
  void initState() {
    _newActivity = Activity(
        city: widget.cityName,
        name: '',
        image: '',
        price: 0,
        location:
            LocationActivity(address: null, longitude: null, latitude: null),
        status: ActivityStatus.ongoing);
    _priceFocusNode = FocusNode();
    _urlFocusNode = FocusNode();
    _addressFocusNode = FocusNode();
    _addressFocusNode.addListener(() async {
      if (_addressFocusNode.hasFocus) {
        var location = await showInputAutocomplete(context);
        _newActivity.location = location;
        setState(() {
          if (location != null) {
            _addressController.text = location.address!;
          }
        });
        _urlFocusNode.requestFocus();
      }
    });
    super.initState();
  }

  void updateUrlField(String url) {
    setState(() {
      _urlController.text = url;
    });
  }

  void _getCurrentLocation() async {
    try {
      Location location = Location();
      LocationData userLocation;
      bool serviceEnabled;
      PermissionStatus permissionGranted;

      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return;
        }
      }
      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      userLocation = await location.getLocation();

      String address = await getAddressFromLatLng(
          lat: userLocation.latitude!, lng: userLocation.longitude!);
      _newActivity.location = LocationActivity(
          address: address,
          latitude: userLocation.latitude,
          longitude: userLocation.longitude);
      setState(() {
        _addressController.text = address;
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _urlFocusNode.dispose();
    _addressFocusNode.dispose();
    _urlController.dispose();
    _addressController.dispose();
  }

  Future<void> submitForm() async {
    try {
      CityProvider cityProvider = Provider.of<CityProvider>(
        context,
        listen: false,
      );
      _formKey.currentState!.save();
      setState(() => _isLoading = true);
      _nameInputAsync = await cityProvider.verifyIfActivityNameIsUnique(
        widget.cityName,
        _newActivity.name,
      );
      if (form.validate()) {
        await cityProvider.addActivityToCity(_newActivity);
        if (mounted) Navigator.pop(context);
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(15),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  autofocus: true,
                  decoration: const InputDecoration(labelText: 'Nom'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Remplissez le nom';
                    } else {
                      return _nameInputAsync;
                    }
                    return null;
                  },
                  onSaved: (value) => _newActivity.name = value!,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_priceFocusNode),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 30),
                TextFormField(
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  decoration: const InputDecoration(labelText: 'Prix'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Remplissez le Prix';
                    }
                    return null;
                  },
                  onSaved: (value) => _newActivity.price = double.parse(value!),
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_urlFocusNode),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 30),
                TextFormField(
                  focusNode: _addressFocusNode,
                  controller: _addressController,
                  decoration: const InputDecoration(hintText: 'adresse'),
                  onSaved: ((value) => _newActivity.location!.address = value!),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton.icon(
                    onPressed: _getCurrentLocation,
                    icon: const Icon(Icons.gps_fixed),
                    label: const Text('Utilisez ma position actuelle')),
                const SizedBox(height: 30),
                TextFormField(
                  keyboardType: TextInputType.url,
                  controller: _urlController,
                  focusNode: _urlFocusNode,
                  decoration: const InputDecoration(labelText: 'Url image'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Remplissez l\'url';
                    }
                    return null;
                  },
                  onSaved: (value) => _newActivity.image = value!,
                ),
                const SizedBox(height: 30),
                ActivityFormImagePicker(updateUrl: updateUrlField),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Annuler'),
                    ),
                    ElevatedButton(
                      onPressed: _isLoading ? null : submitForm,
                      child: const Text('Sauvegarder'),
                    )
                  ],
                )
              ],
            )));
  }
}
