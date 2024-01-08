<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="eLanguage_classes.*" %>
<%@ page import="java.util.*" %>
<%@ page errorPage="AppError.jsp" %>

<%

// Check if the teacher is not authenticated; if not, forward to login page
if(session.getAttribute("teacherObj") == null){
    request.setAttribute("message","You are not authorized to access this page. Please sign in.");

%>

<jsp:forward page="login.jsp"/>

<%
}

// Get the teacher object from the session
Teacher teacher = (Teacher) session.getAttribute("teacherObj");

// Create a ListingService object
ListingService listserv = new ListingService();

// Get the list of listings the teacher has created
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

         <!-- Display teacher's information in the navigation -->
        <nav class="nav-menu">
            <span class="signed-in-info">
                <%=teacher.getUsername()%>
            </span>
            <img class="user-img" src="<%=request.getContextPath()%>/images/user.png">
            <a href="Index.jsp">About</a>
            <a href="CreateListing.jsp">Create Listing</a>
            <a href="MyListings.jsp" class="active">My Listings</a>

            <% if (!listings.isEmpty()) {  %>
            
            <!-- Show navigation link for Interested Students page only if the teacher has created listings-->
            <a href="InterestedStudents.jsp">Interested Students</a>

            <%  } %>

            <a href="logout.jsp"><span><i class="fas fa-arrow-right-from-bracket"></i></span>Log Out</a>
            
        </nav>
    </header>
  <div class="container">
    <main class="language-listings">

         <!-- Check if the teacher has no listings and display a message if there are none -->
        <% if (listings.isEmpty()) { %>

        <div class="language-info" style="background-color: #FFB833;">
            <h2>You have not created any listings</h2>
        </div>

         <!-- Button to create a new listing -->
        <button class="new-listing-button" onclick="location.href='CreateListing.jsp'">
            <i class="fa-solid fa-arrow-right"></i> <b>Create your listing here</b>
        </button>

        <% } else {  %>
        
        <!-- Display listings if the teacher has created listings -->
        <div class="language-info">
            <h2>My Listings</h2>
        </div>

        <div class="teacher-listings" id="listingsContainer">

             <!-- Loop through each listing and display details -->
            
            <% for(Listing listing:listings) { 

                // Process and format text for better display
                String education = listing.getEducation();
                education = education.replace("\n", "<br>");
                listing.setEducation(education);

                if(!listing.getCertifications().equals("")){

                    // Process certifications if there are any
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

                        <!-- button to allow listing deletion-->
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

<!-- JavaScript functions for confirming and handling listing deletion -->
<script>

     // Function to confirm listing deletion
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


    // Function to handle the actual deletion of the listing
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


    // Function to reorder listings after listing deletion
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