---
layout: page
permalink: /publications/
title: publications
description:
years: [2020, 2019, 2018, 2017, 2016, 2015, 2014, 2013]
nav: true
nav_order: 1
---
<!-- _pages/publications.md -->
<div class="publications">

<div class="social-pubs">
  <div class="contact-icons">
    <a href="https://scholar.google.com/citations?user={{ site.scholar_userid }}" target="_blank" rel="noopener noreferrer" title="Google Scholar"><i class="ai ai-google-scholar"></i> <span>Siddhartha (Google Scholar)</span></a>
  </div>
</div>

{%- for y in page.years %}
  <h2 class="year">{{y}}</h2>
  {% bibliography -f papers -q @*[year={{y}}]* %}
{% endfor %}

</div>
