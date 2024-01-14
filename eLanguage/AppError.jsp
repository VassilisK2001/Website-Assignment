<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="eLanguage_classes.*" %>
<%@ page isErrorPage="true" %>
<%@ page import="java.util.*" %>


<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE-edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/AppError.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/header.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" />

    <title>AppError Page</title>
</head>

<body>

    <header class="header">
        <div class="logo">
            <img src="<%=request.getContextPath()%>/images/Logo.png" alt="Logo">
        </div>
        <% if((session.getAttribute("studentObj") == null && session.getAttribute("teacherObj") == null) || exception == null) { 

            request.setAttribute("message","You are not authorized to access this page. Please sign in.");   
        %>
            
        <jsp:forward page="login.jsp"/>

        <% } else {

            // Prevent browser from caching the page 
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");

            // Set session timeout to 15 minutes
            int sessionTimeoutSeconds = 15 * 60;
            session.setMaxInactiveInterval(sessionTimeoutSeconds);

            if(session.getAttribute("studentObj") == null){
                Teacher teacher = (Teacher) session.getAttribute("teacherObj"); 

                ListingService listserv = new ListingService();
                List<Listing> listings = listserv.getTeacherListings(teacher);   
            %>
                <nav class="nav-menu">
                    <span class="signed-in-info">
                        <%=teacher.getUsername()%>
                    </span>
                    <img class="user-img" src="<%=request.getContextPath()%>/images/user.png">
                    <a href="Index.jsp">About</a>
                    <a href="CreateListing.jsp">Create Listing</a>

                    <% if(!listings.isEmpty()) { %>
                    <a href="MyListings.jsp">My Listings</a>
                    <a href="InterestedStudents.jsp">Interested Students</a>
                    <% }  %>
                    <a href="logout.jsp"><span><i class="fas fa-arrow-right-from-bracket"></i></span>Log Out</a>
                  </nav>
            <% } else { 
                Student student = (Student) session.getAttribute("studentObj");   
            %>
                <nav class="nav-menu">
                    <span class="signed-in-info">
                        <%=student.getUsername()%>
                    </span>
                    <img class="user-img" src="<%=request.getContextPath()%>/images/user.png">
                    <a href="Index.jsp">About</a>
                    <a href="Select_language.jsp">Select Language</a>
                    <a href="logout.jsp"><span><i class="fas fa-arrow-right-from-bracket"></i></span>Log Out</a>
                </nav>
            <% 
            }
        }
        %>
    </header>

    <div class="container">

        <div class="warning">
            <h1>Oops. Something went wrong!</h1>
        </div>

        <div class="error-message">
            <h2>
            Description:
            <span>
                <% if(exception != null) { %>

                    <p><code><%=exception%></code></p>
                <% } %>
            </span>
            </h2>
        </div>

    </div>

    <%@ include file="footer.jsp" %>

</body>

</html>
