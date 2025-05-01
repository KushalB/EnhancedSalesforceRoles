/**
 * Test class for CompanyNameMatcher
 */
@isTest
private class CompanyNameMatcherTest {
    
    @isTest
    static void testExactMatch() {
        // Test exact matches
        System.assertEquals(100.0, CompanyNameMatcher.calculateSimilarity('Acme Corp', 'Acme Corp'));
        System.assertEquals(100.0, CompanyNameMatcher.calculateSimilarity('ACME CORP', 'acme corp'));
    }
    
    @isTest
    static void testNormalizedMatch() {
        // Test matches after normalization
        System.assertEquals(100.0, CompanyNameMatcher.calculateSimilarity('Acme Corporation', 'Acme Corp'));
        System.assertEquals(100.0, CompanyNameMatcher.calculateSimilarity('Acme, Inc.', 'Acme'));
        System.assertEquals(100.0, CompanyNameMatcher.calculateSimilarity('ACME Inc.', 'acme incorporated'));
    }
    
    @isTest
    static void testSimilarNames() {
        // Test similar company names with expected high scores
        Double score1 = CompanyNameMatcher.calculateSimilarity('Microsoft Corporation', 'Microsoft Corp');
        System.assert(score1 > 90.0, 'Score should be high for similar names');
        
        Double score2 = CompanyNameMatcher.calculateSimilarity('Apple Inc.', 'Apple Incorporated');
        System.assert(score2 > 90.0, 'Score should be high for similar names');
    }
    
    @isTest
    static void testTypos() {
        // Test names with typos
        Double score1 = CompanyNameMatcher.calculateSimilarity('Google LLC', 'Gooogle LLC');
        System.assert(score1 > 80.0, 'Score should be reasonably high for names with small typos');
        
        Double score2 = CompanyNameMatcher.calculateSimilarity('Facebook', 'Faceboo');
        System.assert(score2 > 80.0, 'Score should be reasonably high for names with small typos');
    }
    
    @isTest
    static void testDifferentNames() {
        // Test completely different names
        Double score = CompanyNameMatcher.calculateSimilarity('Microsoft', 'Google');
        System.assert(score < 50.0, 'Score should be low for different names');
    }
    
    @isTest
    static void testNullInputs() {
        // Test null inputs
        System.assertEquals(0.0, CompanyNameMatcher.calculateSimilarity(null, 'Any Company'));
        System.assertEquals(0.0, CompanyNameMatcher.calculateSimilarity('Any Company', null));
        System.assertEquals(0.0, CompanyNameMatcher.calculateSimilarity(null, null));
    }
    
    @isTest
    static void testAcronymMatch() {
        // Test acronym matching
        System.assert(CompanyNameMatcher.checkAcronymMatch('International Business Machines', 'IBM'));
        System.assert(CompanyNameMatcher.checkAcronymMatch('Hewlett Packard Enterprise', 'HPE'));
        System.assert(!CompanyNameMatcher.checkAcronymMatch('Microsoft', 'MSFT'));
    }
    
    @isTest
    static void testEdgeCases() {
        // Edge cases
        System.assertEquals(100.0, CompanyNameMatcher.calculateSimilarity('', ''));
        
        Double score1 = CompanyNameMatcher.calculateSimilarity('A', 'B');
        System.assert(score1 < 50.0, 'Single different letters should have low similarity');
        
        Double score2 = CompanyNameMatcher.calculateSimilarity('Very Very Long Company Name That Nobody Would Enter Fully', 'Very Long Co');
        System.assert(score2 < 70.0, 'Partial but significant difference should have moderate similarity');
    }
    
    @isTest
    static void testRealWorldExamples() {
        // Test with real-world examples
        Map<String, String> testCases = new Map<String, String>{
            'General Electric' => 'GE',
            'Johnson & Johnson' => 'Johnson and Johnson',
            'Procter & Gamble' => 'P&G',
            'AT&T' => 'American Telephone & Telegraph',
            'BMW' => 'Bayerische Motoren Werke',
            'Coca-Cola Company' => 'Coke',
            'McDonald\'s Corporation' => 'McDonalds'
        };
        
        for (String actualName : testCases.keySet()) {
            String leadName = testCases.get(actualName);
            Double score = CompanyNameMatcher.calculateSimilarity(actualName, leadName);
            // Print scores for real-world examples
            System.debug('Similarity between "' + actualName + '" and "' + leadName + '": ' + score);
        }
    }
}