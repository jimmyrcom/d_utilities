/*
    Use ranked_ngrams function to generate ngrams for words.
    Copyright (C) 2017 Jimmy Ruska. Weekend Project. (https://www.linkedin.com/in/jimmyrcom/)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
 
module ngrams;
import std.stdio, std.process, std.json, std.array, std.digest.sha, std.digest.digest, std.container.rbtree, std.conv, std.string, std.uri, std.outbuffer, std.container, std.algorithm,std.regex, std.encoding, std.digest.md, std.net.curl, std.datetime, std.math, std.format, std.range, core.stdc.stdlib;
import std.algorithm.iteration : each; import std.parallelism : taskPool; import std.range : iota;

immutable auto junk =  make!(RedBlackTree!(string, "a > b",false))("all", "gt", "whoever", "month", "four", "edu", "go", "follow", "whose", "itll", "father", "ts", "0", "present", "th", "under", "sorry", "women", "mug", "sent", "woman", "song", "far", "mg", "mpu", "every", "u0080", "u0099", "yourselves", "little", "condition", "did", "ref", "companies", "fewer", "large", "p", "team", "quick", "havent", "tru", "noted", "ourselve", "be", "sign", "past", "zero", "invention", "video", "further", "click", "even", "index", "what", "sub", "giving", "section", "brief", "whatll", "above", "sup", "new", "ever", "told", "afterward", "full", "never", "here", "let", "alone", "along", "standard", "thatve", "search", "my", "k", "wherever", "proud", "credit", "amount", "arent", "within", "que", "hither", "via", "useful", "although", "family", "put", "ninety", "vols", "viz", "reserved", "estimate", "readily", "everybody", "use", "from", "would", "to", "two", "next", "few", "live", "doubt", "call", "therefore", "taken", "thru", "type", "until", "more", "main", "on", "successful", "company", "hereby", "herein", "everywhere", "particular", "known", "actual", "must", "me", "none", "word", "f", "this", "ml", "work", "anywhere", "nine", "can", "mr", "meet", "didnt", "example", "prompt", "give", "share", "near", "high", "his", "something", "want", "arise", "information", "respective", "end", "rather", "six", "enlarge", "1", "alway", "instead", "especial", "shouldnt", "okay", "tried", "may", "watch", "earlier", "eighty", "them", "collection", "tries", "ff", "coming", "date", "such", "data", "response", "man", "a", "thered", "third", "whenever", "maybe", "q", "provide", "so", "worst", "order", "indeed", "itd", "soon", "feature", "awful", "isnt", "through", "affect", "still", "before", "le", "group", "thank", "thence", "selves", "inward", "fix", "late", "lt", "2018", "thanx", "somethan", "2015", "2014", "2017", "2016", "2011", "easier", "2013", "2012", "dad", "then", "non", "someone", "somebody", "thereby", "auth", "band", "they", "half", "not", "yourself", "day", "nor", "nos", "wont", "term", "mere", "hereafter", "anyth", "didn", "whither", "l", "doesnt", "each", "found", "went", "mean", "en", "primarily", "ed", "eg", "hard", "related", "owing", "ex", "year", "et", "girl", "beyond", "event", "out", "album", "try", "shown", "item", "furthermore", "since", "research", "rd", "re", "got", "forth", "thereupon", "after", "million", "given", "free", "quite", "small", "whereupon", "ask", "anyhow", "beginning", "div", "her", "g", "could", "hereupon", "place", "w", "ltd", "hence", "onto", "think", "first", "already", "dont", "feel", "omitted", "thereafter", "number", "thereof", "one", "done", "biol", "another", "miss", "city", "story", "necessarily", "service", "tos", "top", "least", "anyone", "their", "too", "hundred", "friend", "shell", "way", "that", "season", "nobody", "took", "immediate", "part", "somewhat", "kept", "believe", "herself", "than", "symptom", "center", "wide", "kind", "b", "accordance", "gotten", "nevertheless", "r", "were", "toward", "are", "and", "ran", "well", "beforehand", "anybody", "say", "substantial", "have", "need", "seen", "seem", "saw", "any", "terms condition", "issue", "latter", "able", "aside", "also", "potential", "take", "which", "begin", "sure", "unless", "normal", "who", "most", "eight", "amongst", "significant", "nothing", "why", "appear", "cause", "kg", "noone", "later", "cover", "km", "mrs", "came", "shop", "show", "anyway", "range", "fifth", "business", "writer", "behind", "should", "only", "specify", "photo", "announce", "over", "do", "weve", "goes", "get", "de", "stop", "act", "cannot", "hid", "werent", "during", "him", "is", "qv", "h", "across", "twice", "she", "contain", "x", "where", "view", "accord", "relative", "see", "individual", "sec", "result", "each other", "close", "best", "said", "away", "please", "tend", "outside", "various", "between", "probably", "neither", "youll", "email", "available", "we", "men", "importance", "however", "by", "nd", "no", "recent", "article", "come", "both", "c", "last", "wasnt", "thou", "many", "ill", "whereafter", "against", "etc", "s", "became", "wholl", "com", "ll", "otherwise", "comment", "among", "liked", "co", "very", "themselve", "ca", "insist", "moreover", "throughout", "meantime", "pp", "strong", "due", "been", "whom", "much", "change", "ah", "whod", "life", "mind", "tap", "else", "whatever", "former", "those", "case", "myself", "theyve", "look", "unlike", "these", "might", "googleplus", "lessen", "thereto", "value", "n", "will", "while", "shall", "taking", "ive", "seven", "thatll", "almost", "refs", "thus", "it", "player", "cant", "good", "im", "in", "ie", "id", "if", "different", "anymore", "perhaps", "suggest", "make", "same", "wherein", "beside", "unfortunate", "reminder", "several", "week", "used", "http", "somewhere", "upon", "effect", "000", "therell", "expand", "kid", "off", "whereby", "i", "whole", "youre", "thoughh", "\xc3\xa2", "thought", "person", "without", "mother", "y", "the", "self", "usual", "lest", "just", "less", "being", "when", "therere", "obtain", "using", "regardless", "yes", "u0093", "yet", "unto", "previous", "now", "tablet", "wed", "percent", "had", "except", "desktop", "thousand", "source", "add", "tell", "has", "adj", "ought", "gave", "real", "around", "conditions privacy", "big", "possible", "early", "possibly", "game", "five", "know", "mom", "world", "name", "abst", "nay", "necessary", "like", "obvious", "zoom", "theyre", "href", "either", "night", "become", "downward", "page", "therein", "shed", "because", "old", "often", "people", "ve", "twitter", "some", "back", "certain", "specified", "home", "vol", "vs", "for", "confirm", "though", "per", "everything", "does", "three", "good,", "core", "run", "power", "slight", "overall", "how", "nowhere", "br", "post", "ths", "getty image", "about", "ok", "wouldnt", "oh", "of", "v", "o", "whomever", "whence", "plus", "youve", "shared", "or", "own", "h3", "into", "youd", "www", "getting", "down", "d", "everyone", "thereve", "theyd", "couldnt", "your", "prepare", "aren", "there", "question", "approximate", "specifically", "hed", "start", "low", "lot", "house", "was", "himself", "elsewhere", "enough", "becoming", "regard", "but", "somehow", "hi", "getty", "et-al", "don", "line", "with", "eat", "he", "usefulness", "made", "whether", "wish", "j", "up", "us", "throug", "placed", "below", "un", "whim", "uk", "z", "similar", "gone", "sometimes", "m", "am", "an", "meanwhile", "as", "sometime", "right", "at", "our", "happen", "inc", "facebook", "again", "hasnt", "theyll", "nonetheless", "na", "whereas", "tip", "til", "other", "you", "getty images irrational", "predominant", "sufficient", "10", "poor", "picture", "apparent", "welcome", "important", "terms conditions privacy", "e", "amp", "ord", "youtube", "together", "having", "itself", "u", "image", "time", "original", "once");


auto ranked_ngrams(string str){
  auto strip_tags = ctRegex!(`</?[A-z]+[^>]*>`);
  string line=replaceAll(str, strip_tags, ` `);
  string[] xs = n_grams(line);
  xs = xs.filter!(a => a.length > 1 && !check_if_junk(a))
    .array();
  string[] ndoubles = doubles(xs);
  string[] triples = triples(xs);
  auto xs1 = xs.sort().group.filter!(a => a[1] > 1).array().sort!((a, b) => a[1] > b[1]).array();
  float avg = reduce!((a, b) => a + b[1])(0, xs1) / (xs1.length+0.0001);
  float filter_doubles = max(avg * 0.4, 1.0);
  float filter_triples = max(avg * 0.25, 1.0);
  auto ndoubles1 = ndoubles.sort().group.filter!(a => a[1] > filter_doubles).array().sort!((a, b) => a[1] > b[1]).array();
  auto ntriples1 = triples.sort().group.filter!(a => a[1] > filter_doubles).array().sort!((a, b) => a[1] > b[1]).array();
  xs1 = xs1.filter!(a => a[1] > avg).array();
  auto ngrams = (xs1 ~ ndoubles1 ~ ntriples1).sort!((a, b) => a[1] > b[1]).array();
  return ngrams;
}

bool check_if_junk(ref string x){
  if (replace(x,ctRegex!(`s$`), "") in junk) return true;    // right -> rights
  if (replace(x,ctRegex!(`ly$`), "") in junk) return true;   // slight -> slightly
  if (replace(x,ctRegex!(`n?ing$`), "") in junk) return true;// begin -> beginning
  if (replace(x,ctRegex!(`n?er$`), "") in junk) return true; // run -> runner
  if (replace(x,ctRegex!(`ed$`), "") in junk) return true;   // deliver -> delivered
  if (replace(x,ctRegex!(`d$`), "") in junk) return true;    // shared -> share
  if (replace(x,ctRegex!(`e$`), "ing") in junk) return true; // share -> sharing
  if (replace(x,ctRegex!(`y$`), "ies") in junk) return true; // company -> companies
  if (x~"ning" in junk) return true;
  if (x~"ing" in junk) return true;
  if (x~"d" in junk) return true;
  return false;
}

pragma(inline):
string[] n_grams(string str){
  auto split_words = ctRegex!(`\b\W+\b`,"i");
  return split(replaceAll(str.toLower(), ctRegex!(`['_¿¡!,\+\.\?"\-–\s]+|&[#A-Za-z0-9]{2,6};`),` `).strip(),split_words);
}

string[] doubles(string[] strs){
  if (strs.length < 2) return [];
  string[] ndoubles = [];
  for (int i; i < strs.length-1; i++){
    if (strs[i+1] != strs[i]) ndoubles ~= strs[i] ~ ' ' ~ strs[i+1];
  }
  return ndoubles;
}

string[] triples(string[] strs){
  if (strs.length < 3) return [];
  string[] ntriples = [];
  for (int i; i < strs.length-2; i++){
    if (strs[i+1] != strs[i] && strs[i+1] != strs[i+2]) ntriples ~= strs[i] ~ ' ' ~ strs[i+1] ~ ' ' ~ strs[i+2];
  }
  return ntriples;
}



