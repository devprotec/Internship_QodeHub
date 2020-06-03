/*
Author: David Brewu
Date: 3rd June, 2020

This project satisfies all the requirments as specified in the mobile development challenge 
*/ 




// these libraries are necessary for the code to compile 
import 'package:flutter/material.dart';                             // for building the interface of the app
import 'dart:convert';                                              // for convertion between files        
import 'package:url_launcher/url_launcher.dart';                    // for launching a web browser in the app
import 'package:http/http.dart' as http;                            // for making http request




// this class maps the backend data saved as a json file to a string
class News {
// each news will have the following characteristics
  String id;
  String url;
  String title;
  String text;
  String publisher;
  String author;
  String image;
  String date;
  

  News(this.id, this.url,this.title,this.text,this.publisher,this.author,this.image,this.date);

  News.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    title = json['title'];
    text = json['text'];
    publisher = json['publisher'];
    author = json['author'];
    image = json['image'];
    date = json['date'];

  }
}



// main method which runs the app
void main() => runApp(NewsApp());



// this class returns a material app with a white background
class NewsApp extends StatelessWidget{
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: HomePage(),                                // class HomePage() builds the main homepage for the material app
    );
  }
}


// the HomePage class which implements the interface of the app
class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => _HomePageState();      // a state of the homepage class which is extended by another class
                                                         // to complete the application interface
}


class _HomePageState extends State<HomePage>{

  static List<News> _news = List<News>();                // stores a list of news
  static List<News> _newsInApp = List<News>();
  

// fetches and return the backend data from the web
  Future<List<News>> comingNews() async {
    var url = 'http://www.mocky.io/v2/5ecfddf13200006600e3d6d0';        // fetches the backend data from the specified url
    
    var response = await http.get(url);                                
    
    var news = List<News>();                                           // stores a list of news
    
    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);                     // decodes the http response to a json file
      for (var noteJson in notesJson) {
        news.add(News.fromJson(noteJson));                           // the decoded response is added to a list of news
      }
    }
      return news;
  }



 // initiates and sets the state of incomingNews to the necessary variables
  @override
  void initState() {
    comingNews().then((value) {
      setState(() {
        _news.addAll(value);                               // the data returned by class incomingNews is added to list of news
        _newsInApp = _news;                                // and assigned to _newsInApp which will be displayed in the app
      });
    });
    super.initState();
  } 



  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
// sets the title, height, color and borders of the appbar(the portion of the app which displays the title 'News')
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(97.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color:Colors.white,
                border:Border(
                  bottom: BorderSide(
                    width:0.5, 
                    color:Colors.white
                  )
                )
              ),
                
              margin: EdgeInsets.only( top: 32,),
              
              child: AppBar(
                title: Text('News', 
                  style: TextStyle(
                    fontSize:30, 
                    fontWeight:FontWeight.bold, 
                    color: Colors.black
                  ),
                ),
              ),  
            ),

// leaves a small space between the app bar and the first column of news
            Padding(
              padding: const EdgeInsets.only(left:15.0),
              child: Divider(color: Colors.black12,height: 1.0,),
            )
          ]
        )
      ),



// the code below calls a method which returns a container that displays a colume of news
// it calls the method according to the number of news in the news list.
      body: ListView.builder(
        itemBuilder: (context, index) { 
         return  _listItem(index);
        },
        itemCount: _newsInApp.length,
        )
    );
  }




