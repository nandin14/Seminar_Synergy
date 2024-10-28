from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.cluster import KMeans
from google.colab import drive
import pandas as pd

# Mount Google Drive
drive.mount('/content/drive')

# Load the CSV file from Google Drive
file_path = '/content/drive/My Drive/Cleaned_Final_Table.csv'  # Replace with your actual file path
seminar_data = pd.read_csv(file_path)

# Display first few rows to confirm loading
seminar_data.head()

# Combine 'Title of the Seminar' and 'Abstract' to form a text corpus
seminar_data['Text'] = seminar_data['Title of the Seminar'] + ' ' + seminar_data['Abstract']
seminar_data['Text'] = seminar_data['Text'].fillna('')  # Handle missing values

# Convert the seminar text data into TF-IDF features
tfidf_vectorizer = TfidfVectorizer(stop_words='english')
tfidf_matrix = tfidf_vectorizer.fit_transform(seminar_data['Text'])

# Apply K-Means Clustering with the desired number of clusters
num_clusters = 20
kmeans = KMeans(n_clusters=num_clusters, random_state=42)
kmeans.fit(tfidf_matrix)

# Assign each seminar to a cluster
seminar_data['Cluster'] = kmeans.labels_

# Extract top terms in each cluster for dynamic category creation, ensuring uniqueness
order_centroids = kmeans.cluster_centers_.argsort()[:, ::-1]
terms = tfidf_vectorizer.get_feature_names_out()

# Track terms that have already been used to ensure uniqueness
used_terms = set()
top_terms_per_cluster = []

for i in range(num_clusters):
    top_terms = []
    for ind in order_centroids[i, :]:
        term = terms[ind]
        # Only add the term if it hasn't been used by another cluster
        if term not in used_terms:
            top_terms.append(term)
            used_terms.add(term)
        # Break once we've collected enough unique terms
        if len(top_terms) >= 30:
            break
    top_terms_per_cluster.append(top_terms)

# Suggest unique category names based on top terms in each cluster
categories = []
for i, terms in enumerate(top_terms_per_cluster):
    print(f"Cluster {i+1} Top Terms: {terms}")

    # Naming categories based on unique top terms
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
    elif 'clustering' in terms:
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
    elif 'robotics' in terms:
        category = "Robotics and Automation"
    elif 'financial' in terms or 'commerce' in terms:
        category = "FinTech and E-Commerce"
    elif '3d' in terms or 'printing' in terms:
        category = "3D Printing and Manufacturing"
    else:
        category = "General Machine Learning and AI"

    # Ensure the category is unique by checking for duplicates
    if category not in categories:
        categories.append(category)

# Output the unique categories
print("Unique Seminar Categories:")
for i, category in enumerate(categories):
    print(f"Category {i+1}: {category}")
