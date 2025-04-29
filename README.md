# Streamify

A modern e-commerce storefront for browsing and purchasing music tracks using the Chinook sample database.

Live Release App URL : https://streamify-nine-mocha.vercel.app/

## Prerequisites

- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Node.js & npm](https://nodejs.org/) (v16+ recommended)

## 1. Setting Up the Database

1. From the **root** of this repository, start the database and pgAdmin:

   ```bash
   docker-compose up --build```
2.  Once the containers are running, open your browser and go to: **pgAdmin 4** 
        
    
3.  Log in with the default credentials:
    
    -   **Username:**  chinook
        
    -   **Password:**  chinook
        
    
4.  In pgAdmin, connect to the postgres server and navigate to the chinook database to view the schema and data.

## **2. Running the Web Application**

1.  Navigate to the frontend directory: ```cd trackzy-web```
2.  Install dependencies: ```npm install```
3.  Start the development server: ```npm run dev```
