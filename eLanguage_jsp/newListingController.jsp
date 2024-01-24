<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="eLanguage_classes.*" %>
<%@ page import="java.io.*"%>
<%@ page import="java.nio.file.Files"%>
<%@ page import="java.nio.file.Path"%>
<%@ page import="java.nio.file.StandardCopyOption"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.regex.*"%>
<%@ page import="org.apache.commons.fileupload.FileItem"%>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@ page import="org.apache.commons.io.IOUtils"%>
<%@ page errorPage="AppError.jsp" %>


<%

// Check if the request method is not POST, and whether the teacher is authenticated
if(!request.getMethod().equals("POST")){
    if(session.getAttribute("teacherObj") == null){
        throw new Exception("You are not authorized to access this resource.Please <a href='login.jsp'>sign in</a>.");
    } else {
        throw new Exception("No parameters specified.Please click <a href='CreateListing.jsp'>here</a> to create your listing.");
    }
}

// Variables for validation and error messages
List<Integer> index = new ArrayList<Integer>();
String intnum_pattern = "-?\\d+"; 
String realnum_pattern = "[-+]?\\d*\\.?\\d+";
boolean flag = false;
String message_age = "";
String language = "";
String photo = "";
String teachcomp = "";
String education = "";
String certifications = "";
double price = 0;
int age = 0;
int experience = 0;
int countErrors = 0;
boolean newlisting_success = false;

// get teacher object from session
Teacher teacher = (Teacher) session.getAttribute("teacherObj");

// create ListingService object
ListingService listserv = new ListingService();

// Check if the form is multipart (contains file uploads)
boolean isMultipart = ServletFileUpload.isMultipartContent(request);
%>

<%!  

// Helper method to count words in a string
public static int countWords(String value){
    String[] words = value.split("[\\s.,]+");
    int wordCount = words.length;
    return wordCount;
}

// Helper method to check if a string matches a given pattern
public static boolean match(String epattern, String parValue){
    Pattern pattern = Pattern.compile(epattern);
    Matcher m = pattern.matcher(parValue);
    if(!m.matches()){
        return false;
    }else {
        return true;
    }
}
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/controller.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/header.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" />
    <script src="<%=request.getContextPath()%>/js/confetti.js"></script>
    
    <title>New Listing Controller</title>
</head>

<body>
    <header class="header">
        <div class="logo">
            <img src="<%=request.getContextPath()%>/images/Logo.png" alt="Logo">
        </div>
    </header>

    <div class="container">
        <main class="check-for-errors">

