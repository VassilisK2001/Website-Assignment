package eLanguage_classes;

public class Teacher {

    private int id;
    private String firstname;
    private String lastname;
    private int age;
    private String region;
    private String email;
    private String username;
    private String password;

public Teacher(int id, String firstname, String lastname, int age, String region, String email, String username, String password) {

    this.id = id;
    this.firstname = firstname;
    this.lastname = lastname;
    this.age = age;
    this.region = region;
    this.email = email;
    this.username = username;
    this.password = password; 
}

public int getId(){
    return id;
}

public void setId(int id){
    this.id = id;
}

public String getFirstname() {
    return firstname;
}

public void setFirstname(String firstname) {
    this.firstname = firstname;
}

public String getLastname() {
    return lastname;
}

public void setLastname(String lastname) {
    this.lastname = lastname;
}

public int getAge() {
    return age;
}

public void setAge(int age) {
    this.age = age;
}

public String getRegion() {
    return region;
}

public void setRegion(String region) {
    this.region = region;
}

public String getEmail() {
    return email;
}

public void setEmail(String email) {
    this.email = email;
}

public String getUsername() {
    return username;
}

public void setUsername(String username) {
    this.username = username;
}

public void setPassword(String password) {
    this.password = password;        
}  

public String getPassword() {
    return password;
}
    
}