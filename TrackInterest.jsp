<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="eLanguage_classes.*" %>
<%@ page errorPage="AppError.jsp" %>


<%
if(!request.getMethod().equals("POST")){
    throw new Exception("You are not authorized to access this resource.Please <a href='login.jsp'>sign in</a>.");
}

String studentId = request.getParameter("student_id");
String listingId = request.getParameter("listing_id");

        if(studentId != null && listingId != null){

            int student_id = Integer.parseInt(studentId);
            int listing_id = Integer.parseInt(listingId);

            InterestService trackService = new InterestService();

            try{               
                trackService.addStudentInterest(listing_id, student_id);

            }catch(Exception e){
                throw new Exception(e.getMessage());

            }
        }

%>