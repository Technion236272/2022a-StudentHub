import 'package:flutter/material.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  Widget build(BuildContext context) {
    var tickets = ListView.builder(itemBuilder: (context, i) {
      return const Ticket("_title", "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", "14:30");
    }, itemCount: 10,);

    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: const SearchAppBar(),
      body: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            boxShadow: [BoxShadow(
              color: Colors.deepPurple,
              blurRadius: 3.0,
            )]
        ),
        child: Column(
          children: [
            Container(
              child: const Icon(Icons.account_balance_sharp, size: 100),
              margin:  const EdgeInsets.fromLTRB(0, 15, 0, 10)
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(onPressed: () {}, icon: Icon(Icons.post_add_rounded)),
            ),
            Expanded(child: tickets,),
          ],
        ),
      )
    );
  }
}

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  const SearchAppBar({Key? key}) : super(key: key);

  @override
  _SearchAppBarState createState() => _SearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class _SearchAppBarState extends State<SearchAppBar> with SingleTickerProviderStateMixin {
  late double rippleStartX, rippleStartY;
  late AnimationController _controller;
  late Animation _animation;

  @override
  initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text("Student HUB"),
          actions: [
            GestureDetector(
              child: IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ), onPressed: () { },
              ),
              onTapUp: onSearchTapUp,
            ),
          ],
        )
      ],
    );
  }

  void onSearchTapUp(TapUpDetails details) {
    setState(() {
      rippleStartX = details.globalPosition.dx;
      rippleStartY = details.globalPosition.dy;
    });

    print("pointer location $rippleStartX, $rippleStartY");
    _controller.forward();
  }
}

class MyPainter extends CustomPainter {
  final Offset center;
  final double radius, containerHeight;
  final BuildContext context;

  late Color color;
  late double statusBarHeight, screenWidth;

  MyPainter({required this.context, required this.containerHeight, required this.center, required this.radius}) {
    ThemeData theme = Theme.of(context);

    color = theme.primaryColor;
    statusBarHeight = MediaQuery.of(context).padding.top;
    screenWidth = MediaQuery.of(context).size.width;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint circlePainter = Paint();

    circlePainter.color = color;
    canvas.clipRect(Rect.fromLTWH(0, 0, screenWidth, containerHeight + statusBarHeight));
    canvas.drawCircle(center, radius, circlePainter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Ticket extends StatefulWidget {
  final String _time;
  final String _title;
  final String _desc;

  const Ticket(this._title, this._desc, this._time, {Key? key}) : super(key: key);

  @override
  _TicketState createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  bool _isSaved = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  const EdgeInsets.fromLTRB(5, 10, 5, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [BoxShadow(
          color: Colors.deepPurple,
          blurRadius: 3.0,
        )]
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget._title, maxLines: 1, style: TextStyle(fontSize: 25, color: Colors.white),),
              IconButton(onPressed: love, icon: _isSaved? const Icon(Icons.favorite, color: Colors.redAccent,) : const Icon(Icons.favorite_border_outlined, color: Colors.white,))
            ],
          ),
          Text(widget._desc, maxLines: 3, overflow: TextOverflow.fade, style: TextStyle(fontSize: 17, color: Colors.white)),
          Container(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(widget._time, style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
            margin:  const EdgeInsets.only(top: 10),
          )
        ],
      ),
    );
  }

  void love() {
    setState(() {
      _isSaved = !_isSaved;
    });
  }
}


