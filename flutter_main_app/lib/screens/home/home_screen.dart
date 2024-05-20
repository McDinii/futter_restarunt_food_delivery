import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_food_delivery_app/blocs/location/location_bloc.dart';
import 'package:flutter_food_delivery_app/screens/location/location_screen.dart';
import '../../models/models.dart';
import '../../models/promo_model.dart';
import '../../widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../blocs/restaurants/restaurants_bloc.dart';
import '../auth/auth.dart';
import '../auth/register_screen.dart';
import '../auth/signIn_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/';
  final AuthService _authService = AuthService();

  void _showAuthDialog(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Пользователь вошел в систему
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Profile',style: Theme.of(context).textTheme.headline3!),
          content: Text(user.email ?? 'No email',style: Theme.of(context).textTheme.headline5! ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _authService.signOut();
              },
              child: Text('Log out',style: Theme.of(context).textTheme.headline5!),
            ),
          ],
        ),
      );
    } else {
      // Пользователь не вошел
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Login',
              style: Theme.of(context).textTheme.headline5!),
          content: Text('Choose Action',
            style: Theme.of(context)
            .textTheme
            .headline3!.copyWith(color: Color(0xFFFE3C5B))),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                );
              },
              child: Text('Sing In',
                  style: Theme.of(context).textTheme.headline4!),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text('Register',
                  style: Theme.of(context).textTheme.headline4!
              ),
            ),
          ],
        ),
      );
    }
  }
  static Route route() {
    return MaterialPageRoute(
      builder: (_) => HomeScreen(),
      settings: RouteSettings(name: routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(onPressedUserIcon: () => _showAuthDialog(context)),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 100.0,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: Category.categories.length,
                  itemBuilder: (context, index) {
                    return CategoryBox(category: Category.categories[index]);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 125.0,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: Promo.promos.length,
                  itemBuilder: (context, index) {
                    return PromoBox(promo: Promo.promos[index]);
                  },
                ),
              ),
            ),
            FoodSearchBox(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Top Rated',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
            ),
            BlocBuilder<RestaurantsBloc, RestaurantsState>(
              builder: (context, state) {
                if (state is RestaurantsLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is RestaurantsLoaded) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.restaurants.length,
                      itemBuilder: (context, index) {
                        return RestaurantCard(
                          restaurant: state.restaurants[index],
                        );
                      },
                    ),
                  );
                } else {
                  return Text('Something went wrong');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    required this.onPressedUserIcon,
  }) : super(key: key);
  final VoidCallback onPressedUserIcon;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.person, color: Colors.white),
        onPressed: onPressedUserIcon,
      ),
      centerTitle: false,
      title: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          if (state is LocationLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is LocationLoaded) {
            return InkWell(
              onTap: () {
                Navigator.pushNamed(context, LocationScreen.routeName);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CURRENT LOCATION',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.white),
                  ),
                  Text(
                    state.place.name,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.white),
                  ),
                ],
              ),
            );
          } else {
            return Text('Something went wrong.');
          }
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56);
}
