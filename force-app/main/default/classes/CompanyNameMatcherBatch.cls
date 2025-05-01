/**
 * Batch Apex class to process Lead records and find potential company matches
 */
global class CompanyNameMatcherBatch implements Database.Batchable<sObject>, Database.Stateful {
    
    // Minimum similarity score to consider a match (configurable)
    private Decimal minimumSimilarityThreshold = 85.0;
    
    // Map to track processing results
    private Map<Id, String> processedLeads = new Map<Id, String>();
    
    // Query to retrieve unprocessed leads
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(
            'SELECT Id, Company, Status ' + 
            'FROM Lead ' +
            'WHERE Company != null ' + 
            'AND Status = \'Open\' ' +  // Adjust status filter as needed
            'ORDER BY CreatedDate DESC ' +
            'LIMIT 50000'  // Process in chunks
        );
    }
    
    global void execute(Database.BatchableContext BC, List<Lead> scope) {
        // Get all existing accounts to match against
        Map<String, Account> existingAccounts = new Map<String, Account>();
        for (Account acc : [SELECT Id, Name FROM Account]) {
            existingAccounts.put(acc.Name, acc);
        }
        
        // Lists for DML operations
        List<Lead> leadsToUpdate = new List<Lead>();
        
        // Process each lead
        for (Lead lead : scope) {
            // Skip leads without company names
            if (String.isBlank(lead.Company)) continue;
            
            // Track best match
            Account bestMatchAccount;
            Double highestScore = 0;
            
            // Compare with existing accounts
            for (String accountName : existingAccounts.keySet()) {
                Double similarity = CompanyNameMatcher.calculateSimilarity(accountName, lead.Company);
                
                // Check for acronym matches
                Boolean isAcronym = CompanyNameMatcher.checkAcronymMatch(accountName, lead.Company) || 
                                    CompanyNameMatcher.checkAcronymMatch(lead.Company, accountName);
                
                // Boost score for acronym matches
                if (isAcronym) {
                    similarity = Math.min(100.0, similarity + 15.0);
                }
                
                // Track highest match
                if (similarity > highestScore) {
                    highestScore = similarity;
                    bestMatchAccount = existingAccounts.get(accountName);
                }
            }
            
            // If score is above threshold, update lead
            if (highestScore >= minimumSimilarityThreshold && bestMatchAccount != null) {
                // Update lead with account information (assuming standard field Company is used)
                lead.Company = bestMatchAccount.Name;
                
                // You might also want to populate standard Account lookup field if available
                // lead.Account__c = bestMatchAccount.Id;
                
                leadsToUpdate.add(lead);
                
                // Track processing for reporting
                processedLeads.put(lead.Id, 'Matched to: ' + bestMatchAccount.Name + ' with score: ' + highestScore);
            } else {
                // Track unmatched leads
                processedLeads.put(lead.Id, 'No match found. Highest score: ' + highestScore);
            }
        }
        
        // Update matched leads
        if (!leadsToUpdate.isEmpty()) {
            try {
                update leadsToUpdate;
            } catch (Exception e) {
                // Log errors
                System.debug('Error updating leads: ' + e.getMessage());
            }
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        // Send email with results
        sendCompletionEmail();
        
        // Optionally schedule next batch
        // System.scheduleBatch(new CompanyNameMatcherBatch(), 'Company Name Matcher - Next Run', 1440); // Schedule next run in 1 day
    }
    
    /**
     * Send completion email with summary of processing
     */
    private void sendCompletionEmail() {
        // Create result statistics
        Integer totalProcessed = processedLeads.size();
        Integer matched = 0;
        
        for (String result : processedLeads.values()) {
            if (result.startsWith('Matched')) {
                matched++;
            }
        }
        
        // Prepare email content
        String body = 'Company Name Matcher Batch Process Summary\n\n';
        body += 'Total Leads Processed: ' + totalProcessed + '\n';
        body += 'Leads Matched: ' + matched + '\n';
        body += 'Leads Unmatched: ' + (totalProcessed - matched) + '\n\n';
        
        // Add detailed results (limit to avoid email size limits)
        body += 'Detailed Results (First 100):\n';
        Integer count = 0;
        
        for (Id leadId : processedLeads.keySet()) {
            if (count++ >= 100) break;
            body += 'Lead ' + leadId + ': ' + processedLeads.get(leadId) + '\n';
        }
        
        // Send email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] { UserInfo.getUserEmail() });
        mail.setSubject('Company Name Matcher Batch Process Complete');
        mail.setPlainTextBody(body);
        
        try {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        } catch (Exception e) {
            System.debug('Error sending email: ' + e.getMessage());
        }
    }
    
    /**
     * Method to execute this batch from developer console or other code
     */
    public static Id runBatch() {
        return Database.executeBatch(new CompanyNameMatcherBatch(), 200);
    }
}