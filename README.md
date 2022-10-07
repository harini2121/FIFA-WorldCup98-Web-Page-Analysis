# FIFA-WorldCup98-Web-Page-Analysis
Apply big data design patterns in building Web Page Analytics by designing, implementing and deploying a scalable distributed architecture of Hadoop Map Reduce and presenting the results in a webpage using JavaScript.

Objective is to  developing an analytics app for FIFA to determine how people have used their web page during the progress of the world cup. The analysis provides highlevel summarization on user activities to the web page allowing the management to improve web page usability and to do target marketing.

Requirements 

part 1

• Analyze the flowing using Hadoop Map Reduce
1. Total page visits
2. Total unique page visits by client
3. Average total page visits per day
4. Histogram of number of total page visits & unique page visits by client per hour of day (1 to 24)
5. Histogram of number of users(clients) visited the site per day
6. Top 10 users(clients) by page views
7. Top 10 pages by views
8. Percentage of web page view by languages (E.g English, French)
9. Web page errors percentage during match hours*
10. Percentage of avg web page views per hour during match time and other time

*Match hours are available from the schedule (provided in resources) and by joining the requests with match hours will help to find out whether requests were made during match hours.

Static web page to view the above results
a. Use charts to appropriately represent the results.


part 2 

1. Clean up the HTTP log file using Spark

2. Cluster the users based on k-means clustering

   ◦ Extract Client ID, Team played2 (on that day)
   
   ◦ Use the extracted fields to determine common user groups.
   
   ◦ Visualize the results on, Client ID, Team played
 


Resources

The data source

• HTTP Log analysis data can be downloaded from 
  http://ita.ee.lbl.gov/html/contrib/WorldCup.html

• Converting binary data files to text representation can be done from the
  WorldCup_tools.tar.gz provided in the Moodle.

• Match times and the played teams can be obtained from
  http://www.worldfootball.net/all_matches/wm-1998-in-frankreich/

Understanding the HTTP Log data
55 - - [30/Apr/1998:21:38:59 +0000] "GET /french/index.html HTTP/1.0" 200 985
• 55 : Client ID
• [30/Apr/1998:21:38:59 +0000] : Time in GMT
• french : page language
• /french/index.html HTTP/1.0 : url
• 200 : HTTP status code
• 985 : bytes transferred



