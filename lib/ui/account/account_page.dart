import 'package:flutter/material.dart';
import 'package:food_recipe_app/theme/color_primary.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 135,
            backgroundColor: MyColor.primary,
            pinned: true,
            floating: false,
            elevation: 0,
            shadowColor: Colors.white,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Profile',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)
                    ),
                    child: Container(
                      width: double.maxFinite,
                      height: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 40
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(200)),
                      child: Container(
                        width: 150,
                        height: 150,
                        color: Colors.black12,
                        child: Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      'Nick Name',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                  Text(
                    'email',
                    style: GoogleFonts.poppins(
                        color: Colors.black45,
                        fontSize: 15,
                    ),
                  )
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
            ),
          ),
          item('Account', Icon(Icons.person_outline), context),
          item('FAQ & Help', Icon(Icons.help_outline), context),
          item('Log out', Icon(Icons.logout), context)
        ],
      ),
    );
  }
}

SliverToBoxAdapter item(String name, Icon icon, BuildContext context, ) {
  return SliverToBoxAdapter(
    child: Container(
        margin: EdgeInsets.only(
            left: 10,
            bottom: 10,
            right: 10
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            child: Card(
              elevation: 1,
              child: Container(
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          width: 60,
                          child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(200)),
                              child: Icon(icon.icon, color: MyColor.primary,size: 24)
                          ),
                        ),
                        Container(
                          child: Text(
                            name,
                            style: TextStyle(
                                fontSize: 14
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.navigate_next,
                        color: Colors.black38,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
    ),
  );
}
