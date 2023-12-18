package eLanguage_classes;

import java.util.ArrayList;
import java.util.List;
import java.sql.*;

public class TeacherService {

    public Teacher authenticate(String username, String password) throws Exception {
    
        Connection con = null;

		List<Teacher> teachers = new ArrayList<Teacher>();

		String sql = 
		"SELECT " +
		"    teachers.teacher_id, " +
		"    teachers.firstName, " +
		"    teachers.lastName, " +
		"    teachers.username, " +
		"    teachers.password, " +
		"    teachers.email, " +
		"    teachers.age, " +
		"    regions.region_name " +
		"FROM " +
		"    teachers " +
		"INNER JOIN " +
		"    regions " +
		"ON " +
		"    teachers.region_id = regions.region_id;"; 
		
		DB db = new DB();
		PreparedStatement stmt = null;
		ResultSet rs = null;

		try{
			con = db.getConnection();
			stmt = con.prepareStatement(sql);
			rs = stmt.executeQuery();

			while(rs.next()){
				teachers.add(new Teacher(rs.getInt("teachers.teacher_id"),rs.getString("teachers.firstName"),rs.getString("teachers.lastName"),rs.getInt("teachers.age"),
				rs.getString("regions.region_name"), rs.getString("teachers.email"), rs.getString("teachers.username"), rs.getString("teachers.password")));
			}

			rs.close();
			stmt.close();
			db.close();

			for (Teacher teacher: teachers) {

				if (teacher.getUsername().equals(username) && teacher.getPassword().equals(password)) {
					return teacher; // credentials are valid, so return the User object
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


	public void saveTeacher(String firstname, String lastname, int age, String region, String email, String username, String password) throws Exception{

		Connection con = null;

		String sql = "INSERT INTO teachers(firstName, lastName, username, password, email, age, region_id)" +
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

			ResultSet rs = stmt.getGeneratedKeys();

			if(rs.next()){
				id = rs.getInt(1);
				Teacher teacher = new Teacher(id, firstname , lastname , age , region , email , username , password);
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

	public void checkTeacherExists(String firstname, String lastname, int age, String region, String email, String username, String password) throws Exception {

		Connection con = null;
		String sql = 
		"SELECT " +
			"teachers.firstName, " +
			"teachers.lastName, " +
			"teachers.username, " +
			"teachers.password, " +
			"teachers.email, " +
			"teachers.age, " +
			"regions.region_name " +
		"FROM " +
			"teachers " +
		"INNER JOIN " +
			"regions " +
		"ON " +
			"teachers.region_id = regions.region_id " +
		"WHERE " +
			"teachers.firstName = ? AND " +
			"teachers.lastName = ? AND " +
			"teachers.username = ? AND " +
			"teachers.password = ? AND " +
			"teachers.email = ? AND " +
			"teachers.age = ? AND " +
			"regions.region_name = ?;";
		
		DB db = new DB();
		PreparedStatement stmt = null;
		ResultSet rs = null;

		try{
			con = db.getConnection();
			stmt = con.prepareStatement(sql);
			stmt.setString(1,firstname);
			stmt.setString(2,lastname);
			stmt.setString(3,username);
			stmt.setString(4,password);
			stmt.setString(5,email);
			stmt.setInt(6,age);
			stmt.setString(7,region);
			rs = stmt.executeQuery();

			if(rs.next()){
				throw new Exception("This teacher already exists");
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