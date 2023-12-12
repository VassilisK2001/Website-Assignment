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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/myListings.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/header.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" />
    <script src="<%=request.getContextPath()%>/js/sweetalert.min.js"></script>
    
    <title>My Listings</title>
</head>

<body>
    <header class="header">
        <div class="logo">
            <img src="<%=request.getContextPath()%>/images/Logo.png" alt="Logo">
        </div>
        <nav class="nav-menu">
            <span class="signed-in-info">Signed in as <%=teacher.getUsername()%></span>
            <a href="Index.jsp">About</a>
            <a href="CreateListing.jsp">Create Listing</a>
            <a href="MyListings.jsp" class="active">My Listings</a>

            <% if (!listings.isEmpty()) {  %>
            <a href="InterestedStudents.jsp">Interested Students</a>
            <%  } %>
            <a href="logout.jsp"><span><i class="fas fa-arrow-right-from-bracket"></i></span>Log Out</a>
            
        </nav>
    </header>
  <div class="container">
    <main class="language-listings">

        <% if (listings.isEmpty()) { %>

        <div class="language-info">
            <h2>You have not created any listings</h2>
        </div>

        <button class="new-listing-button" onclick="location.href='CreateListing.jsp'">
            <i class="fa-solid fa-arrow-right"></i> <b>Create your listing here</b>
        </button>

        <% } else {  %>
        
        <div class="language-info">
            <h2>My Listings</h2>
        </div>

        <div class="teacher-listings" id="listingsContainer">
            
            <% for(Listing listing:listings) { 

                String education = listing.getEducation();
                education = education.replace("\n", "<br>");
                listing.setEducation(education);

                if(!listing.getCertifications().equals("")){

                    String certifications = listing.getCertifications();
                    certifications = certifications.replace("\n", "<br>");
                    listing.setCertifications(certifications);
                }
            
            %>
            <div class="teacher-card" id="listing_<%=listing.getId()%>">
                <img src="<%=request.getContextPath()%>/images/<%=listing.getFileName()%>">
                <div class="teacher-details">
                    <h3><%=listing.getCreator().getFirstname()%> <%=listing.getCreator().getLastname()%> <span><%=listing.getCreator().getAge()%> years old</span></h3>
                    <p>Region: <%=listing.getCreator().getRegion()%></p>
                    <p>Email: <%=listing.getCreator().getEmail()%></p>
                    <p>Language: <%=listing.getLanguage()%></p>
                    <p>Experence: <%=listing.getExperience()%> years</p>
                    <p>CEFR Level: <%=listing.getTeachComp()%></p>
                    <div class="textarea-container">
                        <p>Education: </p>
                        <div class="content">
                            <%=listing.getEducation() %>
                        </div>
                    </div>
                    

                    <% if(!listing.getCertifications().equals("")){ %>

                        <div class="textarea-container">
                            <p>Certifications: </p>
                            <div class="content">
                                <%=listing.getCertifications() %>
                            </div>
                        </div>
                    <% } %> 

                    <p>Price per Hour: <%=listing.getPrice()%> euros</p>
                    <span>
                        <button type="submit" class="delete-listing-button" onclick="confirmDelete('<%=listing.getId()%>')">
                            Delete listing 
                        </button>

                    </span>
                </div>
            </div>
           
        </div>

<% 
    }
}
%>

<script>
    function confirmDelete(listingId) {
        swal({
            title: "Are you sure?",
            text: "Once deleted, you will not be able to recover this listing!",
            icon: "warning",
            buttons: true,
            dangerMode: true,
        })
        .then((willDelete) => {
            if (willDelete) {
                // If the user confirms the deletion, call the deleteListing function
                deleteListing(listingId);
            } else {
                swal("Your listing is safe!");
            }
        });
    }


    function deleteListing(listingId) {
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "DeleteListing.jsp", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    // Update the UI to remove the listing without refreshing the page
                    var listItem = document.getElementById("listing_" + listingId);
                    if (listItem) {
                        listItem.remove();

                        // Reorder the remaining listings
                        reorderListings();
                    }

                    // Show success message using SweetAlert
                    swal("Poof! Your listing has been deleted!", {
                        icon: "success",
                    });
                } else {
                    // Handle any errors that may occur during the deletion
                    swal("Oops! Something went wrong. Your listing is safe.");
                }
            }
        };
        xhr.send("listingId=" + encodeURIComponent(listingId));
    }


    function reorderListings() {
        // Get the container element
        var container = document.getElementById("listingsContainer");

        // Get all list items within the container
        var listItems = container.getElementsByClassName("teacher-card");

        // Loop through the list items and update their IDs
        for (var i = 0; i < listItems.length; i++) {
            var listingId = listItems[i].getAttribute("id").split("_")[1];
            listItems[i].setAttribute("id", "listing_" + (i + 1));
        }
    }

</script>
        </main>
  </div>

    <%@ include file="footer.jsp"%>
    
</body>

</html>