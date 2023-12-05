<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="eLanguage_classes.*" %>
<%@ page errorPage="AppError.jsp" %>

<%
if(!request.getMethod().equals("POST")){
    throw new Exception("You are not authorized to access this resource.Please <a href='login.jsp'>sign in</a>.");
}

String username = new String(request.getParameter("username").getBytes("ISO-8859-1"),"UTF-8");
String password = new String(request.getParameter("password").getBytes("ISO-8859-1"),"UTF-8");
String role[] = request.getParameterValues("role");
%>

<%
if ((role == null || role.length == 0) || (role.length > 1)) {

    request.setAttribute("message", "Role must be either student or teacher");
%>

<jsp:forward page="login.jsp"/>

<%} else {
    if(role[0].equals("student")) {
        try{

            StudentService studentService = new StudentService();
            Student student = studentService.authenticate(username,password);
            session.setAttribute("studentObj", student);
            response.sendRedirect("Select_language.jsp");

        }catch(Exception e) {

            request.setAttribute("message", e.getMessage());
%>

        <jsp:forward page="login.jsp"/>

<% 
        }       
    } else {
        try{

            TeacherService teacherService = new TeacherService();
            Teacher teacher = teacherService.authenticate(username,password);
            session.setAttribute("teacherObj",teacher);
            response.sendRedirect("WelcomeTeacher.jsp");

        }catch(Exception e) {

            request.setAttribute("message", e.getMessage());
%>

        <jsp:forward page="login.jsp"/>

<% 
        }
    }
}
%>
        
