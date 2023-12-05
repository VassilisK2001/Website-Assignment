<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="eLanguage_classes.*" %>
<%@ page import="java.util.*"  %>
<%@ page errorPage="AppError.jsp" %>

<%   
DBDAO dbdao = new DBDAO();
List<String> regions = dbdao.getRegions();
%>


<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/signUp.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/header.css">

    <title>Signup Page</title>
</head>

<body>

        <header class="header">
            <div class="logo">
                <img src="<%=request.getContextPath()%>/images/Logo.png" alt="Logo">
                </div>
            <nav class="nav-menu">
                <a href="Index.jsp">About</a>
                <a href="signup.jsp" class="active">Register</a>
                <a href="login.jsp">Sign In</a>
            </nav>
        </header>

        <% if (request.getAttribute("message") != null) { %>

            <div class="message">
                <h2><%=(String) request.getAttribute("message")%></h2>
            </div>
            
        <% } %>
    
        <div class="inner-container">
            <h1>Create Account</h1>
            <form action="registerController.jsp" method="post" accept-charset="UTF-8" class="form-horizontal">
                <div class="name-group">
                    <div class="form-group">
                        <label  for="firstName">First Name:</label>
                        <input type="text" id="firstName" placeholder="Enter your first name" name="firstName" class="name-input" required>
                    </div>
                    <div class="form-group">
                        <label for="lastName">Last Name:</label>
                        <input type="text" id="lastName" placeholder="Enter your last name" name="lastName" class="name-input" required>
                    </div>
                </div>
                <div class="name-group">
                    <div class="form-group">
                        <div class="age">
                            <label  for="age">Age:</label>
                            <input type="text" id="age" placeholder="Enter your age" name="age" class="name-input" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="region">
                            <label for="region">Region:</label>
                                <select id="region" name="region" required>

                                    <% for(String region: regions) { %>

                                    <option value="<%=region%>"><%=region%></option>
                                    
                                    <%  } %>
                                </select>
                        </div>
                        
                    </div> 
                </div>

                <div class="form-group">
                    <label for="email">Email:</label>
                    <input type="email" id="email" placeholder="Enter your email" name="email" class="cred-input" required>
                </div>
                <div class="form-group">
                    <label for="username">Username:</label>
                    <input type="text" id="username" placeholder="Enter your username" name="username" class="cred-input" required>
                </div>
                <div class="form-group">
                    <label for="password">Password:</label>
                    <input type="password" id="password" placeholder="Enter your password" name="password" class="cred-input" required>
                </div>
                <div class="form-group">
                    <label for="confirm">Confirm:</label>
                    <input type="password" id="confirm" placeholder="Confirm your password" name="confirm" class="cred-input" required>
                </div>
                <div class="form-group">
                    <label for="role">Role:</label>
                    <div class="checkbox-group">
                        <label>
                            <input type="checkbox" id="student" name="role" value="student">
                            Student
                        </label>
                        <label>
                            <input type="checkbox" id="teacher" name="role" value="teacher">
                            Teacher
                        </label> 
                    </div>
                </div>
                <button type="submit" class="create-account-btn">Create Account</button>
            </form>
        </div>

        <%@ include file="footer.jsp"%>

</body>

</html>




