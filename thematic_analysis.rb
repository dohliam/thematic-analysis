#!/usr/bin/ruby

# Thematic analysis data parser
#
# Usage:
# - add (optional) source data files to the data directory
# - add list of tagged data to data.txt
#
# Notes:
# - data.txt is a TSV file
# - format: filetype, data, tags (comma-separated)

require 'erb'
require 'optparse'

def data2html(data_hash, counter)
  base_content = get_content(data_hash, counter)
  header_div = get_header(data_hash, counter)
  attributes = get_attributes(data_hash, counter)
  generate_card(base_content, header_div, attributes)
end

def get_header(data_hash, counter)
  id = counter.to_s
  datatype = data_hash[counter][:type]
  tags = data_hash[counter][:tags].join(",")
  data = data_hash[counter][:data]
  dataset = ""
  title_text = ""
  if datatype == "txt"
    wc = data.split(" ").length
    cc = data.split("").length
    dataset = " data-wc='#{wc.to_s},#{cc.to_s}'"
    title_text << "Word count: #{wc.to_s}"
  elsif datatype == "uri"
    dataset = " data-uri='#{data}'"
    title_text << data
  else
    dataset = " data-name='#{data}'"
    title_text << data
  end
  "<span class='header-id' onclick='openIdbox(this)'#{dataset} title='#{title_text}'>#{id}</span> <span class='header-datatype' onclick='highlightType(this)'>#{datatype}</span> <span class='header-tags' data-tags='#{tags}' onclick='openTagbox(this)'>T</span>"
end

def get_attributes(data_hash, counter)
  id = counter.to_s
  datatype = data_hash[counter][:type]
  tags = data_hash[counter][:tags].join(",")
  "data-id='#{id}' data-type='#{datatype}' data-tags='#{tags}'"
end

def generate_card(base_content, header_div, attributes)
  indentation = "        "
  "#{indentation}<div class='card-box' #{attributes}>\n#{indentation}  <div class='header'>\n#{indentation}    #{header_div}\n#{indentation}  </div>\n#{indentation}  #{base_content}\n#{indentation}</div>\n"
end

