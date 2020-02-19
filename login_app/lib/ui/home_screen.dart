import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:login_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:login_app/constants.dart';
import 'package:login_app/models/subject_category.dart';
import 'package:login_app/models/subject_repository.dart';
import 'package:login_app/ui/custom_widgets/selection_card.dart';
import 'package:login_app/ui/mcq_screen.dart';
import 'package:login_app/ui/question_screen.dart';

class HomeScreen extends StatelessWidget {
  final String name;
  final SubjectRepository repository = SubjectRepository();

  HomeScreen({Key key, @required this.name}) : super (key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget> [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(
                LoggedOut(),
              );
            },
          ),
        ]
      ),

      body: SafeArea(
        child: ScrollConfiguration(
          behavior: ScrollBehavior(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(paddingL),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                
                MainMenuHeader(),
                
                FutureBuilder<List<Subjects>>(
                  future: repository.get(),
                  initialData: [],
                  builder: (
                    _,
                    AsyncSnapshot<List<Subjects>> snapshot,
                  ) {
                    if (snapshot.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          for (var category in snapshot.data)
                            Container(
                              margin: const EdgeInsets.only(top: marginL),
                              child: MainMenuCard(
                                subject: category,
                              ),
                            )
                        ],
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: lightBackgroundColor,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.black.withOpacity(0.65),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
    
      )
    );
  }
}


class ListItem extends StatelessWidget {
  const ListItem({
    Key key,
    this.title,
    this.color,
  }) : super(key: key);

  final String title; 
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      margin: EdgeInsets.symmetric(vertical: 5.0),
      child: Text(
        this.title,
        textAlign: TextAlign.start,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 32.0,
          fontWeight: FontWeight.w400,
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.0),
        color: this.color,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 5.0),
            color: Colors.black26,
            blurRadius: 6.0,
          )
        ],
      ),
    );
  }
}

class MainMenuCard extends StatefulWidget {
  final Subjects subject;

  const MainMenuCard({
    @required this.subject,
  }) : assert(subject != null);

  @override
  _MainMenuCardState createState() => _MainMenuCardState();
}

class _MainMenuCardState extends State<MainMenuCard> {
  var postion = 112.0;
  @override
  Widget build(BuildContext context) {
    

    var contentHeader = Text(
      widget.subject.title,
      style: Theme.of(context).textTheme.title.copyWith(
            fontSize: 26.0,
            color: Color(0xFF068DCE),
          ),
      overflow: TextOverflow.ellipsis,
    );
    var contentText = Text(
      '100 MCQs, 50 SHORT, 20 LONG',
      style: Theme.of(context).textTheme.subhead.copyWith(
        color: Color(0xFF004A87),
        fontSize: 14.0,
      ),
    );
    var onSelectionCardTap = () {
      setState(() {
        if (postion == 112){
          postion = 180; 
        } else {
          postion = 112;
        }
      });
    }; 

    return Stack(
      children: <Widget>[

        AnimatedContainer(
          duration: Duration(milliseconds: 250),
          width: MediaQuery.of(context).size.width,
          height: postion,
          decoration: BoxDecoration(
            color: lightestBlueColor,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(right: paddingL, left: paddingL, top: paddingL, bottom: paddingM),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  
                  SubCategoryButton(
                    navigateTo: McqsScreen(subject: widget.subject), 
                    text: "MCQs",
                  ),
                  
                  SubCategoryButton(
                    navigateTo: QuestionsScreen(subject: widget.subject, isLong: false), 
                    text: "SHORT",
                  ),
                  
                  SubCategoryButton(
                    navigateTo: QuestionsScreen(subject: widget.subject, isLong: true), 
                    text: "LONG",
                  ),

                ],
              ),
            ),
          ),
        ),
      

        SelectionCard(
          backgroundColor: Colors.white,
          backgroundHeroTag: "${widget.subject.id}_background",
          contentHeader: contentHeader,
          contentText: contentText,
          onTap: onSelectionCardTap,
          image: widget.subject.image,
        ),

      ],
    );
  }
}

class SubCategoryButton extends StatelessWidget {
  const SubCategoryButton({
    Key key,
    this.text,
    @required this.navigateTo,
  }) : super(key: key);

  final Widget navigateTo;
  final String text;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: darkBlueColor,
      onPressed: () {
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => navigateTo)
        );
      },
      child: Text(
        text,
        style: Theme.of(context).textTheme.title.copyWith(
          fontSize: 16.0,
          color: Colors.white,
        ),
      ),
    );
  }
}

class MainMenuHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: paddingL),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Text(
          'Choose a Subject',
          style: Theme.of(context).textTheme.display1,
        ),
      )
    );
  }
}
