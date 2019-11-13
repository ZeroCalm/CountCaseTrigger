// All test methods in this class can access all data.
@isTest(SeeAllData=true)
public class TestCaseHandlerAlert {

    // This test accesses an existing account. 
    // It also creates and accesses a new test account.
    static testmethod void testIfBLock() {
        // Query an existing account in the organization. 
        List<Case> caseList = [SELECT Id, Account.Name, Account.id, Parent_Project_if_applicable__r.Implementation_status__c,
                               		  	  Parent_Project_if_applicable__r.RCM_Implementation_Status__c , Parent_Project_if_applicable__r.PM_Implementation_Status__c,
                               			  Parent_Project_if_applicable__r.Resource_Coordinator_Email__c, Parent_Project_if_applicable__r.Client_Advisor_Email__c,
                               		      Parent_Project_if_applicable__r.Resource_Coordinator__c, Parent_Project_if_applicable__r.Client_Advisor__c
                               FROM Case
                               WHERE Account.Name='FinalTriggerAccount'
                               Limit 8];
        		List<Case> casesToInsert = caseList.clone();
      			System.debug(casesToInsert.size());
        
        	Test.startTest();
                upsert casesToInsert;
        		
				System.assertEquals(2,Limits.getEmailInvocations());
        	Test.stopTest();
        
    }
       
    @isTest static void testElseBLock() {
        List<Case> caseList = [SELECT Id, Account.Name, Account.id, Parent_Project_if_applicable__r.Implementation_status__c,
                               		  	  Parent_Project_if_applicable__r.RCM_Implementation_Status__c , Parent_Project_if_applicable__r.PM_Implementation_Status__c,
                               			  Parent_Project_if_applicable__r.Resource_Coordinator_Email__c, Parent_Project_if_applicable__r.Client_Advisor_Email__c,
                               		      Parent_Project_if_applicable__r.Resource_Coordinator__c, Parent_Project_if_applicable__r.Client_Advisor__c
                               FROM Case
                               WHERE Account.Name='FinalElseTrigger Account'
                               Limit 8];
        		List<Case> casesToInsert = caseList.clone();
      			
        
        	Test.startTest();
                upsert casesToInsert;
				System.assertEquals(2,Limits.getEmailInvocations());
        		
        	Test.stopTest();
        
        
        
   }
  
}