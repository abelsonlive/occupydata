#!/usr/bin/env python

import requests
from bs4 import BeautifulSoup

URL = 'http://www.mediacloud.org/'

r = requests.get(URL)
soup = BeautifulSoup(r.content)

dates = [option['value'] for option in soup.select('select#date1 option')]

output_csv = open('../data/media_cloud.csv', 'w')

for date in dates[55:]:
	params = {
		'show_results': 'true',
		'date1': date,
		'dashboard_topics_id1': 292,
		'media_sets_id': 1,
		'date2': dates[0],
	}

	# requests has a "params" argument, but it loses the order which (insanely)
	# results in a 500 error
	filter_r = requests.get(
		URL + 'dashboard/view/1?show_results=true&date1=%s&dashboard_topics_id1=292&medium_name1=&media_sets_id1=1&date2=%s&dashboard_topics_id2=&medium_name2=&media_sets_id2=' % (
			date,
			dates[0]
		))

	print 'Getting stories for %s' % date
	if filter_r.status_code != 200:
		filter_r.raise_for_status()

	query_id = filter_r.url.split('=')[1]
	print '* query_id: %s' % query_id
	
	csv_url = URL + 'dashboard/get_word_list/1?format=csv&queries_ids=%s' % query_id
	print '* csv url %s' % csv_url
	csv_r = requests.get(csv_url)
	if csv_r.status_code != 200:
		csv_r.raise_for_status()

	if len(csv_r.content.splitlines()) > 1:
		output_csv.write(csv_r.content)
		print '* adding %d rows' % len(csv_r.content.splitlines())
	else:
		print '* adding no rows'

output_csv.close()