<%
if(isMultipart){
            
    // Create a factory for disk-based file items
    DiskFileItemFactory factory = new DiskFileItemFactory();
            
    // Create a new file upload handler
    ServletFileUpload upload = new ServletFileUpload(factory);
            
    List<FileItem> fileItems = upload.parseRequest(request);
                
        for (FileItem item : fileItems) {
            if (item.isFormField()) {
            
                // Process regular form fields
                String fieldName = item.getFieldName();
                String fieldValue = item.getString("UTF-8");

                // Validate and compare form fields with teacher's information from registration

                if(fieldName.equals("firstName")){
                    if(!fieldValue.equals(teacher.getFirstname())){
                        countErrors++;
                        index.add(1);
                    }
                }
    
                if(fieldName.equals("lastName")){
                    if(!fieldValue.equals(teacher.getLastname())){
                        countErrors++;
                        index.add(2);
                    }
                }

                if(fieldName.equals("age")){

                    // Validate the age input using helper method
                    if(match(intnum_pattern, fieldValue) == false){
                        countErrors++;
                        index.add(3);
                        message_age = "is not valid";
                    } else {
                        age = Integer.parseInt(fieldValue);
                        if(age != teacher.getAge()){
                            countErrors++;
                            index.add(3);
                            message_age = "does not match your age";
                        }
                    }
                }

                if(fieldName.equals("region")){
                    if(!fieldValue.equals(teacher.getRegion())){
                        countErrors++;
                        index.add(4);
                    }
                }

                if(fieldName.equals("email")){
                    if(!fieldValue.equals(teacher.getEmail())){
                        countErrors++;
                        index.add(5);
                    }
                }

                if(fieldName.equals("language")){

                       // Call method from ListingService to check whether the teacher has already created a listing for the language selected.
                       flag = listserv.checkUniqueLang(teacher, fieldValue);
                        
                        if(flag == false){
                            language = fieldValue;
                        } else {
                            request.setAttribute("message","Listing with this language already exists");
                    %>

                    <!-- Redirect to new listing form -->
                    <jsp:forward page="CreateListing.jsp"/>
                <%
                    }
                }

                if(fieldName.equals("experience")){

                    // Use helper method to validate years of experience 
                    if(match(intnum_pattern,fieldValue) == false){
                        countErrors++;
                        index.add(6);
                    } else {
                        experience = Integer.parseInt(fieldValue);
                        if(experience < 0 || experience > 90){
                            countErrors++;
                            index.add(6);
                        }
                    }
                }

                if(fieldName.equals("teachcomp")){
                    teachcomp = fieldValue;
                }

                if(fieldName.equals("education")){

                    // Use helper method to ensure derired length of education field
                    if(countWords(fieldValue) < 3 || countWords(fieldValue) > 50){
                        countErrors++;
                        index.add(7);
                    } else {
                        education = fieldValue;
                    }
                }

                if(fieldName.equals("certifications")){

                    // Use helper method to ensure derired length of certifications field if provided by the teacher
                    if(fieldValue != null && fieldValue.length() >= 1){
                        if(countWords(fieldValue) < 2 || countWords(fieldValue) > 50){
                            countErrors++;
                            index.add(8);
                        } else {
                            certifications = fieldValue;
                        }
                    }
                }

                if(fieldName.equals("pricePerHour")){

                    // Use helper method to validate input for pricePerHour field
                    if(match(realnum_pattern,fieldValue) == false){
                        countErrors++;
                        index.add(9);
                    } else {
                        price = Double.parseDouble(fieldValue);
                        if(price < 0 || price > 100){
                            countErrors++;
                            index.add(9);
                        }
                    }
                }

            } else {
            
                // Process file upload
                String fieldName = item.getFieldName();
                String fileName = item.getName();
                photo = fileName;
                InputStream fileContent = item.getInputStream();
            
                // Save the file to images directory in server
                String uploadDirectory = "C:\\Program Files\\Apache Software Foundation\\Tomcat 6.0\\webapps\\ismgroup3\\images";
            
                // Construct the destination file path
                String filePath = uploadDirectory + File.separator + fileName;
            
                // Copy the input stream to the destination file
                OutputStream fileOut = new FileOutputStream(new File(filePath));
                IOUtils.copy(fileContent, fileOut);
            
                if (fileOut != null) {
                    fileOut.close();
                }
                
            }
        }
    }        
%>

<%
// Set session timeout to 15 minutes
int sessionTimeoutSeconds = 15 * 60;
session.setMaxInactiveInterval(sessionTimeoutSeconds);

// Check for validation errors and display appropriate messages
if(countErrors != 0){
%>

<div class="message" style="background-color: #FFB833;">
    <h2>New Listing form has errors!</h2>
</div>

<div class="list">
    <div class="card">
        <div class="details">
            <ol>
<% if(index.contains(1)){ %>
                <li>Enter your <b>First Name</b> correctly</li>
<% } if(index.contains(2)){ %>
                <li>Enter your <b>Last Name</b> correctly</li>
<% } if(index.contains(3)){ %>
                <li><b>Age</b> <%=message_age%></li>
<% } if(index.contains(4)){ %>
                <li>Enter your <b>Region</b> correctly</li>                
<% } if(index.contains(5)){ %>
                <li>Enter your <b>Email</b> correctly</li>
<% } if(index.contains(6)){ %>
                <li><b>Experience</b> is not valid</li>
<% } if(index.contains(7)){ %>
                <li><b>Education</b> must be between 3 and 50 words</li>
<% } if(index.contains(8)){ %>
                <li><b>Certifications</b> must be between 2 and 50 words</li>
<% } if(index.contains(9)){ %>
                <li><b>Price per hour</b> is not valid</li>
            </ol>
<% } %>
        </div>
    </div>
</div>

<!-- Button to go back to the form if new listing form has errors -->
<button class="check-button" onclick="location.href='CreateListing.jsp'">
    <i class="fa-solid fa-arrow-left"></i> <b>Back to form</b>
</button>

<% } else {

    // If no errors, save the listing in the database and show success message
    listserv.saveListing(teacher,photo,language,experience,teachcomp,education,certifications,price);
    newlisting_success = true;
%>
        
        <div class="message" style="background-color: #00BFFF;">
            <h2>Your listing was successfully created!</h2>
        </div>

        <div class="details">
            
        </div>

        <!-- Button to check the new listing in other page -->
        <button class="check-button" onclick="location.href='MyListings.jsp'">
            <i class="fa-solid fa-arrow-right"></i> <b>Check your new listing here</b>
        </button>
    
<% } %>

        </main>
    </div>

    <%@ include file="footer.jsp"%>

    <% if (newlisting_success) {  %>

        <!-- JavaScript to generate animated confetti if the new listing is successfully created -->
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