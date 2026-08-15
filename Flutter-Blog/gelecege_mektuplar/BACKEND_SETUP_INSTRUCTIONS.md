# Backend Server Setup Instructions

It looks like the login/registration is not working because the backend server is not running. Here's how to set it up and run it:

## 1. Create the Environment File

In the `gelecege-mektuplar-backend` directory, create a new file named `.env`.

This file will store your secret configuration, like your database connection string and JWT secret.

## 2. Add Configuration to `.env`

Copy and paste the following into your new `.env` file:

```
# MongoDB Connection String
# Replace this with your actual MongoDB connection string.
# If you are running MongoDB locally, it might look like this:
MONGO_URI=mongodb://localhost:27017/gelecege_mektuplar

# JWT Secret
# This can be any long, random string.
JWT_SECRET=your_super_secret_jwt_key_that_is_long_and_random
```

**Important:**
*   You need to have a MongoDB database running. You can use a local installation or a cloud service like MongoDB Atlas.
*   Replace `mongodb://localhost:27017/gelecege_mektuplar` with your actual MongoDB connection string.
*   Replace `your_super_secret_jwt_key_that_is_long_and_random` with your own secret key.

## 3. Install Dependencies

Open a terminal in the `gelecege-mektuplar-backend` directory and run the following command to install the necessary packages:

```bash
npm install
```

## 4. Run the Server

After the installation is complete, run the following command to start the server:

```bash
npm start
```

You should see a message in the console like:

```
MongoDB Connected: <your_database_host>
Server running on port 5000
```

Once the server is running, your Flutter application should be able to connect to it, and the login/registration will work.

**To stop the server**, press `Ctrl + C` in the terminal.
