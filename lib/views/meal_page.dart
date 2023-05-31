import 'package:flutter/material.dart';
import 'package:responsi_tpm/api/api_service.dart';
import 'package:responsi_tpm/fetch_state.dart';
import 'package:responsi_tpm/models/meal_model.dart';
import 'package:responsi_tpm/views/meal_detail.dart';

class MealPage extends StatefulWidget {
  final String category;

  const MealPage({super.key, required this.category});
  static const routeName = '/meal_page';

  @override
  MealPageState createState() => MealPageState();
}

class MealPageState extends State<MealPage> {
  late FetchState _state;
  late List<Meals> _meals;

  final apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _state = FetchState.pending;
    _meals = [];
    _fetchAllMeals();
  }

  void _fetchAllMeals() async {
    try {
      final result = await apiService.getMealsByCategory(widget.category);
      if (!mounted) return;
      setState(() {
        _state = FetchState.success;
        _meals = result.map((e) => Meals.fromJson(e)).toList();
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _state = FetchState.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_state == FetchState.pending || _state == FetchState.error) {
      return Scaffold(
        appBar: _buildAppBar(context),
        body: _buildBody(),
      );
    }
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        '${widget.category} Meal',
      ),
    );
  }

  Widget _buildBody() {
    switch (_state) {
      case FetchState.success:
        return ListView.builder(
          itemCount: _meals.length,
          itemBuilder: (_, index) {
            Meals meals = _meals[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MealDetail(id: meals.idMeal!)));
              },
              child: Card(
                color: Colors.white,
                child: SizedBox(
                  height: 100.0,
                  child: Center(
                    child: ListTile(
                      leading: Image.network(meals.strMealThumb!,),
                      title: Text(
                        meals.strMeal!,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      case FetchState.pending:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case FetchState.error:
        return const Center(
          child: CircularProgressIndicator(),
        );
      default:
        return const SizedBox();
    }
  }
}
