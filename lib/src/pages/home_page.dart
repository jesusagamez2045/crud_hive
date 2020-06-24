import 'package:flutter/material.dart';
import 'package:prueba_gbp/src/model/user_model.dart';
import 'package:prueba_gbp/src/pages/activity_page.dart';
import 'package:prueba_gbp/src/repository/user_repository.dart';


class HomePage extends StatelessWidget {

  final UserRepository _userRepository = new UserRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Prueba GBP'),
        leading: Icon(
          Icons.menu,
          size: 40,
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: FutureBuilder(
          future: _userRepository.getUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
            }else{
              if(snapshot.data != null){
                return _ListUsers(users: snapshot.data,);
              }else{
                return Container();
              }
            }
          },
        ),
      ),
    );
  }
}

class _ListUsers extends StatelessWidget {

  final List<UserModel> users;

  _ListUsers({@required this.users});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemCount: users.length?? 0,
      itemBuilder: (BuildContext context, int index){
        final user = users[index];
        return _CardUser(user: user);
      }, 
      separatorBuilder: (BuildContext context, int index){
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          width: double.infinity,
          height: 1,
          color: Colors.grey,
        );
      }, 
    );
  }
}

class _CardUser extends StatelessWidget {
  final UserModel user;
  
  _CardUser({@required this.user});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => ActivityPage(user: this.user,)
          )
        );
      },
      child: ListTile(
        title: Text(
          '${user.login}',
          style: TextStyle(
            color: Colors.blueAccent,
            fontSize: 20,
          ),
        ),
        subtitle: Text('${user.htmlUrl}'),
        leading: Hero(
          tag: '${user.nodeId}',
          child: ClipOval(
            child: Image.network(user.avatarUrl)
          )
        ),
      ),
    );
  }
}