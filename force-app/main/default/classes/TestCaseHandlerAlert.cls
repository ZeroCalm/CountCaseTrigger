@isTest
private class TestCaseCountAlert1 {
    
  @testSetup static void setup(){
      List<Account> testAccounts = new List<Account>();
      
        Account a = new Account();
      		a.name = 'AccountEHRImplement';
     		a.RecordTypeId = '01230000000v58OAAQ';
      		a.Eyefinity_EHR_Status__c = 'Implementation';
      		a.Tax_Id__c = '123456789';
      testAccounts.add(a);
      
      Account b = new Account();
      		b.name = 'AccountPMImplement';
      		b.RecordTypeId = '01230000000v58OAAQ';
      		b.Eyefinity_PM_Status__c = 'Implementation';
      		b.Tax_Id__c = '123456789';
      testAccounts.add(b);
      
      Account c = new Account();
      		c.name = 'AccountIMPImplement';
      		c.Project_Imp_Status__c = 'Implementation';
      		c.Tax_Id__c = '123456789';
      testAccounts.add(c);
      
      Account a1 = new Account();
      		a1.name = 'AccountEHRActive';
      		a1.Eyefinity_EHR_Status__c = 'Active';
     		a1.Tax_Id__c = '123456789';
      		a1.RecordTypeId = '01230000000v58OAAQ';
      testAccounts.add(a1);
      
      Account b1 = new Account();
      		b1.name = 'AccountPMActive';
      		b1.Eyefinity_PM_Status__c = 'Active';
      		b1.Tax_Id__c = '123456789';
      testAccounts.add(b1);
      
      Account c1 = new Account();
      		c1.name = 'AccountIMPActive';
      		c1.Project_Imp_Status__c = 'Active';
      		c1.Tax_Id__c = '123456789';
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
      
      //Create Project
        Milestone1_Project__c project1 = new Milestone1_Project__c();
            project1.Customer_Account__c = [Select Id FROM Account Where Name ='AccountEHRImplement'].id;
        	project1.Name = 'triggerProject';
            project1.Client_Advisor__c = [Select Id FROM User Where Username ='tuserleielkwl@test18278391.org'].id;
            project1.Resource_Coordinator__c = [Select Id FROM User Where Username ='tuserleielkwl@test18278391.org'].id;   
        		insert project1;
    }
      
	@isTest static void AccountEHRImplement (){
            
            List<Case> casestoInsert = new List<Case>();   
        //Create and insert 9 cases
        
        for (Integer i=1; i<10; i++){
             Case cas1 = new Case();
                cas1.RecordTypeId = '01214000001NcOYAA0';
            	cas1.AccountId = [Select Id FROM Account Where name ='AccountEHRImplement'].id;
                cas1.Origin = 'Phone';
                cas1.Impact__c = 'Low';
                cas1.Severity__c = 'Minor';
                cas1.Type = 'Bridge';
            casesToInsert.add(cas1);
        }
        Test.startTest();
        	insert casesToInsert; 
            System.assertEquals(2, Limits.getEmailInvocations());  // Good!        
        Test.stopTest();  
    }
   
    @isTest static void AccountEHRActive (){
            
            List<Case> casestoInsert = new List<Case>();   
        //Create and insert 9 cases
        
        for (Integer i=1; i<10; i++){
             Case cas1 = new Case();
                cas1.RecordTypeId = '01214000001NcOYAA0';
            	cas1.AccountId = [Select Id FROM Account Where name ='AccountEHRActive'].id;
                cas1.Origin = 'Phone';
                cas1.Impact__c = 'Low';
                cas1.Severity__c = 'Minor';
                cas1.Type = 'Bridge';
            casesToInsert.add(cas1);
        }
        Test.startTest();
        	insert casesToInsert; 
      	  System.debug('before Expected: 1, actual: ********************' + Limits.getEmailInvocations());
        	System.assertEquals(2, Limits.getEmailInvocations()); //Debugs 2 Emails sent to console
        Test.stopTest();  
          System.debug('after Expected: 1, actual: ********************' + Limits.getEmailInvocations());
      		
    }ß
}