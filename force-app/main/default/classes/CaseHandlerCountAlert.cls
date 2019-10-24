public class CaseHandlerCountAlert{
    public static void CaseCounter(){

        List<AggregateResult> AggregateResultList = [SELECT AccountId, Account.Name name, COUNT(Id) co
                            FROM Case
                            WHERE CreatedDate = LAST_N_DAYS:5
                            GROUP BY AccountId, Account.Name
                            HAVING COUNT(Id)  >= 8];

        for(AggregateResult aggr:AggregateResultList){ 

                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    if(Account.Milestone1_Project__c.Implementation_Status__c == "Transition"){    // If Status = Transition
                    //Account - ParentProject.Implementation_Status__c == "Transition"
                        // Set Outgoing Email to Implementation Coordinator "Implementation.Consultalt "
                        message.toAddresses = new String[] { Milestone1_Project__c.Client_Advisor_Email__c };
                    }
                    else if (Account.Milestone1_Project__c.Implementation_Status__c == "CONVERSION"){  // If Status equals "Live" - Out Of Transition
                        // Set Outgoing Email to Customer Success Managers - Public Group
                        message.toAddresses = new String[] { 'customersuccessmanagers@eyefinity.com' };
                    } 
                        // Set Email Template Id
                    //EmailTemplate templateId = [Select id from EmailTemplate where name = 'Template Name'];  
                    //mail.setTemplateID(templateId.Id);
                    message.subject = 'Subject Test Message';
                    message.plainTextBody = 'Account name: ' + aggr.get('name') + ' has ' + (Integer)aggr.get('co') + ' cases opened in the last 8 days.';
                Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            System.debug('Account Name: ' + aggr.get('name'));           
        }
    } 
}
