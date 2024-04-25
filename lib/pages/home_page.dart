import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_meal_app/components/area_item.dart';
import 'package:my_meal_app/components/meal_item.dart';
import 'package:my_meal_app/constants.dart';
import 'package:my_meal_app/hive/hive_app_helper.dart';
import 'package:my_meal_app/pages/detail_page.dart';
import 'package:my_meal_app/pages/welcome_page.dart';
import 'package:my_meal_app/providers/my_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _query = TextEditingController();
  String _queryChanged = "";
  int? _selectedAreaIndex = 0;

  @override
  void initState() {
    Provider.of<MyProvider>(context, listen: false).fetchAreas();
    Provider.of<MyProvider>(context, listen: false).fetchMeals("American");
    super.initState();
  }

  void signtOut() async{
    bool isLogout =  await  HiveAppHelper().logout();
    if (isLogout){
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const WelcomePage()),
            (Route<dynamic> route) => false,
      );
    } else {
      Fluttertoast.showToast(msg: signOutFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mealColor,
        title: const Text(
          home,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            color: Colors.white,
            iconColor: Colors.white,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: signupTitle,
              child: Text(signOut),
            ),
            ],
            onSelected: (String value) {
              signtOut();
            },
          )
        ],
      ),
      body: Consumer<MyProvider>(
        builder: (context, myProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  height: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextFormField(
                    controller: _query,
                    onChanged: (value){
                      setState(() {
                        _queryChanged = value;
                        if (value.isNotEmpty) {
                          _selectedAreaIndex = null;
                        }
                        myProvider.searchByName(value);
                      });
                    },
                    autocorrect: false,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      suffixIcon: _queryChanged.isNotEmpty ? IconButton(onPressed: (){
                        setState(() {
                          _queryChanged = "";
                          _query.clear();
                        });
                      }, icon: const Icon(Icons.close)) : null,
                      labelText: search,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
               SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: myProvider.areas.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: (){
                          setState(() {
                            _selectedAreaIndex = index;
                            myProvider.fetchMeals(myProvider.areas[index]);
                          });
                        },
                        child: AreaItem(areaName: myProvider.areas[index], isSelected: _selectedAreaIndex == index),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: myProvider.loading ? const Center(
                    child: CircularProgressIndicator(),
                  ) : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: myProvider.meals.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailPage(mealModel: myProvider.meals[index])));
                        },
                        child: MealItem(mealModel: myProvider.meals[index]),
                      );
                    },
                  )
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
