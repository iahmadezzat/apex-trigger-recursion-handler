/**
 * Created by Ahmad on 8/24/2021.
 */

@IsTest
public with sharing class RecursiveTriggerHandlerTest {

    @IsTest
    static void RecursiveTriggerHandlerTest() {
        Test.startTest();
        RecursiveTriggerHandler triggerLocker = new RecursiveTriggerHandler(Account.SObjectType);
        triggerLocker.isAfterDelete();
        triggerLocker.isAfterInsert();
        triggerLocker.isAfterUpdate();
        triggerLocker.isAfterDelete();
        triggerLocker.isAfterInsert();
        triggerLocker.isAfterUpdate();
        triggerLocker.isAfterDelete();
        triggerLocker.isBeforeDelete();
        triggerLocker.isBeforeInsert();
        triggerLocker.isBeforeUpdate();
        triggerLocker.isBeforeDelete();
        triggerLocker.isBeforeInsert();
        triggerLocker.isBeforeUpdate();
        triggerLocker.isAfterUndelete();
        triggerLocker.isAfterUndelete();
        Test.stopTest();
    }
}