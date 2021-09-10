/**
 * Created by Ahmad on 8/24/2021.
 */

public with sharing class RecursiveTriggerHandler {

    Boolean isAfterInsert;
    Boolean isAfterUpdate;
    Boolean isAfterDelete;
    Boolean isBeforeInsert;
    Boolean isBeforeUpdate;
    Boolean isBeforeDelete;
    Boolean isAfterUndelete;
    SObjectType sObjectType;

    public RecursiveTriggerHandler(SObjectType sObjectType) {
        this();
        this.sObjectType = sObjectType;
    }

    public RecursiveTriggerHandler() {
        isAfterInsert = true;
        isAfterUpdate = true;
        isAfterDelete = true;
        isBeforeInsert = true;
        isBeforeUpdate = true;
        isBeforeDelete = true;
        isAfterUndelete = true;
    }

    public Boolean isBeforeInsert() {
        if (isBeforeInsert) {
            isBeforeInsert = false;
            return true;
        } else {
            return isBeforeInsert;
        }
    }

    public Boolean isBeforeUpdate() {
        if (isBeforeUpdate) {
            isBeforeUpdate = false;
            return true;
        } else {
            return isBeforeUpdate;
        }
    }

    public Boolean isBeforeDelete() {
        if (isBeforeDelete) {
            isBeforeDelete = false;
            return true;
        } else {
            return isBeforeDelete;
        }
    }

    public Boolean isAfterInsert() {
        if (isAfterInsert) {
            isAfterInsert = false;
            return true;
        } else {
            return isAfterInsert;
        }
    }

    public Boolean isAfterUpdate() {
        if (isAfterUpdate) {
            isAfterUpdate = false;
            return true;
        } else {
            return isAfterUpdate;
        }
    }

    public Boolean isAfterDelete() {
        if (isAfterDelete) {
            isAfterDelete = false;
            return true;
        } else {
            return isAfterDelete;
        }
    }

    public Boolean isAfterUndelete() {
        if (isAfterUndelete) {
            isAfterUndelete = false;
            return true;
        } else {
            return isAfterUndelete;
        }
    }
}