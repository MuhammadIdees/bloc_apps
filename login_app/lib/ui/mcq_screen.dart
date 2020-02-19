import 'package:flutter/material.dart';
import 'package:login_app/constants.dart';
import 'package:login_app/models/mcqs_question.dart';
import 'package:login_app/models/mcqs_repository.dart';
import 'package:login_app/models/subject_category.dart';
import 'package:login_app/ui/custom_widgets/custum_dialog.dart';

const SCALE_FRACTION = 0.9;
const FULL_SCALE = 1.0;
const PAGER_HEIGHT = 200.0;

class McqsScreen extends StatefulWidget {
  final Subjects subject;

  const McqsScreen({this.subject, Key key}) : super(key: key);

  @override
  _McqsScreenState createState() => _McqsScreenState();
}

class _McqsScreenState extends State<McqsScreen> {
  double viewPortFraction = 0.9;
  List<int> radioValue = [];
  List<int> answer = [];
  bool done = false;
  bool showAnswers = false;

  PageController pageController;
  McqRepository repository = McqRepository();
  int currentPage = 0;
  double page = 0.0;
  int datalength = 0;

  bool error = false;

  Future<List<MultipleChoiceQuestion>> mcqs;

  @override
  void initState() {
    pageController = PageController(
        initialPage: currentPage, viewportFraction: viewPortFraction);
    super.initState();

    mcqs = repository.get(widget.subject.title);
    
    mcqs.catchError((onError){
      setState(() {
        error = true;
      });
    });

    mcqs.then((value){
      datalength = value.length;
      for (var mcq in value) {
        radioValue.add(-1);
        answer.add(mcq.answer);
      }
    });
  }
  
