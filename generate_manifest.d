/*
    This file generates a redshift manifest file based on an s3 location.
    Copyright (C) 2017 Jimmy Ruska. Weekend Project. (https://www.linkedin.com/in/jimmyrcom/)
    ldc -O5 -release generate_manifest.d -of /usr/local/bin/generate_manifest  && echo "DATE SIZE s3://abc" | generate_manifest

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


import std.stdio, std.process, std.json, std.array, std.digest.sha, std.digest.digest, std.container.rbtree, std.conv, std.string, std.uri, std.outbuffer, std.container, std.algorithm,std.regex, std.encoding, std.digest.md, std.net.curl, std.datetime, std.math, std.format, std.range, core.stdc.stdlib, std.getopt;
import std.algorithm.iteration : each; import std.parallelism : taskPool; import std.range : iota;

pragma(inline):
JSONValue line_by_line(State state) {
  immutable JSONValue manifest_entry_template = parseJSON(`{"url":"", "mandatory":true}`);
  JSONValue manifest_entry = manifest_entry_template;
  manifest_entry["url"] =  state.line;
  manifest_entry["mandatory"] = state.mandatory;
  return manifest_entry;
}

int main(string[] args){
  JSONValue entries = parseJSON(`{"entries": []}`);
  State.buffer = new OutBuffer();
  State.buffer.reserve(8192);
  bool dbg;
  string less_than, greater_than;
  string[] filter, not_filter, s3, when;

  GetoptResult opts = getopt(args
                             , "mandatory|m", "Redshift import will fail if mandatory file not found.", &State.mandatory
                             , "s3|s", "S3 location", &s3
                             , "filter|f", "Filter for certain text", &filter
                             , "not|n|v", "Filter out certain text", &not_filter
                             , "debug|d", "Verify filters are working", &dbg
                             , "when|w", "Date regex", &when
                             , "less|l", "Filesize Filter in megabytes", &less_than
                             , "greater|g", "Filesize Filter in megabytes", &greater_than
                             );

  if (opts.helpWanted){
        defaultGetoptPrinter("This program allows you to generate manifest files of S3, for upload to redshift.",opts.options);
        exit(0);
  }

  string[] xs = [];
  if (s3 is null) {
    foreach (string line; lines(stdin)) xs~=line;
  }
  else {
    foreach (x; s3){
      xs = xs ~ execute(["aws", "s3", "ls","--recursive", x]).output.strip().split('\n');
    }
  }

  string[][] xs1 = xs.map!(x => split(x, ctRegex!(`[ \t]+`))).array();

  if (when !is null){
    foreach (string x; when){
      auto when_re = regex(x,"i");
      xs1 = xs1.filter!(a => matchFirst(a[0]~" "~a[1], when_re).empty).array();
    }
  }

  if (greater_than !is null){
    ulong greater_than1 = to!ulong(greater_than) * 1024 * 1024;
    xs1 = xs1.filter!(a => to!ulong(a[2]) > greater_than1).array();
  }
  if (less_than !is null){
    ulong less_than1 = to!ulong(less_than) * 1024 * 1024;
    xs1 = xs1.filter!(a => to!ulong(a[2]) < less_than1).array();
  }

  xs = xs1.map!(last_column).array().sort!((a, b) => a < b).uniq().array();


  if (filter !is null){
    foreach (string x; filter){
      auto filter_re = regex(filter,"i");
      xs = xs.filter!(a => !matchFirst(a, filter_re).empty).array();
    }
  }

  if (not_filter !is null){
    foreach (string x; not_filter){
      auto not_filter_re = regex(not_filter,"i");
      xs = xs.filter!(a => matchFirst(a, not_filter_re).empty).array();
    }
  }

  foreach(string record; xs){
    if (record.length == 0) continue;
    entries["entries"].array ~= each_line(new State(record.chomp()));
  }

  State.buffer.writeln(entries.toString());
  return 0;
}

pragma(inline):
JSONValue each_line(State state){
  try {
    return line_by_line(state);
  }
  catch(Exception e){
    stderr.writeln(state.line);
    stderr.writeln(e);
    return parseJSON("{}");
  }
}

class State {
  static OutBuffer buffer;
  static bool mandatory;
  immutable string line;
  this(string str){
    line=str;
  }
}

string last_column(string[] x){
  return "s3://"~x[x.length-1];
}