def get_content(data_hash, counter)
  datatype = data_hash[counter][:type]
  data = data_hash[counter][:data]

  if datatype == "txt"
    "<div class='card-content'><p class='content text-data data-obj'>#{data}</p></div>"
  elsif datatype == "uri"
    protocol = "https://"
    if data.match(/^(https*|s*ftp|file):\/\//)
      protocol = ""
    end
    domain = data.gsub(/^.*:\/\//, "").gsub(/\/.*/, "")
    "<div class='card-content'><a class='content link-data data-obj' href='#{protocol}#{data}' target='_blank' title='#{data}'>Link: #{domain}</a></div>"
  else
    file_path = @data_dir + data
    if File.exist?(file_path)
      if datatype == "img"
        "<div class='gallery'><a href='#{@data_dir}#{data}' data-caption='#{data}'><img class='img-data data-obj' src='#{@data_dir}#{data}' width=150 alt='#{data}' /></a></div>"
      elsif datatype == "fil"
        file_content = File.read(file_path)
        "<div class='file-data data-obj'>#{file_content}</div>"
      elsif datatype == "snd"
        audio_type = data.gsub(/.*\./, "").gsub(/mp3/, "mpeg")
        "<audio controls><source src='#{@data_dir}#{data}' type='audio/#{audio_type}'></audio>"
      elsif datatype == "vid"
        video_type = data.gsub(/.*\./, "").gsub(/mkv/, "x-matroska")
        "<video controls><source src='#{@data_dir}#{data}'></video>"
      end
    else
      puts "  Error: file '#{file_path}' not found."
      ""
    end
  end
end

def image_gallery(data_hash, image_array)
  indentation = "        "
  img_links = "#{indentation}<div class='gallery'>"

  image_array.each do |c|
    datatype = data_hash[c][:type]
    data = data_hash[c][:data]
    file_path = @data_dir + data

    if File.exist?(file_path)
      img_links << "#{indentation}  <a href='#{@data_dir}#{data}' data-caption='#{data}'>\n#{indentation}    <img class='img-data data-obj' src='#{@data_dir}#{data}' width=150 alt='#{data}' />\n#{indentation}  </a>\n"
    end
  end
  img_links << "#{indentation}</div>"
  img_links
end

def get_index(tag_array)
  tag_index = ""
  indentation = "              "
  tag_array.sort.each do |t|
    tag_index << indentation + "<li><a href='##{t}'>#{t}</a></li>"
  end
  tag_index
end

def tag_col(tag)
  col = [ "", " -success", " -warning", " -error" ]
  c = tag.length % 4
  col[c]
end

def tag_weights(tag_hash)
  out_hash = {}
  out_hash[:total] = 0
  out_hash[:tags] = {}

  tag_hash.each do |tag, line_nums|
    len = line_nums.length
    out_hash[:tags][tag] = line_nums.length
    out_hash[:total] += len
  end
  out_hash
end

def generate_cloud(weighted_tags)
  total = weighted_tags[:total]
  tags = weighted_tags[:tags].keys
  values = weighted_tags[:tags].values
  max_weight = values.max
  min_weight = values.min
  out_html = ""
  tags.sort.each do |t|
    col = tag_col(t)
    weight = weighted_tags[:tags][t]
    size = (0.8 + (weight.to_f / max_weight.to_f) * 2.2).round(1)
    style = "style='font-size:#{size.to_s}em'"
    html = "<a class='tag-box tag-cloud -pill#{col}' #{style} href='##{t}' title='Frequency: #{weight}'>#{t}</a> "
    out_html << html
  end
  out_html
end

def increment_associations(associated_tags, tag_array)
  tag_array.each do |a|
    remaining = tag_array.clone
    remaining.delete(a)
    if !associated_tags[a]
      associated_tags[a] = {}
      associated_tags[a][:total] = 0
      associated_tags[a][:tags] = {}
    end
    remaining.each do |r|
      if associated_tags[a][:tags][r]
        associated_tags[a][:tags][r] += 1
      else
        associated_tags[a][:tags][r] = 1
        associated_tags[a][:total] += 1
      end
    end
  end
end

def populate_associations(associated_tags)
  out_html = ""
  associated_tags.each do |tag,tag_weights|
    out_html << "<div class='assoc-modal' id='assoc-modal-#{tag}'>"
    out_html << generate_cloud(tag_weights)
    out_html << "</div>"
  end
  out_html
end

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ./thematic_analysis.rb [options]"

  opts.on("-i", "--input LIST", "Specify data list file as input") { |v| options[:data_list] = v }
  opts.on("-d", "--data-dir FILE", "Specify data dir") { |v| options[:data_dir] = v }
  opts.on("-o", "--output FILE", "Specify output file") { |v| options[:output] = v }

end.parse!

@data_list = "data.txt"
@data_dir = "data/"

list_opt = options[:data_list]
dir_opt = options[:data_dir]

if list_opt
  @data_list = list_opt
end

if dir_opt
  if Dir.exist?(dir_opt)
    @data_dir = File.absolute_path(dir_opt) + "/"
  else
    abort( "Error: Specified data directory #{dir_opt} does not exist.")
  end
end

data = File.read(@data_list)
file_list = Dir.glob(@data_dir + "*")

counter = 1

data_hash = {}

audio = []
text = []
images = []
links = []
files = []
videos = []

tag_hash = {}

types = {
  "txt" => text,
  "img" => images,
  "uri" => links,
  "fil" => files,
  "vid" => videos,
  "snd" => audio
}

associated_tags = {}

data.each_line do |line|
  if line.match(/^$/) then next end
  line_split = line.chomp.split("\t")
  if line_split.length > 3
    abort("  Error: Wrong number of fields in line #{counter.to_s}.")
  end
  datatype, data_content, tags = line_split
  if !types[datatype] then next end

  tag_array = tags.gsub(/^\s|\s$/, "").gsub(/,\s+/, ",").gsub(/\s+/, "-").split(",").uniq

  tag_array.each do |a|
    if tag_hash[a]
      tag_hash[a] << counter
    else
      tag_hash[a] = [ counter ]
    end
  end

  increment_associations(associated_tags, tag_array)
  data_hash[counter] = { :type => datatype, :data => data_content, :tags => tag_array }

  types[datatype] << counter
  counter += 1
end

tags_out = ""

weighted_tags = tag_weights(tag_hash)

tag_hash.keys.sort.each do |tag|
  line = tag_hash[tag]
  col = tag_col(tag)
  freq = weighted_tags[:tags][tag].to_s
  tags_out << "        <div data-taggroup='#{tag}'><a name='#{tag}'></a><h3 class='h3-tag' onclick='openAssoc(this)' title='Frequency: #{freq}'><span class='tag-box#{col}'>#{tag}</span></h3>\n        <div grid>\n"
  line.each do |l|
    d = data_hash[l]
    datatype = d[:type]
    data = d[:data]
    tags_out << data2html(data_hash, l)
  end
  tags_out << "          </div>\n        </div>\n"
end

$tag_cloud = generate_cloud(weighted_tags)
$associated_tags = populate_associations(associated_tags)

$tags_out = tags_out
$images_out = image_gallery(data_hash, images)
$audio_out = audio.map { |c| data2html(data_hash, c) }.join
$links_out = links.map { |c| data2html(data_hash, c) }.join
$files_out = files.map { |c| data2html(data_hash, c) }.join
$videos_out = videos.map { |c| data2html(data_hash, c) }.join
$text_out = text.map { |c| data2html(data_hash, c) }.join
$tag_index = get_index(tag_hash.keys)

output = ERB.new(File.read("template.rhtml")).result

html_name = "index.html"
output_file = options[:output]
if output_file
  html_name = output_file
end
File.open(html_name, "w") { |o| o << output }
