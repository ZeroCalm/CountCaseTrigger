@isTest
private class TestCaseHandlerAlert {

    
    
  @testSetup static void setup(){
      List<Account> testAccounts = new List<Account>();
      
        Account a = new Account();
      		a.name = 'AccountEHRImplement';
      		a.Eyefinity_EHR_Status__c = 'Implementation';
      testAccounts.add(a);
      
      Account b = new Account();
      		b.name = 'AccountPMImplement';
      		b.Eyefinity_PM_Status__c = 'Implementation';
      testAccounts.add(b);
      
      Account c = new Account();
      		c.name = 'AccountIMPImplement';
      		c.Project_Imp_Status__c = 'Implementation';
      testAccounts.add(c);
      
      Account a1 = new Account();
      		a1.name = 'AccountEHRActive1';
      		a1.Eyefinity_EHR_Status__c = 'Active';
      testAccounts.add(a1);
      
      Account b1 = new Account();
      		b1.name = 'AccountPMActive';
      		b1.Eyefinity_PM_Status__c = 'Active';
      testAccounts.add(b1);
      
      Account c1 = new Account();
      		c1.name = 'AccountIMPActive1';
      		c1.Project_Imp_Status__c = 'Active';
      testAccounts.add(c1);
      		
      
       
     
        //Insert Accounts
  		    insert testAccounts;
        
   		 //Create User:
     	User tuser = new User(  firstname = 'tuserFname',
                            lastName = 'tuserLastname',
                            email = 'test@tester.com',
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

	@isTest static void AccountEHRImplement (){
            
            List<Case> casestoInsertIf = new List<Case>();  
        
        //Create Project
        Milestone1_Project__c project1 = new Milestone1_Project__c();
            //project.RecordTypeId = '01214000001RYp2AAG';
            project1.Name = 'triggerProjectIFBLOCK';
            //project1.RCM_Implementation_Status__c= 'LIVE - CLOSED PROJECT';
            project1.Client_Advisor__c = [Select Id FROM User Where Username ='tuserleielkwl@test18278391.org'].id;
            project1.Resource_Coordinator__c = [Select Id FROM User Where Username ='tuserleielkwl@test18278391.org'].id;  
                insert project1;
            
        for (Integer i=1; i<10; i++){
            Case cas1 = new Case();
                cas1.AccountId = [Select Id FROM Account Where name ='AccountEHRImplement'].id;
                cas1.Origin = 'Phone';
                cas1.Impact__c = 'Low';
                cas1.Severity__c = 'Minor';
                cas1.Type = 'Bridge';
                cas1.Parent_Project_if_applicable__c = project1.id;
            casesToInsertIf.add(cas1);
         }
        
        Test.startTest();
            insert casesToInsertIf; 
        System.assertEquals(2, Limits.getEmailInvocations());
        Test.stopTest();
           
    }
     
@isTest static void AccountPMImplement (){
            // Send to Global Email Address 
            List<Case> casestoInsertIf = new List<Case>();  
        
        //Create Project
        Milestone1_Project__c project1 = new Milestone1_Project__c();
            //project.RecordTypeId = '01214000001RYp2AAG';
            project1.Name = 'triggerProjectIFBLOCK';
            //project1.RCM_Implementation_Status__c= 'LIVE - CLOSED PROJECT';
            project1.Client_Advisor__c = [Select Id FROM User Where Username ='tuserleielkwl@test18278391.org'].id;
            project1.Resource_Coordinator__c = [Select Id FROM User Where Username ='tuserleielkwl@test18278391.org'].id;  
                insert project1;
            
        for (Integer i=1; i<10; i++){
            Case cas1 = new Case();
                cas1.AccountId = [Select Id FROM Account Where name ='AccountPMImplement'].id;
                cas1.Origin = 'Phone';
                cas1.Impact__c = 'Low';
                cas1.Severity__c = 'Minor';
                cas1.Type = 'Bridge';
                cas1.Parent_Project_if_applicable__c = project1.id;
            casesToInsertIf.add(cas1);
         }
        
        Test.startTest();
            insert casesToInsertIf; 
        System.assertEquals(2, Limits.getEmailInvocations());
        Test.stopTest();
            
    }


@isTest static void AccountIMPImplement (){
            // Send to Global Email Address 
            List<Case> casestoInsertIf = new List<Case>();  
        
        //Create Project
        Milestone1_Project__c project1 = new Milestone1_Project__c();
            //project.RecordTypeId = '01214000001RYp2AAG';
            project1.Name = 'triggerProjectIFBLOCK';
            //project1.RCM_Implementation_Status__c= 'LIVE - CLOSED PROJECT';
            project1.Client_Advisor__c = [Select Id FROM User Where Username ='tuserleielkwl@test18278391.org'].id;
            project1.Resource_Coordinator__c = [Select Id FROM User Where Username ='tuserleielkwl@test18278391.org'].id;  
                insert project1;
            
        for (Integer i=1; i<10; i++){
            Case cas1 = new Case();
                cas1.AccountId = [Select Id FROM Account Where name ='AccountIMPImplement'].id;
                cas1.Origin = 'Phone';
                cas1.Impact__c = 'Low';
                cas1.Severity__c = 'Minor';
                cas1.Type = 'Bridge';
                cas1.Parent_Project_if_applicable__c = project1.id;
            casesToInsertIf.add(cas1);
         }
        
        Test.startTest();
            insert casesToInsertIf; 
        System.assertEquals(2, Limits.getEmailInvocations());
        Test.stopTest();
            
    }
    
    @isTest static void AccountEHRActive1 (){
            // Send to Global Email Address 
            List<Case> casestoInsertIf = new List<Case>();  
        
        //Create Project
        Milestone1_Project__c project1 = new Milestone1_Project__c();
            //project.RecordTypeId = '01214000001RYp2AAG';
            project1.Name = 'triggerProjectIFBLOCK';
            //project1.RCM_Implementation_Status__c= 'LIVE - CLOSED PROJECT';
            project1.Client_Advisor__c = [Select Id FROM User Where Username ='tuserleielkwl@test18278391.org'].id;
            project1.Resource_Coordinator__c = [Select Id FROM User Where Username ='tuserleielkwl@test18278391.org'].id;  
                insert project1;
            
        for (Integer i=1; i<10; i++){
            Case cas1 = new Case();
                cas1.AccountId = [Select Id FROM Account Where name ='AccountEHRActive1'].id;
                cas1.Origin = 'Phone';
                cas1.Impact__c = 'Low';
                cas1.Severity__c = 'Minor';
                cas1.Type = 'Bridge';
                cas1.Parent_Project_if_applicable__c = project1.id;
            casesToInsertIf.add(cas1);
         }
        
        Test.startTest();
            insert casesToInsertIf; 
        System.assertEquals(2, Limits.getEmailInvocations());
        Test.stopTest();
            
    }
    
}