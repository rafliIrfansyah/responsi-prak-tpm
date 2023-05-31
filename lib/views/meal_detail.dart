import 'package:flutter/material.dart';
import 'package:responsi_tpm/api/api_service.dart';
import 'package:responsi_tpm/fetch_state.dart';
import 'package:responsi_tpm/models/meal_detail_model.dart';
import 'package:url_launcher/url_launcher.dart';

class MealDetail extends StatefulWidget {
  final String id;

  const MealDetail({super.key, required this.id});
  static const routeName = '/meal_detail';

  @override
  MealDetailState createState() => MealDetailState();
}

class MealDetailState extends State<MealDetail> {
  late FetchState _state;
  late Meals _meals;

  final apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _state = FetchState.pending;
    _fetchMealDetails();
  }

  void _fetchMealDetails() async {
    try {
      final result = await apiService.getMealDetails(widget.id);
      if (!mounted) return;
      setState(() {
        _state = FetchState.success;
        _meals = Meals.fromJson(result[0]);
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
      title: const Text(
        'Meal Detail',
      ),
    );
  }

  Widget _buildBody() {
    switch (_state) {
      case FetchState.success:
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(_meals.strMeal!,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                const SizedBox(height: 16.0),
                Center(
                  child: Image.network(
                    _meals.strMealThumb!,
                    width: 200,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Category : ${_meals.strCategory}',
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Area : ${_meals.strArea}',
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 16.0),
                Text(
                  _meals.strInstructions!,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          launchURL(_meals.strYoutube!);
                        },
                        child: const Text('Lihat Youtube'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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

Future<void> launchURL(String url) async {
  // ignore: no_leading_underscores_for_local_identifiers
  final Uri _url = Uri.parse(url);
  if (!await launchUrl(_url)) {
    throw 'Could not launch $_url';
  }
}