  void showCustomDialog(int correct, int total){
    _dismissDialog() {
      Navigator.pop(context);
    }
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog(
      title: "QUIZ RESULT",
      description: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Text("Correct:", textAlign: TextAlign.left),
                ),
              ),
              Expanded(
                child: Container(
                  child: Text("$correct", textAlign: TextAlign.right),
                ),
              ),
            ],
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Text("Out Of:", textAlign: TextAlign.left),
                ),
              ),
              Expanded(
                child: Container(
                  child: Text("$total", textAlign: TextAlign.right),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            setState(() {
              showAnswers = true;
            });
            _dismissDialog();
          },
          child: Text(
            'ANSWERS',
            style: Theme.of(context).textTheme.body2.copyWith(
              color: lightBlueColor,
            ),
          )),
        FlatButton(
          onPressed: () {
            _dismissDialog();
          },
          child: Text(
            'CLOSE',
            style: Theme.of(context).textTheme.body2.copyWith(
              color: lightBlueColor,
            ),
          )),
        ]),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: error? lightBlueColor : lightBackgroundColor,
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        backgroundColor: darkestBlueColor,
        title: Text(
          widget.subject.title,
          style: Theme.of(context).textTheme.title.copyWith(color: Colors.white),
        ),
      ),
      
      floatingActionButton: error? null : FloatingActionButton(
        isExtended: true,
        onPressed: () {
          if (showAnswers) {
            setState(() {
              showAnswers = false;
            });
          } else {
            int correct = 0;
            int i = 0;
            for (var ans in answer) {
              if (ans == radioValue[i]) {
                correct++;
              }
              i++;
            }
            showCustomDialog(correct, datalength);
          }
        },
        elevation: 4.0,
        backgroundColor: darkBlueColor,
        splashColor: darkestBlueColor,
        tooltip: "Result",
        child: showAnswers? 
        Icon(Icons.close): 
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.receipt),
            Text(
              "Result",
              style: Theme.of(context).textTheme.subtitle.copyWith(
                color: yellowWhiteColor,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      
      bottomNavigationBar: error? null: BottomNavigationBar(
        unselectedFontSize: 0.0,
        selectedFontSize: 0.0,
        type: BottomNavigationBarType.fixed,
        elevation: 0.0,
        backgroundColor: lightBackgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.arrow_back,
              color: darkBlueColor,
            ),
            title: Text(""),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.arrow_forward,
              color: darkBlueColor,
            ),
            title: Text(""),
          ),
        ],
        onTap: (index) {
          setState(() {
            if (index == 0) {
              pageController.previousPage(
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            } else {
              pageController.nextPage(
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            }
          });
        },
      ),
      
      body: error? Center(
       child: Padding(
         padding: const EdgeInsets.all(paddingXL),
         child: Image.asset(
           'assets/images/page_not_available.png'
         ),
       ), 
      ): FutureBuilder<List<MultipleChoiceQuestion>>(
          future: mcqs,
          builder:  (context, snapshot) {
            
            if (snapshot.hasData) {

              return Padding(
                padding: const EdgeInsets.only(top: paddingM),
                child: ListView(
                  children: <Widget>[
                    Container(
                      height: PAGER_HEIGHT,
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification notification) {
                          if (notification is ScrollUpdateNotification) {
                            setState(() {
                              page = pageController.page;
                            });
                          }
                        },
                        child: PageView.builder(
                          onPageChanged: (pos) {
                            setState(() {
                              currentPage = pos;
                            });
                          },
                          physics: BouncingScrollPhysics(),
                          controller: pageController,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            MultipleChoiceQuestion mcq = snapshot.data[index];

                            final scale = (FULL_SCALE - 0.1) + viewPortFraction;

                            return questionCard(scale, mcq.question,
                                "${index + 1} / ${snapshot.data.length}", (index == currentPage));
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(paddingXL),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              color: showAnswers &&
                                      (snapshot.data[currentPage].answer == 1)
                                  ? Colors.greenAccent
                                  : Colors.transparent,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Radio(
                                  value: 1,
                                  groupValue: radioValue[currentPage],
                                  activeColor: darkestBlueColor,
                                  onChanged: (index) {
                                    setState(() {
                                      radioValue[currentPage] = index;
                                    });
                                  },
                                ),
                                Flexible(
                                  child: Text(
                                    snapshot.data[currentPage].option1,
                                    style: Theme.of(context).textTheme.display2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              color: showAnswers &&
                                      (snapshot.data[currentPage].answer == 2)
                                  ? Colors.greenAccent
                                  : Colors.transparent,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Radio(
                                  value: 2,
                                  groupValue: radioValue[currentPage],
                                  activeColor: darkestBlueColor,
                                  onChanged: (index) {
                                    setState(() {
                                      radioValue[currentPage] = index;
                                    });
                                  },
                                ),
                                Flexible(
                                  child: Text(
                                    snapshot.data[currentPage].option2,
                                    style: Theme.of(context).textTheme.display2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              color: showAnswers &&
                                      (snapshot.data[currentPage].answer == 3)
                                  ? Colors.greenAccent
                                  : Colors.transparent,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Radio(
                                  value: 3,
                                  groupValue: radioValue[currentPage],
                                  activeColor: darkestBlueColor,
                                  onChanged: (index) {
                                    setState(() {
                                      radioValue[currentPage] = index;
                                    });
                                  },
                                ),
                                Flexible(
                                  child: Text(
                                    snapshot.data[currentPage].option3,
                                    style: Theme.of(context).textTheme.display2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              color: showAnswers &&
                                      (snapshot.data[currentPage].answer == 4)
                                  ? Colors.greenAccent
                                  : Colors.transparent,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Radio(
                                  value: 4,
                                  groupValue: radioValue[currentPage],
                                  activeColor: darkestBlueColor,
                                  onChanged: (index) {
                                    setState(() {
                                      radioValue[currentPage] = index;
                                    });
                                  },
                                ),
                                Flexible(
                                  child: Text(
                                    snapshot.data[currentPage].option4,
                                    style: Theme.of(context).textTheme.display2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: lightBackgroundColor,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.black.withOpacity(0.65),
                  ),
                ),
              );
          }),
    );
  }

  Widget questionCard(double scale, String question, String numbering, bool isElevated) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.only(bottom: marginM),
        height: PAGER_HEIGHT * scale + 50,
        width: PAGER_HEIGHT * scale + 50,
        child: Card(
          elevation: isElevated? 5 : 0,
          clipBehavior: Clip.antiAlias,
          color: lightBlueColor,
          child: Padding(
            padding: const EdgeInsets.all(paddingL),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Center(
                      child: Text(
                        question,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.title.copyWith(
                              color: Colors.white,
                              fontFamily: "Math Bold",
                              fontSize: 18.0,
                            ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: paddingM),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      numbering,
                      style: Theme.of(context).textTheme.subtitle.copyWith(
                            color: yellowWhiteColor,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
