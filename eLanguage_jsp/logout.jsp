<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page errorPage="AppError.jsp" %>

<%     
session.invalidate();
%>


<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="refresh" content="2;url=Index.jsp"/>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/logout.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/header.css">

    <title>LogOut Page</title>
</head>

<body>

        <header class="header">
            <div class="logo">
                <img src="<%=request.getContextPath()%>/images/Logo.png" alt="Logo">
            </div>
        </header>
        
        <div class="message">
            <h2>You have successfully signed out</h2>
        </div>
        
        <%@ include file="footer.jsp"%>

</body>

</html>




