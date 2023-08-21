trigger ServiceRequestLineItemTriggerHandler on Service_Request_Line_Item__c (before update) {
    for (Service_Request_Line_Item__c sli : Trigger.new) {
        Service_Request_Line_Item__c oldSli = Trigger.oldMap.get(sli.Id);
        if (oldSli.Reason_code__c != sli.Reason_code__c) {
            if (sli.Reason_code__c == 'No Records') {
                sli.Status__c = 'Complete';
            } else if (sli.Status__c == 'QA_Inprogress' && sli.Reason_code__c == 'Partial Document Received') {
                sli.Status__c = 'New';
            } else if (sli.Status__c == 'QA_Inprogress' && sli.Reason_code__c == 'Full Document Received') {
                sli.Status__c = 'Complete';
            } else if (sli.Reason_code__c == 'Cancel') {
                sli.Status__c = 'Complete';
                sli.Cancel_Date_Time__c = System.now();
            } else if (sli.Reason_code__c == 'Incorrect Document Received') {
                sli.Status__c = 'New';
            }
        }
    }
}