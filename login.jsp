<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="eLanguage_classes.*" %>
<%@ page errorPage="AppError.jsp" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/login.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/header.css">

    <title>SignIn Page</title>
</head>

<body>

        <header class="header">
            <div class="logo">
                <img src="<%=request.getContextPath()%>/images/Logo.png" alt="Logo">
            </div>
            <nav class="nav-menu">
                <a href="Index.jsp">About</a>
                <a href="signup.jsp">Register</a>
                <a href="login.jsp" class="active">Sign In</a>
            </nav>
        </header>

<% if (request.getAttribute("message") != null) { %>

        <div class="message">
            <h2><%=(String) request.getAttribute("message")%></h2>
        </div>
<% } %>

        <div class="inner-container">
            <h1>Sign In</h1>
            <form action="loginController.jsp" method="post" accept-charset="UTF-8" class="form-horizontal">
              <div class="form-group">
                <label for="username">Username:</label>
                <input type="text" id="username" placeholder="Enter your username" name="username" class="cred-input" required>
            </div>
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" placeholder="Enter your password" name="password" class="cred-input" required>
            </div>
            <div class="form-group">
                <label for="role">Role:</label>
                <div class="radio-group">
                    <label>
                        <input type="radio" id="student" name="role" value="student">
                        Student
                    </label>
                    <label>
                        <input type="radio" id="teacher" name="role" value="teacher">
                        Teacher
                    </label> 
                </div>
            </div>
            <button type="submit" class="login-btn">Sign In</button>
            </form>
        </div>

        <%@ include file="footer.jsp"%>

</body>

</html>




