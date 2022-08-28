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

<a href="https://scholar.google.com.sg/citations?user=tRI56rsAAAAJ&hl=en" target="_blank">Google Scholar Profile</a>

{%- for y in page.years %}
  <h2 class="year">{{y}}</h2>
  {% bibliography -f papers -q @*[year={{y}}]* %}
{% endfor %}

</div>
