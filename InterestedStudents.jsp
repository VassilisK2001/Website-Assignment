<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="eLanguage_classes.*" %>
<%@ page import="java.util.*" %>
<%@ page errorPage="AppError.jsp" %>

<%
if(session.getAttribute("teacherObj") == null){
    request.setAttribute("message","You are not authorized to access this page. Please sign in.");

%>
<jsp:forward page="login.jsp"/>
<%
}
Teacher teacher = (Teacher) session.getAttribute("teacherObj");

ListingService listserv = new ListingService();
List<Listing> listings = listserv.getTeacherListings(teacher);
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/interestedStudents.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/header.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" />

    <title>Interested Students</title>
</head>

<body>
    <header class="header">
        <div class="logo">
            <img src="<%=request.getContextPath()%>/images/Logo.png" alt="Logo">
        </div>
        <nav class="nav-menu">
          <span class="signed-in-info">
            <%=teacher.getUsername()%>
          </span>
          <img class="user-img" src="<%=request.getContextPath()%>/images/user.png">
          <a href="Index.jsp">About</a>
          <a href="CreateListing.jsp">Create Listing</a>

          <% if(!listings.isEmpty()) {  %> 
          <a href="MyListings.jsp">My Listings</a>
          <% } %>

          <a href="InterestedStudents.jsp" class="active">Interested Students</a>
          <a href="logout.jsp"><span><i class="fas fa-arrow-right-from-bracket"></i></span>Log Out</a>
        </nav>
    </header>
    <div class="container">

      <% if(listings.isEmpty()) { %>

        <div class="message">
          <h2>You have not created any listings</h2>
        </div>

      <button class="new-listing-button" onclick="location.href='CreateListing.jsp'">
          <i class="fa-solid fa-arrow-right"></i> <b>Create your listing here</b>
      </button>

      <% } else { 

        InterestService interestserv = new InterestService();
        List<Interest> interested_students = interestserv.getInterestedStudents(teacher.getId()); 
      %>

      <div class="message">
        <h2>Interested Students</h2>
      </div>

    <table class="content-table">
        <thead>
          <tr>
            <th>Rank</th>
            <th>First Name</th>
            <th>Last Name</th>
            <th>E-Mail</th>
            <th>Region</th>
            <th>Language</th>
            <th>Showed interest at:</th>
          </tr>
        </thead>
        <tbody>
        
        <% if(interested_students.isEmpty()){ %>

            <tr>
              <td colspan="7"><strong>There are not currently any interested students.</strong></td>
            </tr>

        <% 
        } else {
          int counter = 0;
          for(Interest interest: interested_students) { 
        %>
        
          <tr>
            <td><%=++counter%></td>
            <td><%=interest.getStudent().getFirstname()%></td>
            <td><%=interest.getStudent().getLastname()%></td>
            <td><%=interest.getStudent().getEmail()%></td>
            <td><%=interest.getStudent().getRegion()%></td>
            <td><%=interest.getListing().getLanguage()%></td>
            <td><%=interest.getInterestDate()%></td>
          </tr>
        <% 
          }
        %>
        </tbody>
      </table>
      <%
        }
      %>
    </div>

    <%
      }
    %>

    <%@ include file="footer.jsp"%>
    
</body>

</html>