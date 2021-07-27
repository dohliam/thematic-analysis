window.addEventListener('load', function() {
  baguetteBox.run('.gallery', {
    filter: /.+\.(gif|jpe?g|png|webp|svg)/i
  });
});

function highlightId(headerId) {
  id = headerId.textContent;
  cards = document.getElementsByClassName("card-box");
  for (i = 0; i < cards.length; i++) {
    c = cards[i];
    cardId = c.dataset.id;
    if (cardId == id) {
      c.classList.toggle("card-highlight");
    } else {
      c.classList.toggle("card-hidden");
    }
  }
}

function highlightType(headerType) {
  type = headerType.textContent;
  cards = document.getElementsByClassName("card-box");
  for (i = 0; i < cards.length; i++) {
    c = cards[i];
    cardType = c.dataset.type;
    if (cardType == type) {
      c.classList.toggle("card-highlight");
    } else {
      c.classList.toggle("card-hidden");
    }
  }
}

function openTagbox(headerTags) {
  tags = headerTags.dataset.tags.split(",").sort();
  tagbox = document.getElementById("tagbox");
  tagbox.innerHTML = "";
  col = [ "", " -success", " -warning", " -error" ];
  for (i=0; i<tags.length; i++) {
    tag = tags[i];
    c = tag.length % 4;
    tagbox.innerHTML += "<a class='tag-box -pill" + col[c] + "' href='#" + tag + "'>" + tag + "</span>";
  }
  window.location = "#modal-tagbox";
}

function openAssoc(tagHeading) {
  tag = tagHeading.textContent;
  div = document.getElementById("assoc-modal-" + tag);
  assoc = document.getElementsByClassName("assoc-modal");
  for (i=0; i<assoc.length; i++) {
    assoc[i].style.display = "none";
  }
  div.style.display = "block";
  window.location = "#modal-associated";
}

function openIdbox(headerId) {
  id = headerId.textContent;
  typeContainer = headerId.nextElementSibling;
  datatype = typeContainer.textContent;
  tags = typeContainer.nextElementSibling.dataset.tags;
  tagCount = tags.split(",").length;
  filename = headerId.dataset.name;
  counts = headerId.dataset.wc;
  infobox = document.getElementById("infobox");
  outtxt = "";
  id_txt = "<li><span class='info-title'>ID: </span><span class='info-content'>" + id + "</span></li>";
  type_txt = "<li><span class='info-title'>Type: </span><span class='info-content'>" + datatype + "</span></li>";
  tag_txt = "<li><span class='info-title'>Tag count: </span><span class='info-content'>" + tagCount + "</span></li>";
  detail_txt = "";
  if (filename) {
    detail_txt = "<li><span class='info-title'>Filename: </span><span class='info-content'>" + filename + "</span></li>";
  } else if (counts) {
    c = counts.split(",");
    wc = c[0];
    cc = c[1];
    detail_txt = "<li><span class='info-title'>Word count: </span><span class='info-content'>" + wc + "</span></li><li><span class='info-title'>Character count: </span><span class='info-content'>" + cc + "</span></li>";
  }
  outtxt += id_txt + type_txt + tag_txt + detail_txt
  infobox.innerHTML = "<ul>" + outtxt + "</ul>";
  window.location = "#modal-infobox";
}
