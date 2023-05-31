import 'package:flutter/material.dart';
import 'package:responsi_tpm/api/api_service.dart';
import 'package:responsi_tpm/fetch_state.dart';
import 'package:responsi_tpm/models/category_model.dart';
import 'package:responsi_tpm/views/meal_page.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);
  static const routeName = '/category_page';

  @override
  CategoryPageState createState() => CategoryPageState();
}

class CategoryPageState extends State<CategoryPage> {
  late FetchState _state;
  late List<Categories> _categories;

  final apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _state = FetchState.pending;
    _categories = [];
    _fetchAllCategories();
  }

  void _fetchAllCategories() async {
    try {
      final result = await apiService.getCategories();
      if (!mounted) return;
      setState(() {
        _state = FetchState.success;
        _categories = result.map((e) => Categories.fromJson(e)).toList();
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
        'Meal Category',
      ),
    );
  }

  Widget _buildBody() {
    switch (_state) {
      case FetchState.success:
        return ListView.builder(
          itemCount: _categories.length,
          itemBuilder: (_, index) {
            Categories categories = _categories[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MealPage(category: categories.strCategory!)));
              },
              child: Card(
                color: Colors.white,
                margin: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 100.0,
                  child: Center(
                    child: ListTile(
                      leading: Image.network(categories.strCategoryThumb!),
                      title: Text(
                        categories.strCategory!,
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
