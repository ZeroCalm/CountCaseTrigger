@isTest
private class TestCaseHandlerAlert {

    @isTest static void setup(){
        Account a = new Account();
    		//a.RecordTypeId = '01230000000v58OAAQ';
			a.name = 'testacct21';
 
  // Create parent Project

 Milestone1_Project__c project = new Milestone1_Project__c();
		//project.RecordTypeId = '01214000001RYp2AAG';
		project.Name = 'triggertest12';
		project.RCM_Implementation_Status__c = 'LIVE - CLOSED PROJECT';
		project.PM_Implementation_Status__c = 'LIVE - CLOSED PROJECT';
		project.Implementation_Status__c = 'LIVE - CLOSED PROJECT';

  	 //Insert Account
  	insert a;

    //Insert Project
	insert project;
    
    //Create 10 Cases associated with Project
    
	List<Case> casesToInsert = new List<Case>();

    for (Integer i=1; i<12; i++){
   
	Case c = new Case();
		c.AccountId = a.id;
	//	c.RecordTypeId = '01214000001RYp7AAG';
		c.Origin = 'Phone';
		c.Impact__c = 'Low';
		c.Severity__c = 'Minor';
		c.Type = 'Bridge';
		c.Parent_Project_if_applicable__c = project.id;
 
        casesToInsert.add(c);
    }          
      insert casesToInsert;        
    }

	@isTest static void PassSendEmailIfBlock (){
        // Set 3/3 fields to 'Live - Closed Project' Send to Global Email Address
        List<Case> testCases = [SELECT Id FROM Case WHERE Account.Name='testacct21' LIMIT 8];

      Test.startTest();
        insert testCases;
        System.assertEquals(1, Limits.getEmailInvocations());
      Test.stopTest();
    }    
    
    @isTest static void PassRCMimpIfBlock (){
        // Set field number 1/3 to 'Live - Closed Project' Send to Global Email Address
        List<Case> testCases = [SELECT Id FROM Case WHERE Account.Name='testacct21' LIMIT 8];
        List<Case> insertCases = new List<Case>();   
            for(Case cas :testCases){
                cas.Parent_Project_If_Applicable__r.PM_Implementation_Status__c = null;
                cas.Parent_Project_If_Applicable__r.Implementation_Status__c = null;
                insertCases.add(cas);
            }

      Test.startTest();
        insert insertCases;
        System.assertEquals(1, Limits.getEmailInvocations());
      Test.stopTest();
    }

    @isTest static void PassPMimpIfBlock (){
        // Set field number 2/3 to 'Live - Closed Project' Send to Global Email Address
        List<Case> testCases = [SELECT Id FROM Case WHERE Account.Name='testacct21' LIMIT 8];
        List<Case> insertCases = new List<Case>();   
            for(Case cas :testCases ){
                cas.Parent_Project_If_Applicable__r.RCM_Implementation_Status__c = null;
                cas.Parent_Project_If_Applicable__r.Implementation_Status__c = null;
                insertCases.add(cas);
            }
        
      Test.startTest();
        insert insertCases;
        System.assertEquals(1, Limits.getEmailInvocations());
      Test.stopTest();
    }

    @isTest static void PassImpIfBlock (){
        // Set field number 3/3 to 'Live - Closed Project' Send to Global Email Address
        List<Case> testCases = [SELECT Id FROM Case WHERE Account.Name='testacct21' LIMIT 8];
        List<Case> insertCases = new List<Case>();   
            for(Case cas :testCases ){
                cas.Parent_Project_If_Applicable__r.RCM_Implementation_Status__c = null;
                cas.Parent_Project_If_Applicable__r.PM_Implementation_Status__c = null;
                insertCases.add(cas);
            }
        
      Test.startTest();
        insert insertCases;
        System.assertEquals(1, Limits.getEmailInvocations());
      Test.stopTest();
    }

@isTest static void DontSendIfBlock (){
        // Do not send, not enough Cases need 8 
        List<Case> testCases = [SELECT Id FROM Case WHERE Account.Name='testacct21' LIMIT 5];
        List<Case> insertCases = new List<Case>();   
       
      Test.startTest();
        insert insertCases;
   		System.assertEquals(0, Limits.getEmailInvocations());
      Test.stopTest();
    }

@isTest static void SendToElseBlock (){
        // Sends Email to Advisor and Coordinator
        List<Case> testCases = [SELECT Id FROM Case WHERE Account.Name='testacct21' LIMIT 8];
        List<Case> insertCases = new List<Case>();  
        for(Case cas :testCases ){
                cas.Parent_Project_If_Applicable__r.RCM_Implementation_Status__c = null;
                cas.Parent_Project_If_Applicable__r.Implementation_Status__c = null;
                cas.Parent_Project_If_Applicable__r.PM_Implementation_Status__c = null;

                insertCases.add(cas);
            } 
       
      Test.startTest();
        insert insertCases;
    	System.assertEquals(2, Limits.getEmailInvocations());
      Test.stopTest();
    }
}