/**
 * CompanyNameMatcher
 * 
 * This class provides methods to compare company names and determine similarity scores
 * using multiple algorithms for a comprehensive matching approach.
 */
public class CompanyNameMatcher {
    
    // Configurable weights for different algorithms
    private static final Double LEVENSHTEIN_WEIGHT = 0.30;
    private static final Double JARO_WINKLER_WEIGHT = 0.40;
    private static final Double TOKEN_MATCH_WEIGHT = 0.30;
    
    /**
     * Main method to determine similarity between two company names
     * @param actualCompanyName The standard/correct company name
     * @param leadCompanyName The company name entered in the lead
     * @return Double Percentage probability (0-100) of match
     */
    public static Double calculateSimilarity(String actualCompanyName, String leadCompanyName) {
        // Guard clause for null inputs
        if (String.isBlank(actualCompanyName) || String.isBlank(leadCompanyName)) {
            return 0.0;
        }
        
        // Normalize both strings (lowercase, remove unnecessary characters)
        String normalizedActual = normalizeCompanyName(actualCompanyName);
        String normalizedLead = normalizeCompanyName(leadCompanyName);
        
        // Exact match after normalization
        if (normalizedActual == normalizedLead) {
            return 100.0;
        }
        
        // Calculate individual scores
        Double levenshteinScore = calculateLevenshteinSimilarity(normalizedActual, normalizedLead);
        Double jaroWinklerScore = calculateJaroWinklerSimilarity(normalizedActual, normalizedLead);
        Double tokenScore = calculateTokenSimilarity(normalizedActual, normalizedLead);
        
        // Weighted average of all scores
        Double weightedScore = (levenshteinScore * LEVENSHTEIN_WEIGHT) + 
                              (jaroWinklerScore * JARO_WINKLER_WEIGHT) + 
                              (tokenScore * TOKEN_MATCH_WEIGHT);
        
        // Round to 2 decimal places
        return Math.round(weightedScore * 100.0) / 100.0;
    }
    
    /**
     * Normalize company name by removing common tokens, punctuation, and converting to lowercase
     */
    private static String normalizeCompanyName(String companyName) {
        if (String.isBlank(companyName)) return '';
        
        String result = companyName.toLowerCase()
            // Remove common legal entity identifiers
            .replaceAll('\\b(inc\\.?|incorporated|corp\\.?|corporation|pvt|llc|ltd\\.?|limited|gmbh|co\\.?|company|& co\\.?)\\b', '')
            // Remove punctuation and special characters
            .replaceAll('[\\.,\\-_\\(\\)\\[\\]\\{\\}]', ' ')
            // Normalize whitespace
            .replaceAll('\\s+', ' ')
            .trim();
            
        System.debug('Normalized Company Name: ' + result);
        return result;
    }
    
    /**
     * Calculate Levenshtein distance and convert to similarity score
     */
    private static Double calculateLevenshteinSimilarity(String s1, String s2) {
        // Guard clause for empty strings
        if (String.isBlank(s1) && String.isBlank(s2)) return 100.0;
        if (String.isBlank(s1) || String.isBlank(s2)) return 0.0;
        
        Integer distance = levenshteinDistance(s1, s2);
        Integer maxLength = Math.max(s1.length(), s2.length());
        
        if (maxLength == 0) return 100.0;
        
        // Convert distance to similarity score (0-100)
        Double similarity = 100.0 * (1.0 - ((Double)distance / maxLength));
        System.debug('Levenshtein Similarity: ' + similarity);
        return Math.max(0, similarity); // Ensure non-negative
    }
    
    /**
     * Implementation of Levenshtein distance calculation
     */
    private static Integer levenshteinDistance(String s1, String s2) {
        Integer m = s1.length();
        Integer n = s2.length();
        
        // Initialize matrix of size (m+1) x (n+1)
        List<List<Integer>> dp = new List<List<Integer>>();
        
        for (Integer i = 0; i <= m; i++) {
            List<Integer> row = new List<Integer>();
            for (Integer j = 0; j <= n; j++) {
                row.add(0);
            }
            dp.add(row);
        }
        
        // Fill first row and column
        for (Integer i = 0; i <= m; i++) {
            dp[i][0] = i;
        }
        
        for (Integer j = 0; j <= n; j++) {
            dp[0][j] = j;
        }
        
        // Fill the matrix
        for (Integer i = 1; i <= m; i++) {
            for (Integer j = 1; j <= n; j++) {
                Integer cost = (s1.substring(i-1, i) == s2.substring(j-1, j)) ? 0 : 1;
                dp[i][j] = Math.min(
                    Math.min(dp[i-1][j] + 1, dp[i][j-1] + 1),
                    dp[i-1][j-1] + cost
                );
            }
        }
        
        return dp[m][n];
    }
    
