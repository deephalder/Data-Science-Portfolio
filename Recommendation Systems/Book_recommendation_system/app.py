import pandas as pd
import streamlit as st
import pickle
import re
from sklearn import preprocessing
from sklearn.metrics.pairwise import cosine_similarity
import nltk
from nltk.stem.porter import PorterStemmer
from PIL import Image


st.title('Book Genre Prediction and  Recommendation System')

st.write('Author : P79 Group 2')

st.write('*****************************************')


#importing pickle files

books = pickle.load(open('books.pkl', 'rb'))
model = pickle.load(open('model.pkl', 'rb'))
cv = pickle.load(open('CountVectorizer.pkl', 'rb'))

#text cleaning,lowercase,removing special characters and stemming words. Note: We are handling stopwords directly using CountVectorizer's inbuilt stop_words functions.

ps = PorterStemmer()
def clean_summary(text):
    # removing everything other than alphabets and numbers with spaces
    text = re.sub('\W+', ' ', text)
    text = text.lower()  # converts all the text to lowercase
    #stemming words now.
    y = []
    for i in text.split():
        y.append(ps.stem(i))
    return " ".join(y)


#getting the data from the user. It can be a description or summary of any book.

text_in = st.text_area('Please enter any summary/paragraph.')
rec = [clean_summary(text_in)]


# now once the user clicks on the predict and recommend button.The following will happen.
    ## Model will predict the genre of the description.
    ## the input text will be vectorized and then matched with outher rows in tags columns of Books df to get a similarity score. 
    ## finally we will use the text entered the get the best cosine similarity score for 5 books and display them.

if st.button('Predict genre and recommend books'):
    #displaying progress bar:
    import time
    my_bar = st.progress(0)
    for percent_complete in range(100):
        time.sleep(0.005)
        my_bar.progress(percent_complete + 1)
    # predicting genre
    t = cv.transform(rec).toarray()
    le = preprocessing.LabelEncoder()
    le.fit_transform(books.genre)
    pr = le.inverse_transform(model.predict(t))
    st.markdown("<h3 style='text-align: center;'> Predicting the genre of the input.</h3>", unsafe_allow_html=True)
    st.write('The predicted genre of the summary/description entered is :', pr[0])
    
    
    # Recommending books now:
    tags = pd.DataFrame({'tags': rec})
    df_tags = books[['tags']]
    tags = tags.append(df_tags, ignore_index=True)
    tags_test_cv = cv.fit_transform(tags['tags']).toarray()
    similarity_tags = cosine_similarity(tags_test_cv)
    recommended_sorted_list = sorted(list(enumerate(similarity_tags[0])),reverse= True,key= lambda x:x[1])[1:6]
    recommended_books = []
    recommended_book_posters = []
    for i in recommended_sorted_list:
        recommended_books.append(books.iloc[i[0]].title)
        recommended_book_posters.append(books.iloc[i[0]].image_url)
    st.write('*****************************************')
    st.markdown("<h3 style='text-align: center;'> Book Recommendations.</h3>", unsafe_allow_html=True)
    st.markdown("<h5 style='text-align: center; color: red;'>5 Books that are similar to the summary/description text.</h5>", unsafe_allow_html=True)

    col1, col2, col3, col4, col5 = st.columns(5)
    with col1:
        st.image(recommended_book_posters[0], caption=recommended_books[0])
        
    with col2:
        st.image(recommended_book_posters[1], caption=recommended_books[1])

    with col3:
        st.image(recommended_book_posters[2], caption=recommended_books[2])
        
    with col4:
        st.image(recommended_book_posters[3],caption=recommended_books[3])
        
    with col5:
        st.image(recommended_book_posters[4], caption=recommended_books[4])
        

    
        
    
    



