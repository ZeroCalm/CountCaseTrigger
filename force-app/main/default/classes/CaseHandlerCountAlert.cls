public class CaseHandlerCountAlert{
public static void CaseCounter(){

    List<AggregateResult> AggregateResultList = [SELECT AccountId, Account.Name name, COUNT(Id) co, 
                                                Account.Milestone1_Project__c
                        FROM Case
                        WHERE CreatedDate = LAST_N_DAYS:5
                        GROUP BY AccountId, Account.Name
                        HAVING COUNT(Id)  >= 8];

    for(AggregateResult aggr:AggregateResultList){ 

            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                if(Account.Milestone1_Project__c.Implementation_Status__c == "Transition"){    // If Status = Transition
                    // Set Outgoing Email to Implementation Coordinator "Implementation.Consultalt "
                    message.toAddresses = new String[] { Milestone1_Project__c.Client_Advisor_Email__c };
                }
                else if (Account.Milestone1_Project__c.Implementation_Status__c == "CONVERSION"){  // If Status equals "Live" - Out Of Transition
                    // Private method retrieves email address from Customer Success Managers
                    message.toAddresses = new String[] { getAddresses() };
                } 
                    // Set Email Template Id
                //EmailTemplate templateId = [Select id from EmailTemplate where name = 'Template Name'];  
                //mail.setTemplateID(templateId.Id);
                message.setSubject = 'Subject Test Message';
                message.setPlainTextBody = 'Account name: ' + aggr.get('name') + ' has ' + (Integer)aggr.get('co') + ' cases opened in the last 8 days.';
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        System.debug('Account Name: ' + aggr.get('name'));           
    }
} 

private List<String> getAddresses(){
    List<User> UserList =
            [SELECT id, name, email, isactive, profile.name, userrole.name, usertype
            FROM User 
            WHERE id 
            IN (SELECT userorgroupid 
            FROM groupmember
            WHERE group.name = 'Customer Success Managers')];

    Set<String> emailString = new Set<String>();

    for(User u: UserList){
        emailstring.add(u.email);
        System.debug(u.email);
    }   
    //System.debug('The list ' + emailstring);
    return (emailString);
}    



}




}


