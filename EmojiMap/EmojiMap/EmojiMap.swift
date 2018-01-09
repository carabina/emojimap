//
//  EmojiMap.swift
//  EmojiMap
//
//  Created by Matias Villaverde on 17.11.17.
//
//

import Foundation

// Mapping of the regular text to emoji characters
public typealias WordToEmojiMapping = [String : [String]]

/// `Match` class keeps information about a single word that can be replaced with an emoji.
public struct Match {
    
    let string: String
    let emoji: String
    
    init(string: String, emoji: String) {
        self.string = string
        self.emoji = emoji
    }
}


/// Tool to get the possible match from a word to an emoji.
public class EmojiMap {
    
    /// Database of emojis in the user language
    lazy var mapping = self.defaultTextToEmojiMapping()
    
    /// Get the match of all the emojis that can represent words of the input string
    ///
    /// - Parameter inputString: String in EN, DE, FR or ES
    /// - Returns: array of Matches that contains the emoji and the word
    func getMatchesFor(_ inputString: String) -> [Match] {
        
        // Output array
        var outPut = [Match]()
        
        // Language
        let fullLanguage = Locale.preferredLanguages[0]
        
        // Tagger using NSLinguisticTagger
        let options = NSLinguisticTagger.Options.omitWhitespace.rawValue | NSLinguisticTagger.Options.joinNames.rawValue
        let tagger = NSLinguisticTagger(tagSchemes: NSLinguisticTagger.availableTagSchemes(forLanguage: fullLanguage), options: Int(options))
        tagger.string = inputString
        
        // Enumerate the string to get the words
        let range = NSRange(location: 0, length: inputString.utf16.count)
        
        tagger.enumerateTags(in: range, scheme: .nameTypeOrLexicalClass, options: NSLinguisticTagger.Options(rawValue: options)) { tag, tokenRange, sentenceRange, stop in
            
            // Get Token
            guard let range = Range(tokenRange, in: inputString) else { return }
            let token = inputString[range]
            
            // Get match searching on emoji db
            if let mappeds = mapping[(token as NSString).lowercased] {
                for mapped in mappeds {
                    let match = Match(string: token as NSString as String, emoji: mapped as String)
                    outPut.append(match)
                }
            }
            
        }
        
        // Return output
        return outPut
    }
    
    /// Search for the emoji db in the current language of the user. Currently supported only EN, DE, FR and ES
    ///
    /// - Returns: Mapping of the regular text to emoji characters
    public func defaultTextToEmojiMapping() -> WordToEmojiMapping {
        
        var mapping: WordToEmojiMapping = [:]
        
        func addKey(_ key: String, value: String, atBeginning: Bool) {
            
            if mapping[key] == nil {
                mapping[key] = []
            }
            
            if atBeginning {
                mapping[key]?.insert(value, at: 0)
            } else {
                mapping[key]?.append(value)
            }
        }
        
        // Language
        let fullLanguage = Locale.preferredLanguages[0]
        var pre = String(fullLanguage.prefix(2))
        pre = "-" + pre
        
        // Search for file
        guard let file = Bundle.main.url(forResource: "emojis" + pre, withExtension: "json"),
            let data = try? Data(contentsOf: file),
            let json = try? JSONSerialization.jsonObject(with: data, options: []),
            let jsonDictionary = json as? NSDictionary else {
                print("Error finding the emoji for the language \(pre)")
                return [:]
        }
        
        // Order the json in a dictionary
        for (key, value) in jsonDictionary {
            if let key = key as? String,
                let dictionary = value as? Dictionary<String, AnyObject>,
                let emojiCharacter = dictionary["char"] as? String {
                
                // Dictionary keys from emojis.json have higher priority then keywords.
                // That's why they're added at the beginning of the array.
                addKey(key, value: emojiCharacter, atBeginning: true)
                
                // Keywords have a lower priority than dictionary keys, are added at the end.
                if let keywords = dictionary["keywords"] as? [String] {
                    for keyword in keywords {
                        addKey(keyword.lowercased(), value: emojiCharacter, atBeginning: false)
                    }
                }
            }
        }
        
        return mapping
    }
}
