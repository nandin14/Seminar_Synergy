from flask import Flask, jsonify
import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.cluster import KMeans
from flask_cors import CORS
app = Flask(__name__)


CORS(app)  # Enable CORS for all routes

@app.route('/get_categories', methods=['GET'])
def get_categories():
    # Load the data from the CSV file
    seminar_data = pd.read_csv("C:\\Users\\parma\\StudioProjects\\initial_app\\Cleaned_Final_Table.csv")

    # Combine 'Title of the Seminar' and 'Abstract' to form a text corpus
    seminar_data['Text'] = seminar_data['Title of the Seminar'] + ' ' + seminar_data['Abstract']
    seminar_data['Text'] = seminar_data['Text'].fillna('')

    # Convert text data into TF-IDF features
    tfidf_vectorizer = TfidfVectorizer(stop_words='english')
    tfidf_matrix = tfidf_vectorizer.fit_transform(seminar_data['Text'])

    # Apply K-Means Clustering
    num_clusters = 20
    kmeans = KMeans(n_clusters=num_clusters, random_state=42)
    kmeans.fit(tfidf_matrix)

    # Assign each seminar to a cluster
    seminar_data['Cluster'] = kmeans.labels_

    # Extract top terms in each cluster for dynamic category creation
    order_centroids = kmeans.cluster_centers_.argsort()[:, ::-1]
    terms = tfidf_vectorizer.get_feature_names_out()
    used_terms = set()
    top_terms_per_cluster = []

    for i in range(num_clusters):
        top_terms = []
        for ind in order_centroids[i, :]:
            term = terms[ind]
            if term not in used_terms:
                top_terms.append(term)
                used_terms.add(term)
            if len(top_terms) >= 30:
                break
        top_terms_per_cluster.append(top_terms)

    # Suggest unique category names based on top terms
    categories = []
    for i, terms in enumerate(top_terms_per_cluster):
        if 'machine' in terms or 'learning' in terms or 'data' in terms or 'science' in terms:
            category = "Data Science and Machine Learning"
        elif 'network' in terms or 'graph' in terms:
            category = "Network and Graph Theory"
        elif 'ai' in terms or 'models' in terms or 'artificial' in terms or 'intelligence' in terms:
            category = "Artificial Intelligence"
        elif 'retrieval' in terms or 'information' in terms:
            category = "Information Retrieval"
        elif 'iot' in terms or 'cloud' in terms:
            category = "Cloud Computing and IoT"
        elif 'python' in terms or 'programming' in terms:
            category = "Python and Programming Workshops"
        elif 'security' in terms or 'privacy' in terms:
            category = "Cybersecurity and Privacy"
        elif 'recommendation' in terms or 'recommender' in terms:
            category = "Recommendation Systems"
        elif 'clustering' in terms or "mining" in terms:
            category = "Clustering and Data Mining"
        elif 'deep' in terms or 'neural' in terms:
            category = "Deep Learning and Neural Networks"
        elif 'ethics' in terms or 'systems' in terms:
            category = "Ethics in AI and Systems"
        elif 'transformers' in terms or 'language' in terms:
            category = "Natural Language Processing"
        elif 'secure' in terms or 'privacy' in terms:
            category = "Security and Privacy in AI"
        elif 'sgx' in terms or 'intel' in terms:
            category = "Secure Computing"
        elif 'gnns' in terms or 'geometric' in terms:
            category = "Graph Neural Networks"
        elif 'large' in terms or 'models' in terms or 'llms' in terms:
            category = "Large Language Models"
        elif 'resume' in terms or 'screening' in terms:
            category = "AI in Recruitment and HR"
        elif 'robotics' in terms or 'automation' in terms:
            category = "Robotics and Automation"
        elif 'financial' in terms or 'commerce' in terms:
            category = "FinTech and E-Commerce"
        elif '3d' in terms or 'printing' in terms:
            category = "3D Printing and Manufacturing"
        else:
            category = "General Machine Learning and AI"

        if category not in categories:
            categories.append(category)

    # Return the unique categories
    return jsonify(categories)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)