<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="eLanguage_classes.*" %>
<%@ page errorPage="AppError.jsp" %>

<%

// Check if the teacher object is not present in the session, set an error message, and forward to the login page
if(session.getAttribute("teacherObj") == null){
    request.setAttribute("message","You are not authorized to access this page. Please sign in.");

%>
<jsp:forward page="login.jsp"/>

<%
} 
// Prevent browser from caching the page 
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-store");
response.setHeader("Expires","0");
response.setDateHeader("Expires",-1);

// Set session timeout to 15 minutes
int sessionTimeoutSeconds = 15 * 60;
session.setMaxInactiveInterval(sessionTimeoutSeconds);

// Retrieve the teacher object from the session
Teacher teacher = (Teacher) session.getAttribute("teacherObj");
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/welcomeTeacher.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/header.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" />
    
    <title>Welcome Teacher</title>
</head>

<body>
    <header class="header">
        <div class="logo">
            <img src="<%=request.getContextPath()%>/images/Logo.png" alt="Logo">
        </div>

        <!-- Display teacher's username and navigation links -->
        <nav class="nav-menu">
          <span class="signed-in-info">
            <%=teacher.getUsername()%>
          </span>
          <img class="user-img" src="<%=request.getContextPath()%>/images/user.png">
          <a href="Index.jsp">About</a>
          <a href="logout.jsp"><span><i class="fas fa-arrow-right-from-bracket"></i></span>Log Out</a>
        </nav>
    </header>

    <div class="content">
        <h1>Welcome!</h1>
        <h3>Thank you for choosing eLanguage as your source for connecting with students. Please choose one of the options below:</h3>

        <!-- Button 1: Create Listing -->
      <div class="option">
        <button class="button" onclick="location.href='CreateListing.jsp'">Create Listing</button>
        <p>Go ahead and create your listing to connect with students. Fill in the language you want to teach along with personal information and qualifications.</p>
      </div>

      <div class="option">
        <!-- Button 2: My Listings -->
        <button class="button" onclick="location.href='MyListings.jsp'">My Listings</button>
        <p>Check the listings you have created and feel free to delete them and create new ones.</p>
      </div>

      <div class="option">
        <!-- Button 3: Interested Students -->
        <button class="button" onclick="location.href='InterestedStudents.jsp'">Interested Students</button>
        <p>Have an eye on the students that are interested in your listings and check your email inbox for any messages from interested students.</p>
      </div>

    </div>
 
    <%@ include file="footer.jsp"%>
    
</body>

</html>