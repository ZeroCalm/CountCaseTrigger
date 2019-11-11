@isTest
private class TestCaseHandlerAlert {

    @isTest static void setup(){
        Account a = new Account();
        Account b = new Account();
			a.name = 'testacct21';
 			b.name = 'testacct31';
        
  // Create Milestone

 Milestone1_Project__c project = new Milestone1_Project__c();
		project.Name = 'triggertest21';
		project.RCM_Implementation_Status__c = 'RETURNED SOFTWARE';
		project.PM_Implementation_Status__c= 'RETURNED SOFTWARE';
		project.Implementation_Status__c= 'RETURNED SOFTWARE';
        project.Client_Advisor__r.Email= 'test@test.com';
        
        
  Milestone1_Project__c project1 = new Milestone1_Project__c();
		//project.RecordTypeId = '01214000001RYp2AAG';
		project1.Name = 'triggertest31';
		project1.RCM_Implementation_Status__c = 'LIVE - CLOSED PROJECT';
		project1.PM_Implementation_Status__c= 'RETURNED SOFTWARE';
		project1.Implementation_Status__c= 'RETURNED SOFTWARE';
		project1.Client_Advisor__r.Email = 'test@test.com';
        
  	 //Insert Account
  	insert a;
	insert b;
    //Insert Project
	insert project;
    insert project1;
    
    //Create 10 Cases associated with Project
    
	List<Case> casesToInsert = new List<Case>();
    List<Case> casesToInsert1 = new List<Case>();
        
        for (Integer i=1; i<12; i++){  
        Case c1 = new Case();
		c1.AccountId = b.id;
		c1.Origin = 'Phone';
		c1.Impact__c = 'Low';
		c1.Severity__c = 'Minor';
		c1.Type = 'Bridge';
		c1.Parent_Project_if_applicable__c = project.id;
 
        casesToInsert1.add(c1);
    }          

    for (Integer i=1; i<12; i++){
   
	Case c = new Case();
		c.AccountId = a.id;
		c.Origin = 'Phone';
		c.Impact__c = 'Low';
		c.Severity__c = 'Minor';
		c.Type = 'Bridge';
		c.Parent_Project_if_applicable__c = project1.id;
 
        casesToInsert.add(c);
    }
       
      insert casesToInsert; 
      insert casesToInsert1;
        
    }

	 
    
    

@isTest static void DontSendNotLimit (){
        // Do not send, not enough Cases need 8 
        List<Case> testCases = [SELECT Id FROM Case WHERE Account.Name='testacct21' LIMIT 5];
        List<Case> insertCases = new List<Case>();   
       
      Test.startTest();
        insert insertCases;
   		System.debug(Limits.getEmailInvocations());
      Test.stopTest();
    }
    
@isTest static void SendElseBlock (){
        // Else BLock Fires - 2 emails sent 
        List<Case> testCases = [SELECT Id FROM Case WHERE Account.Name='testacct21' LIMIT 8];
        List<Case> insertCases = new List<Case>();   
       
      Test.startTest();
        insert insertCases;
   		System.debug(Limits.getEmailInvocations());
      Test.stopTest();
    }   
    
       

@isTest static void SendRCMiFBlock (){
        // Fires the If BLock 1/3
        List<Case> testCases = [SELECT Id FROM Case WHERE Account.Name='testacct31' LIMIT 8];
        List<Case> insertCases = new List<Case>();  
        for(Case cas :testCases ){
                
                insertCases.add(cas);
            } 
       
      Test.startTest();
        insert insertCases;	
      Test.stopTest();
    }
    
    @isTest static void SendPMiFBlock (){
        // Fires the If BLock 2/3
        List<Case> testCases = [SELECT Id FROM Case WHERE Account.Name='testacct31' LIMIT 8];
        List<Case> insertCases = new List<Case>();  
        for(Case cas :testCases ){
            		
                cas.Parent_Project_if_applicable__r.PM_Implementation_Status__c = 'LIVE - CLOSED PROJECT';
                insertCases.add(cas);
            } 
       
      Test.startTest();
        insert insertCases;	
      Test.stopTest();
    }
    
    @isTest static void SendIMPiFBlock (){
        // Fires the If BLock 3/3
        List<Case> testCases = [SELECT Id FROM Case WHERE Account.Name='testacct31' LIMIT 8];
        List<Case> insertCases = new List<Case>();  
        for(Case cas :testCases ){
                cas.Parent_Project_if_applicable__r.Implementation_Status__c= 'LIVE - CLOSED PROJECT';
                insertCases.add(cas);
            } 
       
      Test.startTest();
        insert insertCases;	
      Test.stopTest();
    }
    
    
}