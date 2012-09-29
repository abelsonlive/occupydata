#!/usr/bin/env python

import simplejson
import requests
import unicodecsv as csv

API_KEY = 'vhqTHd5SvnkydORd2kwPa1CPUgN8bzHwNvTQu7KUdUgxGh88eF'
API_URL = 'http://api.tumblr.com/v2/blog/%s/posts?api_key=%s&offset=%d'
TUMBLR_NAME = 'wearethe99percent.tumblr.com'

r = requests.get(API_URL % (TUMBLR_NAME, API_KEY, 0))

json = simplejson.loads(r.content)

total_posts = json['response']['total_posts']

offset = 0

csv_file = open('tumblr.csv', 'w')
writer = csv.writer(csv_file)

writer.writerow((
	'id',
	'post_url',
	'timestamp',
	'datetime',
	'tags',
	'body'
))

while offset < total_posts:
	print 'Fetching with offset %d' % offset
	r = requests.get(API_URL % (TUMBLR_NAME, API_KEY, offset))
	offset += 20
	json = simplejson.loads(r.content)
	posts = json['response']['posts']
	for post in posts:
		if post['type'] == 'text':
			body = post['body']
		elif post['type'] == 'photo':
			body = post['caption']
		else:
			continue

		writer.writerow((
			post['id'],
			post['post_url'],
			post['timestamp'],
			post['date'],
			";".join(post['tags']),
			body.replace('\n', '')
		))
	
csv_file.close()
