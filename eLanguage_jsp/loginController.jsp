<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="eLanguage_classes.*" %>
<%@ page errorPage="AppError.jsp" %>

<%
// Check if the request method is POST, otherwise, restrict access
if(!request.getMethod().equals("POST")){
    throw new Exception("You are not authorized to access this resource.Please <a href='login.jsp'>sign in</a>.");
}

// Extract parameters from the request
String username = new String(request.getParameter("username").getBytes("ISO-8859-1"),"UTF-8");
String password = new String(request.getParameter("password").getBytes("ISO-8859-1"),"UTF-8");
String role = request.getParameter("role");
%>

<%
// Check if the role parameter is empty or null
if (role == null || role.isEmpty()) {

    // Set an error message and forward to the login page
    request.setAttribute("message", "Role must be either student or teacher");
%>

<jsp:forward page="login.jsp"/>

<% } else {
    // Perform authentication based on the role
    if(role.equals("student")) {
        try{

            StudentService studentService = new StudentService();
            Student student = studentService.authenticate(username,password);
            session.setAttribute("studentObj", student);

            // Redirect to the student's page if credentials are valid
            response.sendRedirect("Select_language.jsp");

        }catch(Exception e) {

            // Set an error message and forward to the login page
            request.setAttribute("message", e.getMessage());
%>

        <jsp:forward page="login.jsp"/>

<% 
        }       
    } else {
        try{

            // Authenticate teacher and set session attribute
            TeacherService teacherService = new TeacherService();
            Teacher teacher = teacherService.authenticate(username,password);
            session.setAttribute("teacherObj",teacher);

            // Redirect to the teacher's page if credentials are valid
            response.sendRedirect("WelcomeTeacher.jsp");

        }catch(Exception e) {

            // Set an error message and forward to the login page
            request.setAttribute("message", e.getMessage());
%>

        <jsp:forward page="login.jsp"/>

<% 
        }
    }
}
%>
        
