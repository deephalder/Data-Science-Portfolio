import pandas as pd
import streamlit as st
import pickle
import requests


movies_dict = pickle.load(open('movies_dict.pkl', 'rb'))
movies = pd.DataFrame(movies_dict)
similarity = pickle.load(open('similarity.pkl', 'rb'))

# creating function to display recommended movies.
def recommend(movie):
    movies_index = movies[movies['title'] == movie].index[0]
    distances = similarity[movies_index]
    movie_names = sorted(list(enumerate(distances)), reverse=True, key=lambda x: x[1])[1:6]

    # returning the index of the 5 most similar movies
    recommended_movies = []
    recommended_movie_posters = []

    for i in movie_names:
        movies_id = movies.iloc[i[0]].movie_id
        #fetching posters from API

        recommended_movies.append(movies.iloc[i[0]].title)
        recommended_movie_posters.append(fetch_posters(movies_id))
    return recommended_movies,recommended_movie_posters

#creating function to display movie posters
def fetch_posters(movie_id_fetch):
    response = requests.get('https://api.themoviedb.org/3/movie/{}?api_key=8265bd1679663a7ea12ac168da84d2e8&language=en-US'.format(movie_id_fetch))
    data_movie = response.json()
    return "https://image.tmdb.org/t/p/w500"+data_movie['poster_path']

st.title('Movie Recommendation System')
st.text('Author : Subhradip Halder')
st.text('Portfolio: deephalder@github.io')
st.text('*****************************************')

selected_movie_name = st.selectbox('Select a movie from the list to get recommendations', movies['title'].values)

if st.button('Get similar movie recommendations'):
    m_names,posters = recommend(selected_movie_name)

    col1, col2, col3 , col4, col5 = st.columns(5)
    with col1:
        st.text(m_names[0])
        st.image(posters[0])
    with col2:
        st.text(m_names[1])
        st.image(posters[1])
    with col3:
        st.text(m_names[2])
        st.image(posters[2])
    with col4:
        st.text(m_names[3])
        st.image(posters[3])
    with col5:
        st.text(m_names[4])
        st.image(posters[4])

st.columns
