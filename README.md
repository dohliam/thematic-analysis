# Thematic Anlaysis Parser

This project is a simple data parser to aid in the process of Qualitative Data Analysis, specifically thematic analysis with multimodal data. It reads a simple data file containing plain text coded data (see the example `data.txt` file in this repo) and visualizes it using a "card-style" layout. It is intended to be a flexible aid in conducting research, and can be used at any stage of analysis as a complement to other tools.

* [Demo](#demo)
* [Features](#features)
* [Coding](#coding)
* [Requirements](#requirements)
* [Usage](#usage)
* [Options](#options)
* [Data format](#data-format)
* [File types](#file-types)
* [To do](#to-do)
* [Credits](#credits)

## Demo

A working demo with sample data can be viewed by downloading the project and opening the `index.html` file found in the project root directory in any browser.

The same demo can also be viewed online [here](https://dohliam.github.io/thematic-analysis-parser).

## Features

* Free and open source software
* Cross-platform
* No data lock-in
* Entirely local and offline
* Data can be viewed on any device
* Mobile-friendly
* Works with plain text data
* Supports multimodal datasets
* Can be used with grounded analysis
* Card-based layout
* Both weighted and associative tag/code visualizations

Data can be in the form of text files, text snippets/citations, images, URL links, audio files, video files etc.

Similar to other CAQDAS tools, the thematic analysis parser supports jumping quickly between data artifacts, codes/tags, and data types in the dataset. All tags in the weighted tag cloud are functional links, and one can look at the most prominent tags and jump to them quickly simply by clicking on them.

Once one has entered the view of the collection of items represented by a particular tag, the place of any given item in the rest of the dataset can be quickly explored using the associated tags button. Again, clicking any of the tags displayed in this view links directly to the collection of items associated with that tag, where the collection (including the original item) can be seen in context.

The usefulness of this tool is that it can present the existing data in such a way that hidden patterns and trends are made visible to the researcher, who is then free to interpret the significance (if any) of those patterns in relation to the rest of the data.

## Coding

All data is stored in plain text files which are persistent, portable, quick to edit, both human- and machine-readable, future-proof, and avoid the vendor lock-in of proprietary formats. Data items are presented in the form of "cards", emulating the traditional workflow of using index cards for codes.

Codes are treated as weighted tags, ranked by frequency both in the corpus as a whole and in relationship to other codes.

Codes are linked to other codes in associative groups, and are arranged in such a way as to facilitate navigating through and between codes to highlight prominent relationships between codes and other patterns in the data.

## Requirements

* A recent version of [Ruby](https://www.ruby-lang.org/)
* Any modern browser supporting HTML5 and JavaScript

## Usage

The simplest way to parse some data for visualization is to add a list of tagged data to `data.txt`, (optionally) add some source data files to the `data` directory, and run the script:

```bash
./thematic_analysis.rb
```

By default, the script looks for data in a file called `data.txt`, and associated multimedia data files in the `data` folder located in the project root directory. However, custom locations for both the data file and multimedia data directory can be specified manually (using the `-i` and `-d` command-line options, respectively).

The script will overwrite the `index.html` file as output by default. If you would like it to output to a different file, this can also be specified using the `o` option.

## Options

The following command-line options are available:

* `-h` or `--help`: _Show help information_
* `-i` or `--input LIST`: _Specify data list file as input_
* `-d` or `--data-dir FILE`: _Specify data dir_
* `-o` or `--output FILE`: _Specify output file_

## Data format

The `data.txt` file contains plain text data in TSV (tab-separated values) format. In other words, each column of data in the file is separated by a `TAB` character.

The columns are ordered as follows:

1. filetype (one of `txt`, `img`, `uri`, `fil`, `snd`, `img`, `img`, `vid`)
2. data (either a filename corresponding to a multimedia file in the `data` directory or a snippet of text data)
3. tags (comma-separated)

## File types

* `txt`: Text - A string of plain text embedded directly in the data file itself
  * Good for quotes, citations, and other single-line snippets of text
* `img`: Image - A filename corresponding to an image file located in the `data` directory
  * Image types can include SVG, JPG, PNG, etc. (anything supported by the HTML `<img>` tag)
* `uri`: URI - A link to an online or offline file location
  * For example, a URL in the form: `example.com`
* `fil`: File - A text file whose contents will be read directly into the data stream
* `snd`: Sound - A filename corresponding to an audio file located in the `data` directory
  * Audio types can include OGG, MP3, etc. (anything supported by the HTML `<audio>` tag)
* `vid`: Video - A filename corresponding to a video file located in the `data` directory
  * Video types can include MP4 and some others (anything supported by your browser's HTML `<video>` tag)
  * Note that video support varies by browser - MP4 seems to work most consistently across browsers

## To do

* ✓ alphabetize tags
* ✓ put tags in modal window
* ✓ make index / overview of all headings and tags
* ✓ frequency counts for main tag headers (put in title attribute)
* ✓ fix duplication of tag clouds on header click
  * ✓ need to hide all tags before displaying new one
* add file name and other info into infobox

## Credits

* CSS: [Concise CSS](https://github.com/ConciseCSS/concise.css) ([MIT](https://github.com/ConciseCSS/concise.css/blob/dev/LICENSE))
* Image lightbox: [baguetteBox.js](https://github.com/feimosi/baguetteBox.js) by @feimosi ([MIT](https://github.com/feimosi/baguetteBox.js/blob/dev/LICENSE))
* Modal windows: [CSS Modal](https://github.com/drublic/css-modal) by @drublic ([MIT](https://github.com/drublic/css-modal/blob/master/LICENSE))
* Sample images:
  * [Example SVG Image File](https://commons.wikimedia.org/wiki/File:Example_en.svg) - Wikimedia Commons
  * [Example PNG Image File](https://commons.wikimedia.org/wiki/File:Example.png) - Wikimedia Commons
  * [Example OGG Audio File](https://commons.wikimedia.org/wiki/File:Example.ogg) - Wikimedia Commons
  * [Example JPG Image File](https://commons.wikimedia.org/wiki/File:Example_image_not_to_be_used_in_article_namespace.jpg) - Wikimedia Commons
  * [Example OGV Video File](https://commons.wikimedia.org/wiki/File:Testing.ogv) - Wikimedia Commons
* Sample text from [Wikipedia](https://en.wikipedia.org/wiki/Battle_of_Caishi)
