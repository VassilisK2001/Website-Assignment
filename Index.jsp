<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="eLanguage_classes.*"%>
<%@ page import="java.util.*" %>
<%@ page errorPage="AppError.jsp" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE-edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/Index.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/header.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" />

    <title>Index Page</title>
</head>

<body>

    <header class="header">
        <div class="logo">
            <img src="<%=request.getContextPath()%>/images/Logo.png" alt="Logo">
        </div>
        <% if(session.getAttribute("studentObj") == null && session.getAttribute("teacherObj") == null) { %>
            
        <nav class="nav-menu">
            <a href="Index.jsp" class="active">About</a>
            <a href="signup.jsp">Register</a>
            <a href="login.jsp">Sign In </a>   
        </nav>

        <% } else {
            if(session.getAttribute("studentObj") == null){
                Teacher teacher = (Teacher) session.getAttribute("teacherObj"); 

                ListingService listserv = new ListingService();
                List<Listing> listings = listserv.getTeacherListings(teacher);   
            %>
                <nav class="nav-menu">
                    <span class="signed-in-info">Signed in as <%=teacher.getUsername()%></span>
                    <a href="Index.jsp" class="active">About</a>
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
                    <a href="Index.jsp" class="active">About</a>
                    <a href="Select_language.jsp">Select Language</a>
                    <a href="logout.jsp"><span><i class="fas fa-arrow-right-from-bracket"></i></span>Log Out</a>
                </nav>
            <% 
            }
        }
        %>
    </header>

    <div class="content">
        <div class="left-content">
            <h1>Welcome to E-Language!</h1>
            <h2>Do you need private lessons?</h2>
            <p>E-language is the easiest way to find the best teachers for the language you desire!</p>
            <p>Our app connects students who are looking for private lessons to learn a foreign language with high-skilled teachers based in Athens.</p>
            <h3>If you are a student:</h3>
            <p>Select the language you are interested in and find the teacher that best matches your demands from the listings created by a variety of teachers. You can show interest and communicate with teachers by sending them an e-mail.</p>
            <h3>If you are a teacher:</h3>
            <p>Create your listing and find students for private lessons. You will be notified when a student shows interest for your services, so keep your eyes open!</p>
        </div>

        <div class="right-content">
            <img src="<%=request.getContextPath()%>/images/indeximg1.jpg" alt="Index Photo">
        </div>
    </div>
    
    <%@ include file="footer.jsp" %>
    
</body>

</html>





