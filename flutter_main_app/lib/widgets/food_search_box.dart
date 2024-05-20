import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../blocs/blocs.dart';
import '../../widgets/widgets.dart';
import '../screens/location/location_screen.dart';

class FoodSearchBox extends StatelessWidget {
  const FoodSearchBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, LocationScreen.routeName);
              },
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter Your Location',
                    suffixIcon:
                    Icon(Icons.search, color: Theme.of(context).primaryColor),
                    contentPadding:
                    const EdgeInsets.only(left: 20.0, bottom: 5.0, top: 12.5),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {},
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Container(
            margin: const EdgeInsets.only(right: 5.0),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.white,
            ),
            child: IconButton(
              icon: Icon(Icons.menu, color: Theme.of(context).primaryColor),
              onPressed: () {
                Navigator.pushNamed(context, '/filters');
              },
            ),
          ),
        ],
      ),
    );
  }
}
