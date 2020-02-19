import 'package:flutter/material.dart';
import 'package:login_app/constants.dart';
import 'package:login_app/models/question_model.dart';
import 'package:login_app/models/question_repository.dart';
import 'package:login_app/models/subject_category.dart';

class JsonRequest {
  final List<String> years;
  final List<String> type;
  final List<int>    chapters;

  JsonRequest(this.years, this.type, this.chapters);
}

class QuestionsScreen extends StatefulWidget {
  
  final Subjects subject;
  final bool isLong;
  QuestionsScreen({Key key, this.subject, this.isLong}) : super(key: key);

  @override
  _QuestionsScreenState createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  
  JsonRequest request;
  List<bool> typeOptions;

  @override
  void initState() {
    super.initState();
    request = JsonRequest([], [], []);
    typeOptions = [true, true, true];
  }

  void getList(List list){
    print(list);
    
  }
  
  void getType(List<String> type){
    request = JsonRequest([], type, []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackgroundColor,
      appBar:  AppBar(
        elevation: 1,
        centerTitle: true,
        backgroundColor: darkestBlueColor,
        title: Text(
          widget.subject.title,
          style: Theme.of(context).textTheme.title.copyWith(color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(paddingM),
        child: FloatingActionButton(
          onPressed: (){
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context){
                  return Container(
                    child: new ListView(
                      children: <Widget>[
                        BottomSheetCard(
                          title: "CHAPTERS",
                          checkTitles: ["Chap: 1", "Chap: 2", "Chap: 3", "Chap: 4", "Chap: 5", "Chap: 6", "Chap: 7", "Chap: 8"],
                          options: [],
                          activeColor: Colors.green,
                          backgroudColor: Colors.greenAccent,
                          sendList: (list){
                            getList(list);
                          },  
                        ),
                        
                        BottomSheetCard(
                          title: "TYPES",
                          checkTitles: ["Descriptive", "Derivation", "Numerical"],
                          options: typeOptions,
                          activeColor: Colors.orange,
                          backgroudColor: Colors.orange[300],
                          sendList: (list){
                            setState(() {
                              getType(list);
                              print("chay wala: $list");
                            });
                          },
                        ),
                        
                        BottomSheetCard(
                          title: "YEARS",
                          checkTitles: ["2017", "2016", "2015", "2014"],
                          options: [],
                          activeColor: Colors.blue,
                          backgroudColor: Colors.blue[300],
                        ),

                        Padding(
                          padding: const EdgeInsets.all(paddingL),
                          child: RaisedButton(
                            color: darkBlueColor,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "APPLY",
                              style: Theme.of(context).textTheme.title.copyWith(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        
                      ],
                    ),
                  );
              }
            );
          },
          isExtended: true,
          backgroundColor: darkBlueColor,
          splashColor: darkestBlueColor,
          child: Icon(Icons.filter_list),
        ),
      ),
      body: QuestionList(subject: widget.subject, isLong: widget.isLong, json: request),
    );
  }
}


class QuestionList extends StatefulWidget {

  final Subjects subject;
  final bool isLong;
  final JsonRequest json;
  
  QuestionList({Key key, this.subject, this.isLong, this.json}) : super(key: key);

  @override
  _QuestionListState createState() => _QuestionListState();

  
}

class _QuestionListState extends State<QuestionList> {
 

  QuestionRepository repository = QuestionRepository();
    Future<List<Question>> questions;
    bool error = false;

  @override
  void initState() {
    super.initState();
    questions = repository.get(widget.subject.id, widget.json, widget.isLong);
    
    questions.catchError((onError){
      print(onError);
      setState(() {
        error = true;
      });
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return error? Center(
       child: Padding(
         padding: const EdgeInsets.all(paddingXL),
         child: Image.asset(
           'assets/images/page_not_available.png'
         ),
       ), 
      ):FutureBuilder<List<Question>>(
          future: repository.get(widget.subject.id, widget.json, widget.isLong),
          builder: (context, AsyncSnapshot<List<Question>> snapshot) {
            
            if (snapshot.hasData){
              return ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      for (Question question in snapshot.data)               
                        QuestionItem(
                          question: question.question,
                          tags: <QuestionTag>[
                            QuestionTag(
                              label: "Chap: " + question.chapter,
                              color: Colors.green,
                            ),
                            
                            for (var type in question.type)
                              QuestionTag(
                                label: type,
                                color: Colors.orange,
                              ),

                            for (var tag in question.years)
                              QuestionTag(
                                label: tag,
                                color: Colors.blue,
                              )
                          ],
                        )
                    ],
                  ),
                ],
              );

            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: lightBackgroundColor,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.black.withOpacity(0.65),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          }
        );
      
  }
}

class QuestionItem extends StatelessWidget {

  final String question;
  final List<QuestionTag> tags;

  const QuestionItem({
    Key key,
    this.question,
    this.tags,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: paddingM, left: paddingL, right: paddingL, bottom: paddingM),
      child: Container(
        padding: EdgeInsets.only(top: paddingL, left: paddingL, right: paddingL, bottom: paddingS),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              offset: Offset(0.0, 3.0),
              blurRadius: 10.0,
            )
          ]
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                question,
                style: Theme.of(context).textTheme.display3,
              ),
            ),

            SizedBox(height: paddingM),

            Wrap(
              spacing: spaceS,
              crossAxisAlignment: WrapCrossAlignment.start,
              runAlignment: WrapAlignment.start,
              runSpacing: 0.0,
              children: tags,
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionTag extends StatelessWidget {

  final String label;
  final Color color;

  const QuestionTag({
    Key key,
    this.label,
    this.color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: color,
      label: Text(
        label,
        style: Theme.of(context).textTheme.subtitle.copyWith(
          fontFamily: 'Roboto Medium',
          color: yellowWhiteColor,
          fontSize: 12.0,
        ),
      ),
    );
  }
}


class BottomSheetCard extends StatefulWidget {

  final String title;
  final List<String> checkTitles;
  final List options;
  final Color backgroudColor;
  final Color activeColor;
  final Function sendList;

  const BottomSheetCard({Key key, this.title, this.checkTitles, this.options, this.backgroudColor, this.activeColor, this.sendList}) : super(key: key);

  @override
  _BottomSheetCardState createState() => _BottomSheetCardState();
}

class _BottomSheetCardState extends State<BottomSheetCard> {

  final List<bool> selected = [];

  @override
  void initState() {
    super.initState();
    
    for (var i = 0; i < widget.checkTitles.length; i++){
      selected.add(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(paddingL),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: widget.backgroudColor,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: widget.activeColor,
              offset: Offset(0.0, 3.0),
              blurRadius: 5.0,
            )
          ]
        ),
        child: Padding(
          padding: const EdgeInsets.all(paddingM),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.title,
                style: Theme.of(context).textTheme.title.copyWith(
                  color: yellowWhiteColor,
                ),
              ),

              Wrap(
                children: <Widget>[
                  for(var i = 0; i < widget.checkTitles.length; i++)
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Checkbox(
                            activeColor: widget.activeColor,
                            value: selected[i],
                            onChanged: (value){
                              setState(() {
                                selected[i] = value;

                                print ("${selected.length} and ${widget.checkTitles.length}");
                                
                                List<String> answers = [];

                                for (var item = 0; item < selected.length; item++){
                                  if (selected[item])
                                    answers.add(widget.checkTitles[item]); 
                                }


                                widget.sendList(answers);
                              });
                            },
                          ),
                          Text(
                            widget.checkTitles[i],
                            style: TextStyle(
                              fontFamily: "Roboto Medium",
                              fontSize: 14.0,
                            ),
                          )
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}