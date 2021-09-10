# Recursive Trigger Handler

## Acknowledgement
I would like to acknowledge Mina Zaklama as the credit goes to him for the initial concept. His idea is where I drew inspiration for this code.

## Trigger Recursion
Trigger recursion in Apex can be a difficult concept to wrap your head around. It's often indirect, so can be tricky to diagnose.<br>Consider an update is made on object A, then a trigger on A updates B, then a trigger on B updates A again...<br>This can end up with an infinite loop of trigger execution!<br><br>Eventually, Salesforce notices this and throws an error with “*<b>maximum trigger depth exceeded</b>*”.

Clarification Example:<br>
Let’s add an `after insert` trigger on Task to insert another Task record.

```apex
trigger TaskTrigger on Task (after insert) {

    List<Task> tasks = new List<Task>();
    for (Task task : Trigger.new) {
        tasks.add(
                new Task(
                        Subject = task.Subject + ' !'
                ));
    }
    insert tasks;
}
```
<br>Error will be thrown as the trigger is recursive:
<div align="center">
<img src="https://i.imgur.com/1BMTUXT.png" alt="maximum trigger depth exceeded">
</div>

## Resolution

The `RecursiveTriggerHandler` class has a set of methods like `TriggerOperation` enum values, which represents the trigger context and is used separately for each operation (`before insert`, `before update`, `after delete`, etc.).<br>Not only by using a single static variable for all operations, but every operation has its own static boolean value (flag) and is accessesd by its static method (`isBeforeInsert()`, `isBeforeUpdate()`, `isAfterDelete()`, and all the rest).

Here's the solution of the above problem example:

```apex
trigger TaskTrigger on Task (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    if (Trigger.isAfter && Trigger.isInsert) {
        TaskTriggerHandler.isAfterInsert(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
    }
}
```
```apex
public class TaskTriggerHandler {

    static RecursiveTriggerHandler taskTrigger = new RecursiveTriggerHandler();

    public static void isAfterInsert(List<Task> oldList, List<Task> newList, Map<Id, Task> oldMap, Map<Id, Task> newMap) {
        if (taskTrigger.isAfterInsert()) {
            TaskHelperClass.createNewTask(newList);
        }
    }
}
```
```apex
public with sharing class TaskHelperClass {

    public static void createNewTask(List<Task> newList) {
        List<Task> tasks = new List<Task>();
        for (Task task : newList) {
            tasks.add(
                    new Task(
                            Subject = task.Subject + ' !'
                    ));
        }
        insert tasks;
    }
}
```
*<b>Note</b>*: Always remember that triggers should be "logic-less" and the best practice is to use separate handler and helper classes to handle the logic.<br>This is only an example to clarify the use of the `RecursiveTriggerHandler` class.

## Considerations
On Salesforce forums, it is quite common to avoid the use of a static flag in order to avoid recursive trigger. However, the better option would be to use a `static Set<Id>`. Yet, applying the static variables method doesn’t work because Salesforce runs triggers on a maximum of 200 records at a time. So, for instance, if 400 Lead records are inserted, triggers are executed twice. Once on the first 200, then again for the remaining 200. Thus leading to the static flag reset.

Fortunately, all this has become null and void. A static variable is only static within the scope of the Apex transaction. It’s not static across the server or the entire organization. The value of a static variable persists within the context of a single transaction and is reset across transaction boundaries. For example, if an Apex DML request causes a trigger to fire multiple times, the static variables persist across these trigger invocations. Also, a static variable defined in a trigger doesn’t retain its value between different trigger contexts within the same transaction, such as between before insert and after insert invocations. Instead, define the static variables in a class so that the trigger can access these class member variables and check their static values.



