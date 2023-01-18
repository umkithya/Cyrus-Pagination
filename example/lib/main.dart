import 'package:cyrus_pagination/cyrus_pagination.dart';
import 'package:cyrus_pagination_example/model/passager_model.dart';
import 'package:dio_base_helper/dio_base_helper.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Cyrus Pagination'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var passagerList = <PassagerModel>[];
  var loading = false;
  var page = 1;
  var end = false;
  var isMoreData = false;

  Future<void> fetchApi() async {
    setState(() {
      if (page == 1) {
        passagerList.clear();
        isMoreData = false;
        loading = true;
      } else {
        isMoreData = true;
        loading = false;
      }
    });
    final dioBaseHelper = DioBaseHelper("https://api.instantwebtools.net/v1");
    await dioBaseHelper
        .onRequest(
            methode: METHODE.get, endPoint: "/passenger?page=$page&size=10")
        .then((response) => {
              debugPrint("Status code 200====${response['data']}"),
              for (var json in response['data'])
                {
                  passagerList.add(
                    PassagerModel.fromJson(json),
                  )
                },
              debugPrint('Length===${passagerList.length}'),
              setState(() => {
                    passagerList = passagerList,
                    if (page < response["totalPages"]) page++,
                    loading = false,
                    isMoreData = false,
                    end = page == response["totalPages"],
                  })
            })
        .onError(
          (ErrorModel error, stackTrace) => {
            debugPrint('Error: ${error.statusCode}'),
            setState(
              () => {loading = false},
            )
          },
        );
  }

  @override
  void initState() {
    fetchApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: CyrusPagination<PassagerModel>(
        // isGridView: true,
        // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //   crossAxisSpacing: 1,
        //   mainAxisSpacing: 10,
        //   crossAxisCount: 3,
        //   childAspectRatio: 3 / 4.5,
        // ),
        onRefresh: () async {
          setState(() {
            page = 1;
            end = false;
          });
          await fetchApi();
        },
        loading: loading,
        itemList: passagerList,
        page: page,
        end: end,
        fetchData: () => fetchApi(),
        widget: (data, index) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: CustomCard(
            description: data.name,
            title: "$index",
          ),
        ),
        hasMoreData: isMoreData,
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard({
    Key? key,
    this.description,
    this.title,
  }) : super(key: key);
  final String? title;
  final String? description;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        color: Colors.grey[300],
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Image.network(""),
            Text(
              title!,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              description!,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
