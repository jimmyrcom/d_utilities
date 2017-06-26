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

immutable auto junk =  make!(RedBlackTree!(string, "a > b",false))("picture", "group", "center", "range", "reminders", "thinking", "things","work", "everyone","way", "items", "person", "video", "people", "view" , "getty images", "getty images irrational", "sign", "photo", "page", "0","1","2011","2012","2013","2014","2015","2016","2017","2018","a","able","about","above","abst","accordance","according","accordingly","across","act","actually","added","adj","affected","affecting","affects","after","afterwards","again","against","ah","all","almost","alone","along","already","also","although","always","am","among","amongst","an","and","announce","another","any","anybody","anyhow","anymore","anyone","anything","anyway","anyways","anywhere","apparently","approximately","are","aren","arent","arise","around","as","aside","ask","asking","at","auth","available","away","awfully","b","back","be","became","because","become","becomes","becoming","been","before","beforehand","begin","beginning","beginnings","begins","behind","being","believe","below","beside","besides","between","beyond","biol","both","brief","briefly","but","by","c","ca","came","can","cannot","can't","cause","causes","certain","certainly","co","com","come","comes","contain","containing","contains","could","couldnt","d","date","did","didn't","different","do","does","doesn't","doing","done","don't","down","downwards","due","during","e","each","ed","edu","effect","eg","eight","eighty","either","else","elsewhere","end","ending","enough","especially","et","et-al","etc","even","ever","every","everybody","everyone","everything","everywhere","ex","except","f","far","few","ff","fifth","first","five","fix","followed","following","follows","for","former","formerly","forth","found","four","from","further","furthermore","g","gave","get","gets","getting","give","given","gives","giving","go","goes","gone","got","gotten","h","had","happens","hardly","has","hasn't","have","haven't","having","he","hed","hence","her","here","hereafter","hereby","herein","heres","hereupon","hers","herself","hes","hi","hid","him","himself","his","hither","home","how","however","hundred","i","id","ie","if","i'll","im","immediate","immediately","importance","important","in","inc","indeed","index","information","instead","into","invention","inward","is","isn't","it","itd","it'll","its","itself","i've","j","just","k","kept","kg","km","know","known","knows","l","largely","last","lately","later","latter","latterly","least","less","lest","let","lets","like","liked","likely","line","little","'ll","look","looking","looks","ltd","m","made","mainly","make","makes","many","may","maybe","me","mean","means","meantime","meanwhile","merely","mg","might","million","miss","ml","more","moreover","most","mostly","mr","mrs","much","mug","must","my","myself","n","na","name","namely","nay","nd","near","nearly","necessarily","necessary","need","needs","neither","never","nevertheless","new","next","nine","ninety","no","nobody","non","none","nonetheless","noone","nor","normally","nos","not","noted","nothing","now","nowhere","o","obtain","obtained","obviously","of","off","often","oh","ok","okay","old","omitted","on","once","one","ones","only","onto","or","ord","other","others","otherwise","ought","our","ours","ourselves","out","outside","over","overall","owing","own","p","page","pages","part","particular","particularly","past","per","perhaps","placed","please","plus","poorly","possible","possibly","potentially","pp","predominantly","present","previously","primarily","probably","promptly","proud","provides","put","q","que","quickly","quite","qv","r","ran","rather","rd","re","readily","really","recent","recently","ref","refs","regarding","regardless","regards","related","relatively","research","respectively","resulted","resulting","results","right","run","s","said","same","saw","say","saying","says","sec","section","see","seeing","seem","seemed","seeming","seems","seen","self","selves","sent","seven","several","shall","she","shed","she'll","shes","should","shouldn't","show","showed","shown","showns","shows","significant","significantly","similar","similarly","since","six","slightly","so","some","somebody","somehow","someone","somethan","something","sometime","sometimes","somewhat","somewhere","soon","sorry","specifically","specified","specify","specifying","still","stop","strongly","sub","substantially","successfully","such","sufficiently","suggest","sup","sure\tt","take","taken","taking","tell","tends","th","than","thank","thanks","thanx","that","that'll","thats","that've","the","their","theirs","them","themselves","then","thence","there","thereafter","thereby","thered","therefore","therein","there'll","thereof","therere","theres","thereto","thereupon","there've","these","they","theyd","they'll","theyre","they've","think","this","those","thou","though","thoughh","thousand","throug","through","throughout","thru","thus","til","tip","to","together","too","took","toward","towards","tried","tries","truly","try","trying","ts","twice","two","u","un","under","unfortunately","unless","unlike","unlikely","until","unto","up","upon","ups","us","use","used","useful","usefully","usefulness","uses","using","usually","v","value","various","'ve","very","via","viz","vol","vols","vs","w","want","wants","was","wasnt","way","we","wed","welcome","we'll","went","were","werent","we've","what","whatever","what'll","whats","when","whence","whenever","where","whereafter","whereas","whereby","wherein","wheres","whereupon","wherever","whether","which","while","whim","whither","who","whod","whoever","whole","who'll","whom","whomever","whos","whose","why","widely","willing","wish","with","within","without","wont","words","world","would","wouldnt","www","x","y","yes","yet","you", "people", "percent", "symptoms","youd","you'll","your","youre","yours","yourself","yourselves","you've","z","zero", "eat", "day", "news", "it's", "you're", "they're", "i'm", "coming", "good","case","cases", "doubt", "lot", "lives","order", "feature", "features","type", "thoughts","standards","start","places","house","life","mind","estimates","event","each other","example","feeling","half","amount","types", "question","number","will","lessen","individual","fewer","core","earlier","early","told","response","confirm","confirmed","called","easier","change","meeting","insisted","month","kind","term","time","years","game","season","best","team","year","month","terms conditions","don","three","one","two","goods services","week","sport","ve","free","de","going","uk","conditions privacy","terms conditions privacy","game","services","time","third","en","full","ll","share","good","player","search","big","small","family","night","u0080","best","worst","didn","man","men","women","woman","father","kid","mother","dad","mom","movie","source","000","city","friend","girl","well","high","low","10","tos","shop","top","amp","gt","lt","h3","le","div","href","http","br","collection","post","shared","share","like","comment","â","u0093");


auto ranked_ngrams(string str){
  auto strip_tags = ctRegex!(`</?[A-z]+[^>]*>`);
  string line=replaceAll(str, strip_tags, ` `);
  string[] xs = n_grams(line);
  xs = xs.filter!(a => a.length > 1 && a !in junk && (a~"s") !in junk && (a~"'s") !in junk && (a~"ed") !in junk && (a~"ing") !in junk)
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

pragma(inline):
string[] n_grams(string str){
  auto split_words = ctRegex!(`\b\W+\b`,"i");
  return split(replaceAll(str.toLower(), ctRegex!(`['¿¡!,\+\.\?"\-–\s]+|&[#A-Za-z0-9]{2,6};`),` `).strip(),split_words);
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



