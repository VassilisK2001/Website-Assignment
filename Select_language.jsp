<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="eLanguage_classes.*" %>
<%@ page import="java.util.*"  %>
<%@ page errorPage="AppError.jsp" %>

<%
if(session.getAttribute("studentObj") == null){
    request.setAttribute("message","You are not authorized to access this page. Please sign in.");

%>
<jsp:forward page="login.jsp"/>
<%
}
Student student = (Student) session.getAttribute("studentObj");

DBDAO dbdao =  new DBDAO();

List<String> languages = dbdao.getLanguages();

%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE-edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/selectLang.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/header.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" />
   
    <title>Select Language</title>
</head>

<body>
    <header class="header">
        <div class="logo">
            <img src="<%=request.getContextPath()%>/images/Logo.png" alt="Logo">
        </div>
        <nav class="nav-menu">
            <span class="signed-in-info">Signed in as <%=student.getUsername()%></span>
            <a href="Index.jsp">About</a>
            <a href="logout.jsp"><span><i class="fas fa-arrow-right-from-bracket"></i></span>Log Out</a>
            
        </nav>
    </header>

        <div class="container">
            <p class="language-question">Which language do you want to learn?</p>
            <form action="ListingsByLanguage.jsp" method="post" class="form-horizontal">
                <select id="language" name="language">

                    <% for (String language: languages) { %>

                    <option value="<%= language %>"><%= language%></option>

                    <%  } %>
                    
                </select>
                <button type="submit">Search</button>
            </form>
        </div>
    
   <%@ include file="footer.jsp"%>
    
</body>

</html>




