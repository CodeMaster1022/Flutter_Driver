import 'package:flutter/material.dart';
import 'package:kenorider_driver/common/colormanager.dart';
import 'package:kenorider_driver/common/textcontent.dart';
import 'package:kenorider_driver/views/mainpage.dart';

class RatePage extends StatefulWidget {
  @override
  _RatePageState createState() => _RatePageState();
}

class _RatePageState extends State<RatePage> {
  int _selectedRating = 0;
    TextEditingController _reviewController = TextEditingController();
  bool _isLoading = false;

  void _onSubmitButtonPress() {
    if (_reviewController.text.isEmpty || _selectedRating == 0) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Warning'),
          content: Text('Please leave a review and select rate.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      setState(() {
        _isLoading = true; // Toggle loading state
      });
      Future.delayed(Duration(seconds: 4), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder focusedBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1),
      borderRadius: BorderRadius.circular(20),
    );

    final OutlineInputBorder enabledInputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1),
      borderRadius: BorderRadius.circular(20),
    );

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      ColorManager.primary_color,
                      ColorManager.dark_primary_color,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 50,),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        Spacer(),
                        Text(
                          'Rate your Passenger',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                    SizedBox(height: 20),
                    CircleAvatar(
                      backgroundImage: AssetImage(Apptext.riderAvatarImage),
                      radius: 45,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'John Pierce',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
              Transform.translate(
                offset: Offset(0, -30),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          Icons.star,
                          color: index < _selectedRating ? ColorManager.button_star_color : Colors.grey,
                          size: 40,
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedRating = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _reviewController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            labelText: 'Leave a Review',
                            labelStyle: TextStyle(color: Colors.black),
                            hintText: "The passenger is so kind and honest:D ",
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            focusedBorder: focusedBorder,
                            enabledBorder: enabledInputBorder,
                          ),
                        ),
                        SizedBox(height: 80), // Add space to avoid overlap with the button
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 80,
              padding: EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _onSubmitButtonPress,
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        ColorManager.dark_primary_color,
                        ColorManager.primary_color,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    constraints: BoxConstraints(
                      maxWidth: double.infinity,
                      minHeight: 45,
                    ),
                    child: _isLoading
                        ? Center(
                            child: SizedBox(
                              width: 24.0, // Custom width
                              height: 24.0, // Custom height
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 3.0, // Optional: custom stroke width
                              ),
                            ),
                          )
                        : Text(
                            'Submit Review',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30.0),
                          topLeft: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 30),
                          Image.asset(Apptext.allArrivedImage),
                          SizedBox(height: 20),
                          Text(
                            'Rate Succeed!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'You will automatically direct back to the Homepage in a moment.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