// a call to this method returns a column of news
  _listItem(index) {
    return Container(
// leaves a small space at the left side of the screen
      child: Padding(
        padding: const EdgeInsets.only(top: 1.0, bottom: 1.0, left: 15.0, right: 1.0),

        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

// places the title and the forward arrow in a row on the first page
            Row(
              mainAxisAlignment:MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top:0, bottom: 5),
                    child: Text(
                      _newsInApp[index].title,                            // displays the title of news on the first page of the app 
                      style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold,        // sets color, fontsize and fontweight of the title
                        color: Colors.black
                      ),
                    ),
                  ),
                ),
              

                Container(
                  height: 50,
                  child: Align(
                  alignment: Alignment.bottomCenter,
                    child: IconButton(                         
                      iconSize: 16,
                      color: Colors.black26,
                      alignment: Alignment.bottomCenter,
                      icon: Icon(Icons.arrow_forward_ios),            // a forward icon to be displayed on the left side of the title

// the following specifies what happens when the icon is pressed                      
                      onPressed: ()=> Navigator.push(
                        context, MaterialPageRoute(
                          builder: (context) {

                          String writer = _newsInApp[index].author;
                          String dat = _newsInApp[index].date;

                          return new MaterialApp(                        // a new material app is returned when the icon is pressed
                            debugShowCheckedModeBanner: false,  
                            home:  Scaffold(
                              appBar: AppBar(                           // sets the title, color, size, and backward icon of the appbar
                                centerTitle: true,
                                backgroundColor: Colors.white,

                                leading: IconButton(
                                  iconSize: 20,
                                  color: Colors.blue,
                                  icon:Icon(Icons.arrow_back_ios),           // the backward icon of the appbar on the second page of the app.
                                    onPressed: ()=> Navigator.pop(context),
                                ),
                                
                                title: Text(
                                  _newsInApp[index].title,                   // displays the title on the appbar
                                  style: TextStyle(color: Colors.black,      // sets the color, fontsize and fontweight of the title
                                    fontSize: 15, 
                                    fontWeight: FontWeight.bold          
                                  ),
                                ),
                              ),

                              body: SingleChildScrollView(              // places the image and the rest of the text in a scrollable manner
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        height: 220,
                                        width: 400,
                                        margin: EdgeInsets.only( bottom: 10,),
                                        child: Image.network(                   // displays the image below the appbar
                                            _newsInApp[index].image, 
                                            fit: BoxFit.cover 
                                        )
                                      ),
                                                      
                                      ListTile(
                                        title: Container(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[ 
                                              Text(_newsInApp[index].title,                   // displays title below the image
                                                style: TextStyle(color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15
                                                ), 
                                                textAlign: TextAlign.left,
                                              ),

                                              SizedBox(height:8),                     // leaves a white space between the title and the publisher
                                
                                              Text(_newsInApp[index].publisher,               // displays the publisher below the title
                                                style: TextStyle(
                                                  color:Colors.black26
                                                ),
                                              ),

                                              SizedBox(height:12),                    // leaves a white space between the publisher and the text

                                              Text(_newsInApp[index].text,                   // displays the text below the publisher
                                                textAlign: TextAlign.justify, 
                                                style:TextStyle(wordSpacing:2)
                                              ),

                                              SizedBox(height:12),
                                              
                                              Text('Author: $writer'),                       // displays the author below the text

                                              SizedBox(height:12),

                                              Text('Date: $dat'),                            // displays the date below the author 

                                              SizedBox(height:12),

                                              Text('Full story at:'),                        

                                              SizedBox(height:5),

                                              InkWell(
                                                child: Text(_newsInApp[index].url,             // displays the url below the date
                                                  style: TextStyle(color: Colors.blue)
                                                ),
                                                onTap: () async {
                                                  if (await canLaunch(_newsInApp[index].url)) {    
                                                    await launch(_newsInApp[index].url);          // launches the browser when the url is clicked
                                                  }
                                                }
                                              )
                                            ]
                                          )
                                        ) 
                                      ) 
                                    ]
                                  )
                                ) 
                              )
                            )
                          );
                        })),
                      ),
                    ),
                  ),
                ]
              ),

              SizedBox(height: 5,),

              Text(
                _newsInApp[index].publisher,                            // displays the publisher below the title on the first page
                style: TextStyle(
                  color: Colors.grey.shade600, fontSize: 17,           
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top:6.0, bottom: 0),
                child: Divider(color: Colors.black12,),                  // places a divider below each column of news on the first page
              )
            ],
          ),
      )
    );
  }  
}


 



