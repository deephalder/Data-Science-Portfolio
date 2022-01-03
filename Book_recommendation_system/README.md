
# Book genre prediction and recommendation.


## Objective: 

* To extract the information about the books of different genres. 
* We are working with 6000+ books data which was scraped from goodreads(File attached).
* Process the information about books to extract features. 
* Use these features to recommend the genes accordingly to the input text.
* Then recommend books based on the genre predicted.

### Logic 
#### Part 1 : Genre Prediction
    User inputs a text summary/description.
    The text is then cleaned and stemmed using NLTK 
    The text is then used to predict the appropriate  genre.
#### Part2: Recommending Books
    The cleaned text is then appended to a new dataframe,  with the main ‘description tags’ column of the Books dataframe.
    The new dataframe is then vectorized using Countvectorizer.
    Then using cosine similarity , similar scores are assigned for all books, including the user input based on description tags.
    Finally the most similar  5 books are displayed based on user input.
    The 5 book’s image and caption are displayed in a column format.




## Authors

- [@deephalder](https://www.github.com/deephalder)


## 🔗 Links
[![portfolio](https://img.shields.io/badge/my_portfolio-000?style=for-the-badge&logo=ko-fi&logoColor=white)](https://deephalder.github.io/)
[![linkedin](https://img.shields.io/badge/linkedin-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/deephalder/)

