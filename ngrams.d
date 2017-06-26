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

immutable auto junk =  make!(RedBlackTree!(string, "a > b",false))("all", "gt", "whoever", "results", "month", "four", "edu", "go", "follow", "causes", "seem", "goods services", "whose", "sure", "itll", "vs", "ts", "0", "those", "th", "under", "sorry", "women", "sent", "woman", "tap", "outside", "far", "mg", "theyve", "every", "awful", "affect", "condition", "obvious", "did", "forth", "companies", "fewer", "standards", "large", "p", "team", "quick", "havent", "thereupon", "tru", "noted", "the", "googleplus", "says", "core", "yourself", "estimates", "sign", "past", "zero", "invention", "video", "further", "click", "even", "index", "what", "sub", "giving", "section", "http", "brief", "whatll", "en", "above", "sup", "new", "ever", "told", "full", "youd", "never", "here", "let", "others", "alone", "along", "strong", "thatve", "obtain", "search", "ref", "items", "k", "wherever", "credit", "amount", "arent", "whereupon", "makes", "thats", "kid", "hither", "via", "follow", "br", "family", "father", "h3", "while", "put", "ninety", "vols", "viz", "reserved", "ord", "readily", "everybody", "use", "from", "would", "to", "until", "contains", "two", "next", "few", "doubt", "therefore", "taken", "themselves", "thru", "type", "refs", "more", "knows", "successful", "becomes", "company", "hereby", "herein", "everywhere", "particular", "known", "ok", "cases", "must", "me", "none", "f", "this", "ml", "work", "anywhere", "nine", "can", "mr", "meet", "didnt", "example", "prompt", "give", "desktop", "share", "high", "weve", "something", "want", "arise", "story", "information", "needs", "end", "rather", "means", "whence", "1", "how", "instead", "especial", "shouldnt", "okay", "tried", "may", "stop", "after", "eighty", "respective", "collection", "hereupon", "features", "ff", "coming", "date", "such", "data", "response", "types", "man", "a", "third", "whenever", "maybe", "q", "ones", "so", "worst", "order", "six", "indeed", "itd", "soon", "feature", "u0080", "isnt", "through", "looks", "yourselves", "still", "its", "before", "le", "group", "thank", "thence", "selves", "inward", "fix", "late", "lt", "2018", "thanx", "symptoms", "2015", "2014", "2017", "2016", "2011", "easier", "2013", "2012", "dad", "then", "non", "someone", "affect", "thereby", "cover", "auth", "band", "they", "half", "not", "now", "day", "nor", "nos", "wont", "term", "several", "hereafter", "anyth", "always", "didn", "whither", "l", "good", "each", "found", "went", "out", "mean", "everyone", "thereve", "ed", "eg", "hard", "related", "owing", "ex", "year", "et", "girl", "beyond", "event", "getty images irrational", "album", "try", "shown", "furthermore", "since", "research", "rd", "re", "got", "cause", "shows", "earlier", "million", "given", "free", "quite", "small", "que", "besides", "ask", "enlarge", "anyhow", "beginning", "div", "insist", "your", "prepare", "g", "terms conditions", "could", "tries", "ups", "w", "ltd", "hence", "onto", "think", "first", "already", "dont", "feel", "omitted", "thereafter", "number", "thereof", "one", "done", "specifically", "another", "miss", "city", "little", "necessarily", "tos", "top", "least", "name", "anyone", "their", "too", "hundred", "friend", "gives", "getty images", "shell", "lot", "behind", "season", "nobody", "took", "immediate", "part", "somewhat", "off", "believe", "herself", "than", "specify", "whereby", "wide", "kind", "b", "show", "accordance", "gotten", "whom", "youve", "i", "r", "were", "toward", "are", "and", "youre", "ran", "thoughh", "beforehand", "say", "substantial", "have", "need", "my", "seem", "saw", "any", "these", "issue", "latter", "that", "downwards", "aside", "also", "potential", "take", "which", "begin", "add", "unless", "normal", "who", "most", "eight", "but", "significant", "nothing", "pages", "kg", "noone", "later", "m", "km", "mrs", "heres", "regards", "came", "shop", "show", "able", "anyway", "watch", "fifth", "original", "enough", "should", "only", "announce", "over", "do", "his", "goes", "get", "de", "overall", "cannot", "hid", "words", "werent", "during", "years", "him", "well", "qv", "h", "email", "twice", "she", "though", "contain", "x", "where", "view", "theirs", "we", "relative", "see", "individual", "sec", "anyways", "each other", "throug", "best", "said", "away", "please", "mug", "various", "between", "probably", "neither", "youll", "across", "available", "accord", "men", "useful", "importance", "however", "news", "\xc3\xa2", "come", "both", "c", "last", "thou", "many", "ill", "whereafter", "against", "etc", "s", "became", "wholl", "expand", "com", "ll", "comes", "otherwise", "comment", "among", "liked", "co", "afterwards", "appear", "seems", "ca", "whatever", "hers", "confirm", "article", "moreover", "throughout", "meantime", "pp", "power", "due", "been", "whos", "wasnt", "much", "change", "ah", "whod", "wants", "life", "mind", "sufficient", "else", "lives", "ours", "former", "present", "case", "myself", "main", "look", "unlike", "thered", "might", "tip", "lessen", "thereto", "value", "n", "will", "near", "taking", "theres", "ive", "seven", "thatll", "almost", "is", "thus", "it", "player", "cant", "itself", "im", "in", "somebody", "ie", "id", "if", "result", "different", "anymore", "perhaps", "suggest", "make", "same", "wherein", "beside", "writer", "when", "unfortunate", "reminder", "gets", "week", "used", "y", "somewhere", "upon", "effect", "000", "uses", "therell", "yours", "wheres", "recent", "kept", "center", "nevertheless", "whole", "nonetheless", "ths", "anybody", "person", "without", "mother", "very", "meanwhile", "self", "usual", "lest", "just", "less", "being", "photo", "therere", "obtain", "seen", "thanks", "world", "regardless", "yes", "u0093", "yet", "unto", "previous", "tablet", "wed", "percent", "had", "except", "sometimes", "source", "lets", "thoughts", "has", "adj", "ought", "gave", "real", "around", "conditions privacy", "big", "possible", "early", "possibly", "game", "five", "know", "mom", "using", "like", "abst", "necessary", "d", "follows", "zoom", "theyre", "href", "either", "night", "become", "page", "therein", "showns", "shed", "because", "old", "often", "people", "ve", "twitter", "some", "back", "oh", "towards", "shes", "specified", "home", "ourselves", "happens", "vol", "for", "confirm", "affects", "shall", "per", "everything", "does", "provides", "tends", "be", "run", "business", "slight", "nowhere", "although", "post", "by", "on", "about", "actual", "wouldnt", "getting", "of", "v", "o", "whomever", "range", "plus", "act", "shared", "or", "own", "whats", "somethan", "into", "within", "www", "three", "down", "services", "doesnt", "primarily", "theyd", "couldnt", "mere", "her", "hes", "aren", "there", "question", "approximate", "biol", "why", "hed", "start", "low", "way", "house", "result", "was", "mpu", "himself", "elsewhere", "becoming", "regard", "amongst", "somehow", "hi", "getty", "et-al", "don", "line", "with", "eat", "he", "usefulness", "made", "places", "whether", "wish", "j", "up", "us", "tell", "placed", "below", "un", "whim", "uk", "z", "similar", "call", "gone", "proud", "certain", "am", "an", "as", "sometime", "right", "at", "our", "inc", "facebook", "again", "hasnt", "theyll", "no", "na", "whereas", "nd", "til", "other", "you", "nay", "predominant", "thousand", "10", "poor", "picture", "apparent", "welcome", "important", "terms conditions privacy", "song", "e", "amp", "youtube", "together", "them", "u", "image", "time", "having", "once");


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
  if (replace(x,ctRegex!(`s$`), "") in junk) return true;
  if (replace(x,ctRegex!(`ly$`), "") in junk) return true;
  if (replace(x,ctRegex!(`n?ing$`), "") in junk) return true;
  if (replace(x,ctRegex!(`ed$`), "") in junk) return true;
  if (replace(x,ctRegex!(`d$`), "") in junk) return true;
  if (replace(x,ctRegex!(`e$`), "ing") in junk) return true;
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



