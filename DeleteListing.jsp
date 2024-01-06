<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="eLanguage_classes.*" %>
<%@ page errorPage="AppError.jsp" %>


<%

// Check if the request method is not POST; if not, throw an exception
if(!request.getMethod().equals("POST")){
    throw new Exception("You are not authorized to access this resource.Please <a href='login.jsp'>sign in</a>.");
}

// Get the listingId parameter from the request
String listingId = request.getParameter("listingId");

if(listingId != null) {

    int listing_id = Integer.parseInt(listingId);

    // Create a ListingService object
    ListingService listserv = new ListingService();

    try{

        // Attempt to delete the listing using ListingService method
        listserv.deleteListing(listing_id);

    }catch(Exception e) {

    }
    
}
%>