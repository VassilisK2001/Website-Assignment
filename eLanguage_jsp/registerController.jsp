<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="eLanguage_classes.*" %>
<%@ page import="java.util.*"%>
<%@ page import="java.util.regex.*"%>
<%@ page errorPage="AppError.jsp" %>

<%
// Check if the request method is POST; otherwise, throw an exception
if(!request.getMethod().equals("POST")) {
    throw new Exception("No parameters specified. Please visit <a href='signup.jsp'>registration form</a>");
}

// Extract parameters from the request
String name = new String(request.getParameter("firstName").getBytes("ISO-8859-1"),"UTF-8");
String surname = new String(request.getParameter("lastName").getBytes("ISO-8859-1"),"UTF-8");
String agePar = request.getParameter("age");
String region = new String(request.getParameter("region").getBytes("ISO-8859-1"),"UTF-8");
String email = request.getParameter("email");
String username = new String(request.getParameter("username").getBytes("ISO-8859-1"),"UTF-8");
String password = new String(request.getParameter("password").getBytes("ISO-8859-1"),"UTF-8");
String confirm = new String(request.getParameter("confirm").getBytes("ISO-8859-1"),"UTF-8");
String role = request.getParameter("role");

// Initialize variables for validation
List<Integer> index = new ArrayList<Integer>();
int age = 0;
String age_error_msg = "";
int countErrors = 0;
boolean signup_success = false;
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE-edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/header.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/controller.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" />
    <script src="<%=request.getContextPath()%>/js/confetti.js"></script>
   
    <title>Register Controller</title>
</head>

<body>
    <header class="header">
        <div class="logo">
            <img src="<%=request.getContextPath()%>/images/Logo.png" alt="Logo">
        </div>

    </header>

<!-- Main Section for Checking Errors -->
<div class="container">

    <main class="check-for-errors">

<%
if(name.length() < 3) {
    countErrors++;
    index.add(1);
}
if(surname.length() < 3) {
    countErrors++;
    index.add(2);
}  
// Regural expression for age validation
String epattern = "-?\\d+";
Pattern pattern = Pattern.compile(epattern);
Matcher ma = pattern.matcher(agePar);

if(!ma.matches()){
    countErrors++;
    age_error_msg = "is not valid";
    index.add(3);
} else {
    age = Integer.parseInt(agePar);
    if(age < 0 || age > 100){
        countErrors++;
        age_error_msg = "is not valid";
        index.add(3);
    }
    if(role != null && !role.isEmpty() && role.equals("teacher")){
        if(age > 0 && age < 18){
            countErrors++;
            age_error_msg = "for teachers has to be at least 18 years old"; 
            index.add(3);
        }
    }
}
// Regural expression for email validation
String regex = "^[\\w!#$%&'*+/=?`{|}~^-]+(?:\\.[\\w!#$%&'*+/=?`{|}~^-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,6}";
Pattern p = Pattern.compile(regex);
Matcher m = p.matcher(email);

if(!m.matches()) {				
    countErrors++;
    index.add(4);
}

// Regural expression for username validation
String pat = "^[\\p{L}0-9_\\-!.@#$%^&*()+=]*$";
Pattern pt = Pattern.compile(pat);
Matcher mat = pt.matcher(username);

if(!mat.matches() || username.length() < 5){
    countErrors++;
    index.add(5);
}
if(password.length() < 6){
    countErrors++;
    index.add(6);
}
if(!password.equals(confirm)){
    countErrors++;
    index.add(7);
}
if(role == null || role.isEmpty()){
    countErrors++;
    index.add(8);
}
%>

<!-- Validation Logic -->
<%
// Set session timeout to 15 minutes
int sessionTimeoutSeconds = 15 * 60;
session.setMaxInactiveInterval(sessionTimeoutSeconds);

if(countErrors != 0) {
%>

<div class="message" style="background-color: #FFB833;">
    <h2>Registration form has errors!</h2>
</div>

<!-- Display error messages -->
<div class="list">
    <div class="card">
        <div class="details">
            <ol>
<% if(index.contains(1)){ %>
                <li><b>First Name</b> must be at least 3 characters long</li>
<% } if(index.contains(2)){ %>
                <li><b>Last Name</b> must be at least 3 characters long</li>
<% } if(index.contains(3)){ %>
                <li><b>Age</b> <%=age_error_msg %></li>                
<% } if(index.contains(4)){ %>
                <li><b>Email</b> is not valid</li>
<% } if(index.contains(5)){ %>
                <li><b>Username</b> must be at least 5 characters long</li>
<% } if(index.contains(6)){ %>
                <li><b>Password</b> must be at least 6 characters long</li>
<% } if(index.contains(7)){ %>
                <li><b>Password</b> and <b>Confirm</b> do not match</li>
<% } if(index.contains(8)){ %>
                <li><b>Role</b> must be either a student or a teacher</li>
            </ol>
<% } %>
        </div>
    </div>
</div>

<!-- Button to go back to the signup form -->
<button class="check-button" onclick="location.href='signup.jsp'">
    <i class="fa-solid fa-arrow-left"></i> <b>Back to form</b>
</button>

<% } else { 

    // Processing successful signup
    if(role.equals("student")){

        StudentService stserv = new StudentService();

        try{
            // Call method to check if student exists
            stserv.checkStudentExists(username, password);
        }catch(Exception e) {
            request.setAttribute("message",e.getMessage());
        %>

        <!-- Redirect to signup form if student exists-->
        <jsp:forward page = "signup.jsp" />

        <%  
        }
        // Save student to database if signup is successful
        stserv.saveStudent(name, surname, age, region, email, username, password);
        signup_success = true;

    } else {

        TeacherService teachserv = new TeacherService();

        try{
            // Call method to check if student exists
            teachserv.checkTeacherExists(username, password);
        }catch(Exception e) {
            request.setAttribute("message",e.getMessage());
        %>

        <!-- Redirect to signup form if teacher exists-->
        <jsp:forward page = "signup.jsp" />

        <%
        }
        // Save teacher to database if signup is successful
        teachserv.saveTeacher(name, surname, age, region, email, username, password);
        signup_success = true;
    } 
%>

 <!-- Display success message and user details -->
<div class="message" style="background-color: #00BFFF;">
    <h2>You have successfully signed up!</h2>
</div>

<div class="list">
    <div class="card">
        <div class="details">
            <ul>
                <li><b>First Name:</b> <%=name%></li>
                <li><b>Last name:</b> <%=surname%></li>
                <li><b>Age:</b> <%=age%></li>
                <li><b>Region:</b> <%=region%></li>
                <li><b>Email:</b> <%=email%></li>
                <li><b>Username:</b> <%=username%></li>
                <li><b>Role:</b> <%=role%></li>
            </ul>
        </div>
    </div>
</div>

 <!-- Button to go to the login form after successful registration -->
<button class="check-button" onclick="location.href='login.jsp'">
    <i class="fa-solid fa-arrow-right"></i> <b>Go to Login Form</b>
</button>

<% 
} 
%>

    </main>

</div>   
   <%@ include file="footer.jsp"%>


<!-- Confetti Animation Script if signup is successful -->
<% if (signup_success) {  %>

<script>
    // to start
   const start = () => {
    setTimeout(function(){
        confetti.start();
        },1000); //1000 = 1 second
    };
    // to stop
   const stop = () => {
    setInterval(function(){
        confetti.stop();
        },5000)
    }

    start();
    stop();

</script>

<%  }  %>
    
</body>

</html>