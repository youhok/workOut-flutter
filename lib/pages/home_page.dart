import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:workout/components/heat_map.dart';
import 'package:workout/data/workout_data.dart';
import 'package:workout/pages/workout_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: annotate_overrides
  void initState() {
    super.initState();

    Provider.of<WorkoutData>(context, listen: false).initalizeWorkoutList();
  }

  //text controller
  final newWorkoutNameController = TextEditingController();

  //create a new workout

  void createNewWorkout() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const  Text('Create a new workout'),
              content: TextField(
                controller: newWorkoutNameController,
              ),
              actions: [
                //save button
                MaterialButton(
                  onPressed: save,
                  child: const Text("save"),
                ),
                //cancel button
                MaterialButton(
                  onPressed: cancel,
                  child: const Text("cancel"),
                )
              ],
            ));
  }

  //go to work out page
  void goToWorkoutPage(String workoutName) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkoutPage(
            workoutName: workoutName,
          ),
        ));
  }

  void save() {
    //get workout name from text controller
    String newWorkoutName = newWorkoutNameController.text;
    //add workout to  workoutdata list
    Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutName);

    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    newWorkoutNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
          
          appBar: AppBar(
            title: const Text(
              'Workout Tracker',
              style: TextStyle(color: Colors.white),
            ),
            elevation: 0,
            backgroundColor: Colors.brown,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: createNewWorkout,
            backgroundColor: Colors.brown,
            child: const Icon(Icons.add, color: Colors.white),
          ),
          body: Column(
            children: [
              // HEAT MAP
              MyHeatMap(
                datasets: value.heatMapDataSet,
                startDateYYYYMMDD: value.getStartDate(),
              ),
              // WORKOUT LIST
              Expanded(
                child: ListView.builder(
                  itemCount: value.getWorkoutList().length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: ListTile(
                          leading: SizedBox(
                            width: 40,
                            height: 40,
                            child: Image.asset(
                              'lib/image/dumbbell.png',
                            ),
                          ), // Add your image here
                          title: Text(value.getWorkoutList()[index].name),
                          trailing: IconButton(
                            icon: const Icon(Icons.arrow_forward_ios),
                            onPressed: () => goToWorkoutPage(
                                value.getWorkoutList()[index].name),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          )),
    );
  }
}
