import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:prueba_gbp/src/model/user_model.dart';


class ActivityPage extends StatefulWidget {

  final UserModel user;

  const ActivityPage({@required this.user});

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {

  TextEditingController _editingController = new TextEditingController();

  Box activityBox;
  bool empty = true;
  // bool cargado = false;

  @override
  void initState() {
    super.initState();
    activityBox = Hive.box('activity_box');
  }

  void _addActivity() async{
    var now = DateTime.now();
    var activityData = {
      "id_user" : this.widget.user.nodeId,
      "text_activity" : _editingController.text,
      "date" : now,
      "realized" : false
    };
    await activityBox.add(activityData);
    Navigator.pop(context);
    _editingController.text = "";
  }

  void _updateActivity(int index, dynamic item) async{
    var activityData = {
      "id_user" : item['id_user'],
      "text_activity" : item['text_activity'],
      "date" : item['date'],
      "realized" : true
    };
    await activityBox.putAt(index, activityData);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Actividades de usuario'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _userInformation(),
              _headerBox('Pendientes', Color(0xfff9a927), Colors.brown),
              SizedBox(height: 10,),
              Container(width: double.infinity, child: _listActivitiesPending(false)),
              _headerBox('Realizadas', Color(0xfface285), Colors.brown[400]),
              SizedBox(height: 10,),
              Container(width: double.infinity, child: _listActivitiesPending(true)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _editingController.text = "";
          _myDialog(context);
        },
        child: Icon(Icons.add, size: 30,),
      ),
    );
  }

  Widget _listActivitiesPending(bool type){
    return ValueListenableBuilder(
      valueListenable: activityBox.listenable(), 
      builder: (BuildContext context, Box<dynamic> activity, _){
        List<Widget> _widgets = [];
        for (var i = 0; i < activity.length?? 0; i++) {
          var item = activity.getAt(i);
          if(item['realized'] == type && item['id_user'] == this.widget.user.nodeId){
            _widgets.add(
              _ActivityCard(
                item: item, 
                index: i, 
                callback: (){
                  _updateActivity(i, item);
                },
              )
            ); 
          }
        }
        return Column(
          children: _widgets,
        );
      }
    );
  }

  Widget _headerBox(String text, Color color, Color colorText){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      width: double.infinity,
      color: color,
      child: Text(
        text,
        style: TextStyle(
          color: colorText,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _userInformation() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: Colors.grey[100],
      child: Row(
        children: <Widget>[
          Hero(
            tag: '${this.widget.user.nodeId}',
            child: ClipOval(
              child: Image.network('${this.widget.user.avatarUrl}', height: 80,)
            )
          ),
          SizedBox(width: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${this.widget.user.login}',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 20
                ),
              ),
              SizedBox(height: 5,),
              Text('${this.widget.user.htmlUrl}'),
            ],
          )
        ],
      ),
    );
  }

  void _myDialog(BuildContext context){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_){
        return Dialog(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      vertical: BorderSide(
                        color: Colors.grey,
                        width: 1
                      )
                    )
                  ),
                  width: double.infinity,
                  child: Text(
                    'Crear actividad',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),
                  )
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextField(
                    controller: _editingController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Añada una descripción',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1
                        ) 
                      )
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      vertical: BorderSide(
                        color: Colors.grey,
                        width: 1
                      )
                    )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          alignment: Alignment.center,
                          child: Text('Cancelar')
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          if(_editingController.text != null){
                            if(_editingController.text.trim().length > 0){
                              _addActivity();
                            }
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          alignment: Alignment.center,
                          child: Text('Crear')
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final dynamic item;
  final int index;
  final VoidCallback callback;

  const _ActivityCard({@required this.item, @required this.index, @required this.callback,});

  @override
  Widget build(BuildContext context) {
    var formatter = new DateFormat('yyyy-MM-dd H:m:s');
    String formatted = formatter.format(item['date']);
    return Card(
      child: ListTile(
        leading: GestureDetector(
          onTap: (item['realized']) 
          ? null
          : callback,
          child: Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: (item['realized']) ? Colors.green : Colors.grey,
              borderRadius: BorderRadius.circular(20)
            ),
            child: Icon(
              Icons.check, 
              color: Colors.white,
              size: 18,
            )
          ),
        ),
        title: Text('${item['text_activity']}'),
        subtitle: Text('$formatted'),
      ),
    );
  }
}