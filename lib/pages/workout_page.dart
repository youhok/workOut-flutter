import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout/components/exercise_tile.dart';
import 'package:workout/data/workout_data.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  // checkbox was tapped
  void onCheckBoxChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(context, listen: false)
        .checkoffExercise(workoutName, exerciseName);
  }

  // text controllers
  final exerciseNameController = TextEditingController();
  final weightController = TextEditingController();
  final repsController = TextEditingController();
  final setsController = TextEditingController();

  // create a new exercise
  void createNewExercise() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Add a new exercise'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // exercise name
                  TextField(
                    controller: exerciseNameController,
                    decoration:
                        const InputDecoration(hintText: 'Exercise Name'),
                  ),
                  // weight
                  TextField(
                    controller: weightController,
                    decoration: const InputDecoration(hintText: 'Weight'),
                  ),
                  // reps
                  TextField(
                    controller: repsController,
                    decoration: const InputDecoration(hintText: 'Reps'),
                  ),
                  // sets
                  TextField(
                    controller: setsController,
                    decoration: const InputDecoration(hintText: 'Sets'),
                  ),
                ],
              ),
              actions: [
                MaterialButton(
                  onPressed: save,
                  child: const Text('save'),
                ),
                MaterialButton(
                  onPressed: cancel,
                  child: const Text('cancel'),
                )
              ],
            ));
  }
  //

  void save() {
    //get get exercise name from text controller
    String newExerciseName = exerciseNameController.text;
    String weight = weightController.text;
    String reps = repsController.text;
    String sets = setsController.text;
    //add exercise to  workout
    Provider.of<WorkoutData>(context, listen: false)
        .addExercise(widget.workoutName, newExerciseName, weight, reps, sets);

    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    exerciseNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text(widget.workoutName , style: const TextStyle(color: Colors.white),),
          backgroundColor: Colors.brown,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewExercise,
          backgroundColor: Colors.brown,
          child: const Icon(Icons.add , color: Colors.white,),
        ),
        body: ListView.builder(
            itemCount: value.numberofExerciseInWorkout(widget.workoutName),
            itemBuilder: (context, index) => ExerciseTile(
                  exerciseName: value
                      .getRelevantWorkout(widget.workoutName)
                      .exercise[index]
                      .name,
                  weight: value
                      .getRelevantWorkout(widget.workoutName)
                      .exercise[index]
                      .weight,
                  reps: value
                      .getRelevantWorkout(widget.workoutName)
                      .exercise[index]
                      .reps,
                  sets: value
                      .getRelevantWorkout(widget.workoutName)
                      .exercise[index]
                      .sets,
                  isCompleted: value
                      .getRelevantWorkout(widget.workoutName)
                      .exercise[index]
                      .isCompleted,
                  onCheckBoxChanged: (val) => onCheckBoxChanged(
                      widget.workoutName,
                      value
                          .getRelevantWorkout(widget.workoutName)
                          .exercise[index]
                          .name),
                )),
      ),
    );
  }
}
