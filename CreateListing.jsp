<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="eLanguage_classes.*" %>
<%@ page import="java.util.*" %>

<%
if(session.getAttribute("teacherObj") == null){
    request.setAttribute("message","You are not authorized to access this page. Please sign in.");

%>
<jsp:forward page="login.jsp"/>
<%
}
Teacher teacher = (Teacher) session.getAttribute("teacherObj");

DBDAO dbdao = new DBDAO();
List<String> languages = dbdao.getLanguages();
List<String> regions = dbdao.getRegions();
List<String> cefrlevels = dbdao.getCEFRlevels();

ListingService listserv = new ListingService();
List<Listing> listings = listserv.getTeacherListings(teacher);
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/newListing.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/header.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" />

    <title>Create Listing</title>
</head>

<body>
        <header class="header">
            <div class="logo">
                <img src="<%=request.getContextPath()%>/images/Logo.png" alt="Logo">
                </div>
            <nav class="nav-menu">
                <span class="signed-in-info">Signed in as <%=teacher.getUsername()%></span>
                <a href="Index.jsp">About</a>
                <a href="CreateListing.jsp" class="active">Create Listing</a>

                <% if(!listings.isEmpty()) { %>

                <a href="MyListings.jsp">My Listings</a>
                <a href="InterestedStudents.jsp">Interested Students</a>

                <% }  %>
                <a href="logout.jsp"><span><i class="fas fa-arrow-right-from-bracket"></i></span>Log Out</a>
            </nav>
        </header>

        
        <% if(request.getAttribute("message") != null){ %>

            <div class="message">
                <h2><%=(String) request.getAttribute("message")%></h2>
            </div>
        <% } %>

        <div class="container">
            <h1>Create Listing</h1>

            <form action="newListingController.jsp" method="post"  enctype="multipart/form-data" class="form-horizontal">
            <div class="flex-container">
            <div class="left-container">
            <section>
                <h3>Personal Information</h3>
                  
                    <label for="photo">Photo:</label>
                    <input type="file" id="photo" name="photo" class="info"  accept="image/*" required><br>

                    <label for="firstName">First Name:</label>
                    <input type="text" id="firstName" placeholder="Enter your first name" name="firstName" class="info"  required><br>
    
                    <label for="lastName">Last Name:</label>
                    <input type="text" id="lastName" placeholder="Enter your last name" name="lastName" class="info" required><br>
    
                    <label for="age">Age:</label>
                    <input type="text" id="age" placeholder="Enter your age" name="age" class="info"  required><br>
    
                    <label for="region">Region:</label>
                    <select id="region" name="region" class="info" required>

                        <% for(String region: regions) { %>

                        <option value="<%= region %>"><%= region %></option>

                        <% } %>
                        
                    </select><br>
    
                    <label for="email">Email:</label>
                    <input type="email" id="email" placeholder="Enter your e-mail" name="email" class="info" required><br>
      
            </section>
            <button type="submit" class="create-list-btn">Submit</button>
        </div>

        <div class="right-container">
            <section>
                <h3>Qualifications</h3>
                
                <label for="language">Language:</label>
                <select id="language" name="language" class="info" required>

                    <% for(String language: languages) { %>
                    <option value="<%=language%>"><%=language%></option>

                    <% } %>
                   
                </select><br>
    
                <label for="experience">Experience (years):</label>
                <input type="text" id="experience" placeholder="Enter a number that shows years of experience" name="experience" class="info" required><br>
    
                <label for="teachcomp">Teaching Competency</label>
                <select id="teachcomp" name="teachcomp" class="info" required>

                    <% for(String cefrlevel:cefrlevels) { %>
                    <option value="<%=cefrlevel%>"><%=cefrlevel%></option>

                    <% } %>
                    
                </select><br>
    
                <label for="education">Education:</label>
                <textarea id="education" placeholder="Desribe your educational background" name="education" rows="4" cols="50" class="info" required></textarea><br>
    
                <label for="certifications">Certifications:</label>
                <textarea id="certifications" placeholder="Enter any additional certifications" name="certifications" class="info"></textarea><br>
    
                <label for="pricePerHour">Price per Hour(&euro;):</label>
                <input type="text" id="pricePerHour" placeholder="Enter price per hour for your lessons" name="pricePerHour" class="info" required><br>

            </section>
            
            </div>
        </div>
    </form>
</div>

       <%@ include file="footer.jsp"%>

    
</body>

</html>