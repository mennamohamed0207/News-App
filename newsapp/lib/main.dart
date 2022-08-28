import 'package:flutter/material.dart';
import 'package:newsapp/News/Sports.dart';
import 'package:url_launcher/url_launcher.dart';
import 'News/NewsResponse.dart';
import 'News/Newsapi.dart';
import 'News/Sports.dart';
import 'News/Busseins.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "News App",
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(' '),
            ),
            ListTile(
              leading: Icon(
                Icons.sports,
              ),
              title: const Text('Sports'),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SportsPage(),
                    ));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.money,
              ),
              title: const Text('Business'),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BusseinsPage(),
                    ));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.computer,
              ),
              title: const Text('Technology'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "News App",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(
                "Find intresting article and news",
                style: TextStyle(color: Color.fromARGB(255, 7, 39, 166)),
              ),
              SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<Article>?>(
                  future: NewsApiServices().fetchNewsArticle,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      List<Article>? newsArticle = snapshot.data;
                      return ListView.builder(
                        itemCount: newsArticle?.length,
                        itemBuilder: (context, index) {
                          return NewsTile(article: newsArticle![index]);
                        },
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),//safe area
    );
  }
}

class NewsTile extends StatelessWidget {
  final Article article;
  

  const NewsTile({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(7),
      child: ListTile(
        onTap: () async {
          await canLaunch(article.url)
              ? await launch(article.url)
              : throw 'Could not launch ${article.url}';
        },
        title: Text(
          article.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.blue),
        ),
        subtitle: Text(
          article.description,
          maxLines: 4,
        ),
        leading: article.urlToImage != null
            ? Container(
                width: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(article.urlToImage),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

