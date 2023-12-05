<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="eLanguage_classes.*" %>
<%@ page import="java.util.*" %>
<%@ page errorPage="AppError.jsp" %>

<%
if(session.getAttribute("studentObj") == null){
    request.setAttribute("message","You are not authorized to access this page. Please sign in.");

%>
<jsp:forward page="login.jsp"/>
<%
}
// get student object from session
Student student = (Student) session.getAttribute("studentObj");

// read language parameter
String language = request.getParameter("language");

// create instance of ListingService
ListingService listserv = new ListingService();
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/listByLang.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/header.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" />
    
    <title>Language Listings</title>
</head>

<body>
    <header class="header">
        <div class="logo">
            <img src="<%=request.getContextPath()%>/images/Logo.png" alt="Logo">
        </div>
        <nav class="nav-menu">
            <span class="signed-in-info">Signed in as <%=student.getUsername()%> </span>
            <a href="Index.jsp">About</a>
            <a href="logout.jsp"><span><i class="fas fa-arrow-right-from-bracket"></i></span>Log Out</a>
        </nav>
    </header>
  <div class="container">
    <main class="language-listings">

    <% 
    List<Listing> listings = listserv.getLangListings(language);
        
    if(listings.isEmpty()){
    %>

        <div class="language-info">
            <h2>There are not listings available for this language</h2>
        </div>

    <%
    } else {
    %>

    <div class="language-info">
        <h2><%=language%></h2>
    </div>

    <%
        for(Listing listing: listings){
    %>

        <div class="teacher-listings">
            <!-- Teacher listings for English language -->
            <div class="teacher-card">
                <img src="<%=request.getContextPath()%>/images/<%=listing.getFileName()%>">
                <div class="teacher-details">
                    <h3><%=listing.getCreator().getFirstname()%> <%=listing.getCreator().getLastname()%> <span><%=listing.getCreator().getAge()%> years old</span></h3>
                    <p>Region: <%=listing.getCreator().getRegion()%></p>
                    <p>Email: <%=listing.getCreator().getEmail()%></p>
                    <p>Language: <%=listing.getLanguage()%></p>
                    <p>Experence: <%=listing.getExperience()%> years</p>
                    <p>CEFR Level: <%=listing.getTeachComp()%></p>
                    <p>Education: <%=listing.getEducation()%></p>

                    <% if(!listing.getCertifications().equals("")){ %>

                    <p>Certifications: <%=listing.getCertifications()%></p>

                    <% } %> 

                    <p>Price per Hour: <%=listing.getPrice()%> euros</p>
                    <span>
                        <button type="submit" class="show-interest-button" onclick="openPopup('<%=listing.getId()%>'); sendData('<%=listing.getId()%>','<%=student.getId()%>') ">
                            Show Interest
                        </button>
                        <div class="popup" id="popup_<%=listing.getId()%>">
                            <img src="<%=request.getContextPath()%>/images/tickmark.png">
                            <h2>Thank you</h2>
                            <p>Your interest has been successfully diclared.</p>
                            <p>The teacher will be notified for your interest.</p>
                            <button type="button" onclick="closePopup('<%=listing.getId()%>')">OK</button>
                        </div>
                    </span>
                </div>
            </div>      
            
        </div>

<% 
    }
}
%>

<script>

    function openPopup(listingId){
        let popup = document.getElementById("popup_" + listingId);
        popup.classList.add("open-popup");
    }

    function closePopup(listingId){
        let popup = document.getElementById("popup_" + listingId);
        popup.classList.remove("open-popup");
    }

    function sendData(listingId,studentId) {
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "TrackInterest.jsp", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

        // Prepare data to be sent
        var data = "student_id=" + encodeURIComponent(studentId) + "&listing_id=" + encodeURIComponent(listingId);

        // Send the request
        xhr.send(data);

    }
</script>

         <button class="select-lang-button" onclick="location.href='Select_language.jsp'">
            <i class="fa-solid fa-arrow-left"></i> <b>Select another language</b>
        </button>

    </main>
  </div>

   <%@ include file="footer.jsp"%>
    
</body>

</html>





