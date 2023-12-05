<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="eLanguage_classes.*" %>
<%@ page errorPage="AppError.jsp" %>


<%
if(!request.getMethod().equals("POST")){
    throw new Exception("You are not authorized to access this resource.Please <a href='login.jsp'>sign in</a>.");
}
String listingId = request.getParameter("listingId");

if(listingId != null) {

    int listing_id = Integer.parseInt(listingId);

    ListingService listserv = new ListingService();

    try{

        listserv.deleteListing(listing_id);

    }catch(Exception e) {

    }
    
}
%>