<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="eLanguage_classes.*" %>
<%@ page errorPage="AppError.jsp" %>


<%

// Check if the request method is not POST, and throw an exception with a sign-in link
if(!request.getMethod().equals("POST")){
    throw new Exception("You are not authorized to access this resource.Please <a href='login.jsp'>sign in</a>.");
}

// Retrieve parameters from the request
String studentId = request.getParameter("student_id");
String listingId = request.getParameter("listing_id");
String interest_date = request.getParameter("interest_date");

        if(studentId != null && listingId != null){

            int student_id = Integer.parseInt(studentId);
            int listing_id = Integer.parseInt(listingId);

            // Create an instance of InterestService
            InterestService trackService = new InterestService();

            try{        
                
                // Add student interest using the provided parameters
                trackService.addStudentInterest(listing_id, student_id, interest_date);

            }catch(Exception e){
                throw new Exception(e.getMessage());

            }
        }

%>