# Olympic Games (RShiny App)
### App Name 

Olympic Games (See online version [here](<https://deng0068.shinyapps.io/OlympicGames/>))

### App Purpose

This app will be designed to use RShiny to present modern **Olympic Games** (from Athens 1896 to Rio 2016). And highlight factors or features that determine the performance of medal owners compared with other athletes. 

### Data Source

Data scraped from [Sports-Reference](https://www.sports-reference.com/olympics/) that contains 271116 rows and 15 features. Each row corresponds to an individual athlete compete in an individual Olympic event. These features are: 

1. ID - Unique number for each athlete;
2. Name - Athlete's name;
3. Sex - M or F;
4. Age - Integer;
5. Height - In centimeters;
6. Weight - In kilograms;
7. Team - Team name;
8. NOC - National Olympic Committee 3-letter code;
9. Games - Year and season;
10. Year - Integer;
11. Season - Summer or Winter;
12. City - Host city;
13. Sport - Sport;
14. Event - Event;
15. Medal - Gold, Silver, Bronze, or NA.



### App Functions

- Show distributions of players' age, height, weight, etc
- Multiple comparison between countries, events, nations, ages, etc
- By using heat geo map show medals distribution among countries
- Show multiple visualization by different events, gender, players, height, weight, countries, etc
- By using some machine learning algorithms predict futures medals owners' weight and height
- By using word cloud to see the common medal winners' name
- Dig out some interesting **truth** behind the data
- Animation shows medals distribution among countries by year



### Programming Challenges

Programming challenges involves:

- Need a while to be familiar with rshiny

- May need CSS to beautify this shiny app
- It may need more time to debug than accomplishing
- Need to learn how rshiny support multiple pages



### Work Schedule

**Stage 1 - Preparation** (approximately 2 days)

1. Scrape required datasets
2. Initial designing layout of shiny app (by hand)

**Stage 2 - Development** (approximately 2 weeks)

1. Build draft shiny app to match app functions planning
2. Build CSS style and adjust each visualizations
3. Build out optional inclusions

**Stage 3 - Review & Testing** (approximately 2 weeks)

1. Deliver shiny app to classmates and friends for inspection/testing
2. Address any concern or change through inspection
3. Populate needed content to match approved structure



