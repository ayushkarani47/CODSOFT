import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
 final String text;
  final Function onTap;
   const UserTile({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: 
      Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 15),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary,borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text(text,style: TextStyle(fontSize:15 ),),
            
          ),
        ),
      // Container(
      //   decoration: BoxDecoration(
      //     color: Theme.of(context).colorScheme.secondary,
      //     borderRadius: BorderRadius.circular(12),
      //   ),
      //   child: Row(
      //     children: [
      //       Icon(
      //         Icons.person,
      //         color: Theme.of(context).colorScheme.onSecondary,
      //       ),
      //       SizedBox(width: 10),
      //       Text(
      //         text,
      //         style: TextStyle(
      //           color: Theme.of(context).colorScheme.onSecondary,
      //           fontSize: 16,
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