    /**
     * Calculate Jaro-Winkler similarity
     */
    private static Double calculateJaroWinklerSimilarity(String s1, String s2) {
        // Guard clause for empty strings
        if (String.isBlank(s1) && String.isBlank(s2)) return 100.0;
        if (String.isBlank(s1) || String.isBlank(s2)) return 0.0;
        
        // Base Jaro Distance
        Double jaroDistance = calculateJaroDistance(s1, s2);
        
        // Calculate prefix scale
        Integer prefixLength = 0;
        Integer maxPrefixLength = 4;  // Standard for Jaro-Winkler
        
        // Count matching prefix characters (up to 4)
        for (Integer i = 0; i < Math.min(s1.length(), s2.length()); i++) {
            if (s1.substring(i, i+1) == s2.substring(i, i+1)) {
                prefixLength++;
                if (prefixLength >= maxPrefixLength) break;
            } else {
                break;
            }
        }
        
        // Scaling factor for how much the score is adjusted for having common prefixes
        Double scalingFactor = 0.1;
        
        // Jaro-Winkler distance
        Double jaroWinklerDistance = jaroDistance + (prefixLength * scalingFactor * (1.0 - jaroDistance));
        System.debug('Jaro-Winkler Similarity: ' + jaroWinklerDistance);
        // Convert to percentage
        return jaroWinklerDistance * 100.0;
    }
    
    /**
     * Helper method to calculate basic Jaro distance
     */
    private static Double calculateJaroDistance(String s1, String s2) {
        // If both strings are empty, return 1.0
        if (s1.length() == 0 && s2.length() == 0) return 1.0;
        
        // If either string is empty, return 0.0
        if (s1.length() == 0 || s2.length() == 0) return 0.0;
        
        // Maximum distance for matching characters
        Integer matchDistance = (Math.max(s1.length(), s2.length()) / 2) - 1;
        matchDistance = Math.max(0, matchDistance);
        
        // Arrays to track matched characters
        Boolean[] s1Matches = new Boolean[s1.length()];
        Boolean[] s2Matches = new Boolean[s2.length()];
        
        for (Integer i = 0; i < s1.length(); i++) {
            s1Matches[i] = false;
        }
        
        for (Integer i = 0; i < s2.length(); i++) {
            s2Matches[i] = false;
        }
        
        // Count matching characters within the match distance
        Integer matchingChars = 0;
        for (Integer i = 0; i < s1.length(); i++) {
            Integer start = Math.max(0, i - matchDistance);
            Integer last = Math.min(i + matchDistance + 1, s2.length());
            
            for (Integer j = start; j < last; j++) {
                if (!s2Matches[j] && s1.substring(i, i+1) == s2.substring(j, j+1)) {
                    s1Matches[i] = true;
                    s2Matches[j] = true;
                    matchingChars++;
                    break;
                }
            }
        }
        
        // If no characters match, return 0.0
        if (matchingChars == 0) return 0.0;
        
        // Count transpositions
        Integer transpositions = 0;
        Integer k = 0;
        
        for (Integer i = 0; i < s1.length(); i++) {
            if (s1Matches[i]) {
                while (!s2Matches[k]) {
                    k++;
                }
                
                if (s1.substring(i, i+1) != s2.substring(k, k+1)) {
                    transpositions++;
                }
                
                k++;
            }
        }
        
        // Integer division by 2
        transpositions = transpositions / 2;
        
        // Calculate Jaro distance
        Double jaro = (
            (matchingChars / (Double)s1.length()) +
            (matchingChars / (Double)s2.length()) +
            ((matchingChars - transpositions) / (Double)matchingChars)
        ) / 3.0;
        
        return jaro;
    }
    
    /**
     * Calculate token-based similarity by comparing words
     */
    private static Double calculateTokenSimilarity(String s1, String s2) {
        // Guard clause for empty strings
        if (String.isBlank(s1) && String.isBlank(s2)) return 100.0;
        if (String.isBlank(s1) || String.isBlank(s2)) return 0.0;
        
        // Split strings into tokens (words)
        List<String> tokens1 = s1.split('\\s+');
        List<String> tokens2 = s2.split('\\s+');
        
        // Create sets for easy comparison
        Set<String> set1 = new Set<String>(tokens1);
        Set<String> set2 = new Set<String>(tokens2);
        
        // Intersection size (common tokens)
        Integer intersectionSize = 0;
        for (String token : set1) {
            if (set2.contains(token)) {
                intersectionSize++;
            }
        }
        
        // Union size (all unique tokens)
        Integer unionSize = set1.size() + set2.size() - intersectionSize;
        
        // Jaccard similarity coefficient
        Double similarity = (unionSize == 0) ? 0.0 : (Double)intersectionSize / unionSize;
        System.debug('Token Similarity: ' + similarity);
        // Convert to percentage
        return similarity * 100.0;
    }
    
    /**
     * Additional utility method for handling company names with acronyms
     * Checks if one name might be an acronym of the other
     * @return Boolean indicating if there's an acronym match
     */
    public static Boolean checkAcronymMatch(String fullName, String possibleAcronym) {
        if (String.isBlank(fullName) || String.isBlank(possibleAcronym)) {
            return false;
        }
        
        // Normalize and split into words
        List<String> words = fullName.toLowerCase().split('\\s+');
        String acronym = possibleAcronym.toLowerCase().replaceAll('[^a-z0-9]', '');
        
        // If acronym is too long, it's likely not an acronym of the full name
        if (acronym.length() > words.size() * 2) {
            return false;
        }
        
        // Try to build an acronym from the full name
        String builtAcronym = '';
        for (String word : words) {
            if (!String.isBlank(word) && word.length() > 0) {
                builtAcronym += word.substring(0, 1);
            }
        }
        
        // Check if our built acronym matches the possible acronym
        return builtAcronym.equals(acronym);
    }
}