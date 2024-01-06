package eLanguage_classes;

import java.util.ArrayList;
import java.util.List;
import java.sql.*;

public class StudentService {

	
    /**
     * Authenticates a student based on the provided username and password.
     *
     * @param username Student's username
     * @param password Student's password
     * @return Authenticated student
     * @throws Exception if an error occurs during authentication
     */

    public Student authenticate(String username, String password) throws Exception {
    
		Connection con = null;

		// List to store retrieved students
		List<Student> students = new ArrayList<Student>();

		String sql = 
		"SELECT " +
		"    students.student_id, " +
		"    students.firstName, " +
		"    students.lastName, " +
		"    students.username, " +
		"    students.password, " +
		"    students.email, " +
		"    students.age, " +
		"    regions.region_name " +
		"FROM " +
		"    students " +
		"INNER JOIN " +
		"    regions " +
		"ON " +
		"    students.region_id = regions.region_id;"; 
		
		DB db = new DB();
		PreparedStatement stmt = null;
		ResultSet rs = null;

		try{
			con = db.getConnection();
			stmt = con.prepareStatement(sql);
			rs = stmt.executeQuery();

			// Populate the list with student objects
			while(rs.next()){
				students.add(new Student(rs.getInt("students.student_id"),rs.getString("students.firstName"),rs.getString("students.lastName"),rs.getInt("students.age"),
				rs.getString("regions.region_name"), rs.getString("students.email"), rs.getString("students.username"), rs.getString("students.password")));
			}

			rs.close();
			stmt.close();
			db.close();

			// Check if the provided username and password match any student in the list
			for (Student student: students) {

				if (student.getUsername().equals(username) && student.getPassword().equals(password)) {
					return student; // credentials are valid, so return the User object
				}
	
			}
			//credentials are Wrong, so throw an error
			throw new Exception("Wrong username or password");	
		} catch(Exception e){
			throw new Exception(e.getMessage());
		}finally{
			try {
                db.close();
            } catch (Exception e) {

            }
		}

    } // End of authenticate


	
    /**
     * Saves a new student to the database.
     *
     * @param firstname Student's first name
     * @param lastname  Student's last name
     * @param age       Student's age
     * @param region    Student's region
     * @param email     Student's email
     * @param username  Student's username
     * @param password  Student's password
     * @throws Exception if an error occurs during the save operation
     */

	public void saveStudent(String firstname, String lastname, int age, String region, String email, String username, String password) throws Exception{

		Connection con = null;

		String sql = "INSERT INTO students(firstName, lastName, username, password, email, age, region_id)" +
		             "VALUES (?,?,?,?,?,?, (SELECT region_id FROM regions WHERE region_name = ?));";

		DB db = new DB();
	    PreparedStatement stmt = null;

		int id = 0;

		try{
			con = db.getConnection();
			stmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
			stmt.setString(1,firstname);
			stmt.setString(2,lastname);
			stmt.setString(3,username);
			stmt.setString(4,password);
			stmt.setString(5,email);
			stmt.setInt(6,age);
			stmt.setString(7,region);
			stmt.executeUpdate();

			// Retrieve the generated keys to obtain the student's ID
			ResultSet rs = stmt.getGeneratedKeys();

			if(rs.next()){
				id = rs.getInt(1);
				Student student = new Student(id,firstname,lastname,age,region,email,username,password);
			}

			rs.close();
			stmt.close();
			db.close();
		} catch(Exception e) {
			throw new Exception(e.getMessage());
		}finally{
			try{
				db.close();
			}catch(Exception e){

			}
		}			
	}

	/**
     * Checks if a student with the given username or password already exists in the database.
     *
     * @param username Student's username
     * @param password Student's password
     * @throws Exception if a student with the provided username or password already exists
     */

	public void checkStudentExists(String username, String password) throws Exception {

		Connection con = null;
		String sql = 
		"SELECT * FROM students WHERE username=? OR password=?; ";
			

		DB db = new DB();
		PreparedStatement stmt = null;
		ResultSet rs = null;

		try{
			con = db.getConnection();
			stmt = con.prepareStatement(sql);
			stmt.setString(1,username);
			stmt.setString(2,password);
			rs = stmt.executeQuery();

			// If a student is found, throw an exception
			if(rs.next()){
				throw new Exception("Student with this username or password already exists.");
			}

			rs.close();
			stmt.close();
			db.close();
		} catch(Exception e) {
			throw new Exception(e.getMessage());
		} finally {
			try{
				db.close();
			} catch(Exception e){

			}
		}
	}
}