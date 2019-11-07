@isTest
private class TestCaseHandlerAlert {

    @isTest static void setup (){
        Account a = new Account();
    a.RecordTypeId = '01230000000v58OAAQ';
	a.name = 'testacct21';
 
  // Create parent Project

 Milestone1_Project__c project = new Milestone1_Project__c();
		project.RecordTypeId = '01214000001RYp2AAG';
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
		c.RecordTypeId = '01214000001RYp7AAG';
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
        // Grab 8 Cases and Send 'Live - Closed Project' to CSM
        List<Case> testCases = [SELECT Id FROM Case WHERE AccountId IN :casesToInsert LIMIT 8];

      Test.startTest();
        insert testCases;
      Test.stopTest();
    }    
    
    @isTest static void PassRCMimpIfBlock (){
        // Only RCM 'Live - Closed' to CSM
        List<Case> testCases = [SELECT Id FROM Case WHERE AccountId IN :casesToInsert LIMIT 8];
        List<Case> insertCases = new List<Case>();   
            for(Case cas :testCases ){
                cas.PM_Implementation_Status__c = null;
                cas.Implementation_Status__c = null;
                insertCases.add(cas);
            }

      Test.startTest();
        insert insertCases;
      Test.stopTest();
    }

    @isTest static void PassPMimpIfBlock (){
        // Only PM 'Live - Closed' to CSM
        List<Case> testCases = [SELECT Id FROM Case WHERE AccountId IN :casesToInsert LIMIT 8];
        List<Case> insertCases = new List<Case>();   
            for(Case cas :testCases ){
                cas.RCM_Implementation_Status__c = null;
                cas.Implementation_Status__c = null;
                insertCases.add(cas);
            }
        
      Test.startTest();
        insert insertCases;
      Test.stopTest();
    }

    @isTest static void PassImpIfBlock (){
        // Only Imp 'Live - Closed' to CSM
        List<Case> testCases = [SELECT Id FROM Case WHERE AccountId IN :casesToInsert LIMIT 8];
        List<Case> insertCases = new List<Case>();   
            for(Case cas :testCases ){
                cas.RCM_Implementation_Status__c = null;
                cas.PM_Implementation_Status__c = null;
                insertCases.add(cas);
            }
        
      Test.startTest();
        insert insertCases;
      Test.stopTest();
    }

@isTest static void PassOnePMimpIfBlock (){
        // Do not send, not enough Cases need 8 
        List<Case> testCases = [SELECT Id FROM Case WHERE AccountId IN :casesToInsert LIMIT 5];
        List<Case> insertCases = new List<Case>();   
       
      Test.startTest();
        insert insertCases;
      Test.stopTest();
    }

@isTest static void SendToElseBlock (){
        // Sends Email to Advisor and Coordinator
        List<Case> testCases = [SELECT Id FROM Case WHERE AccountId IN :casesToInsert LIMIT 8];
        List<Case> insertCases = new List<Case>();  
        for(Case cas :testCases ){
                cas.RCM_Implementation_Status__c = null;
                cas.Implementation_Status__c = null;
                cas.PM_Implementation_Status__c = null;

                insertCases.add(cas);
            } 
       
      Test.startTest();
        insert insertCases;
      Test.stopTest();
    }
}


