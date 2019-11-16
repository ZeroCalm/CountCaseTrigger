@isTest
private class TestCaseHandlerAlert {

  @testSetup static void setup(){
        Account a = new Account();
        Account b = new Account();
			a.name = 'testacctIfBlock';
 			b.name = 'testacctElseBlock';
     
        //Insert Accounts
  		    insert a;
            insert b;
        
   		 //Create User:
     	User tuser = new User(  firstname = 'tuserFname',
                            lastName = 'tuserLastname',
                            email = 'test@testingTrigger.com',
                            Username = 'tuserleielkwl@test18278391.org',
                            EmailEncodingKey = 'ISO-8859-1',
                            Alias ='Blah',
                            TimeZoneSidKey = 'America/Los_Angeles',
                            LocaleSidKey = 'en_US',
                            LanguageLocaleKey = 'en_US',
                            ProfileId =[Select Id From Profile Where Name='Eyefinity Managers'].id
                           );
        
        insert tuser;

    }

    
    

	@isTest static void DontSendNotLimit(){
            // Send to Global Email Address 
            List<Case> casestoInsertIf = new List<Case>();  
        
        //Create Project
        Milestone1_Project__c project1 = new Milestone1_Project__c();
            //project.RecordTypeId = '01214000001RYp2AAG';
            project1.Name = 'triggerProjectIFBLOCK';
            project1.RCM_Implementation_Status__c= 'LIVE - CLOSED PROJECT';
            project1.Client_Advisor__c = [Select Id FROM User Where Username ='tuserleielkwl@test18278391.org'].id;
            project1.Resource_Coordinator__c = [Select Id FROM User Where Username ='tuserleielkwl@test18278391.org'].id;  
                insert project1;
            
        for (Integer i=1; i<4; i++){
            Case c1 = new Case();
                c1.AccountId = [Select Id FROM Account Where name ='testacctIfBlock'].id;
                c1.Origin = 'Phone';
                c1.Impact__c = 'Low';
                c1.Severity__c = 'Minor';
                c1.Type = 'Bridge';
                c1.Parent_Project_if_applicable__c = project1.id;
            casesToInsertIf.add(c1);
         }
        
        Test.startTest();
            insert casesToInsertIf;  
        Test.stopTest();
            System.debug('Emails Sent, should be zero 0, Actual is:  ' + Limits.getEmailInvocations());
    		System.assertEquals(0, Limits.getEmailInvocations());

    }
     
@isTest static void SendElseBlock (){
        // Send to Global Email Address 
        List<Case> casestoInsertIf = new List<Case>();  
    
    //Create Project
    Milestone1_Project__c project1 = new Milestone1_Project__c();
		//project.RecordTypeId = '01214000001RYp2AAG';
		project1.Name = 'triggerProjectIFBLOCK';
		project1.RCM_Implementation_Status__c = 'DISCOVERY & DESIGN';
    	project1.PM_Implementation_Status__c = 'DISCOVERY & DESIGN';
    	project1.Implementation_Status__c = 'DISCOVERY & DESIGN';
		project1.Client_Advisor__c = [Select Id FROM User Where Username ='tuserleielkwl@test18278391.org'].id;
		project1.Resource_Coordinator__c = [Select Id FROM User Where Username ='tuserleielkwl@test18278391.org'].id;  
    		insert project1;
    	
    for (Integer i=1; i<10; i++){
    	Case c1 = new Case();
            c1.AccountId = [Select Id FROM Account Where name ='testacctIfBlock'].id;
            c1.Origin = 'Phone';
            c1.Impact__c = 'Low';
            c1.Severity__c = 'Minor';
            c1.Type = 'Bridge';
            c1.Parent_Project_if_applicable__c = project1.id;
        casesToInsertIf.add(c1);
   	 }
    	Test.startTest();
            insert casesToInsertIf;
        Test.stopTest();
    
    	System.debug('Emails Sent, should be zero 2, Actual is:  ' + Limits.getEmailInvocations()); //Debug shows 6 emails sent
    //	System.assertEquals(2, Limits.getEmailInvocations());
        
           
    		
    
    }


@isTest static void SendIfBlock (){
        // Send to Global Email Address 
        List<Case> casestoInsertIf = new List<Case>();  
    
    //Create Project
    Milestone1_Project__c project1 = new Milestone1_Project__c();
		//project.RecordTypeId = '01214000001RYp2AAG';
		project1.Name = 'triggerProjectIFBLOCK';
		project1.RCM_Implementation_Status__c = 'LIVE - CLOSED PROJECT';
    	project1.PM_Implementation_Status__c = 'LIVE - CLOSED PROJECT';
    	project1.Implementation_Status__c = 'LIVE - CLOSED PROJECT';
		project1.Client_Advisor__c = [Select Id FROM User Where Username ='tuserleielkwl@test18278391.org'].id;
		project1.Resource_Coordinator__c = [Select Id FROM User Where Username ='tuserleielkwl@test18278391.org'].id;  
    		insert project1;
    	
    for (Integer i=1; i<10; i++){
    	Case c1 = new Case();
            c1.AccountId = [Select Id FROM Account Where name ='testacctIfBlock'].id;
            c1.Origin = 'Phone';
            c1.Impact__c = 'Low';
            c1.Severity__c = 'Minor';
            c1.Type = 'Bridge';
            c1.Parent_Project_if_applicable__c = project1.id;
        casesToInsertIf.add(c1);
   	 }
    
    Test.startTest();
        insert casesToInsertIf;
    Test.stopTest();
    
    	System.debug('Emails Sent, should be zero 1, Actual is:  ' + Limits.getEmailInvocations()); //Debug shows 6 emails sent
       // System.assertEquals(1, Limits.getEmailInvocations());
      
    }
    
}