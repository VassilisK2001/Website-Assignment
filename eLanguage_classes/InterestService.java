package eLanguage_classes;

import java.util.ArrayList;
import java.util.List;
import java.sql.*;

public class InterestService {

    /**
     * Adds a new student interest entry to the database.
     *
     * @param listing_id     The ID of the listing
     * @param student_id     The ID of the student expressing interest
     * @param interest_date  The date when the interest was expressed
     * @throws Exception if an error occurs during database interaction
     */

    public void addStudentInterest(int listing_id, int student_id, String interest_date) throws Exception {

        Connection con = null;

        String sql = "INSERT INTO interest(student_id,list_id,interest_date) VALUES (?,?,?);";

        DB db = new DB();
        PreparedStatement stmt = null;

        try{
            con = db.getConnection();
            stmt = con.prepareStatement(sql);
            stmt.setInt(1,student_id);
            stmt.setInt(2,listing_id);
            stmt.setString(3,interest_date);
            stmt.executeUpdate();

            stmt.close();
            db.close();
        } catch(Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            try{
                db.close();
            }catch(Exception e){

            }
        }
    }

    
    /**
     * Retrieves a list of students who have expressed interest in listings associated with a specific teacher.
     *
     * @param teacher_id The ID of the teacher
     * @return A list of Interest objects representing student interests
     * @throws Exception if an error occurs during database interaction
     */

    public List<Interest> getInterestedStudents(int teacher_id) throws Exception {

        Connection con = null;

        List<Interest> interested_students = new ArrayList<Interest>();

        String sql = 
        "SELECT " +
            "students.student_id, " +
            "students.firstName AS student_firstName, " +
            "students.lastName AS student_lastName, " +
            "students.username AS student_username, " +
            "students.password AS student_password, " +
            "students.email AS student_email, " +
            "students.age AS student_age, " +
            "regions_student.region_name AS student_region_name, " +
            "listings.list_id, " +
            "teachers.teacher_id, " +
            "teachers.firstName AS teacher_firstName, " +
            "teachers.lastName AS teacher_lastName, " +
            "teachers.age AS teacher_age, " +
            "regions_teacher.region_name AS teacher_region_name, " +
            "teachers.email AS teacher_email, " +
            "teachers.username AS teacher_username, " +
            "teachers.password AS teacher_password, " +
            "listings.experience, " +
            "listings.education, " +
            "listings.certifications, " +
            "listings.file_name, " +
            "listings.price_per_hour, " +
            "cefrlevels.cefr_name, " +
            "languages.lang_name, " +
            "interest.interest_date " +
        "FROM " +
            "students " +
        "INNER JOIN " +
            "interest ON students.student_id = interest.student_id " +
        "INNER JOIN " +
            "listings ON listings.list_id = interest.list_id " +
        "INNER JOIN " +
            "languages ON listings.lang_id = languages.lang_id " +
        "INNER JOIN " +
            "cefrlevels ON listings.cefr_id = cefrlevels.cefr_id " +
        "INNER JOIN " +
            "teachers ON teachers.teacher_id = listings.teacher_id " +
        "INNER JOIN " +
            "regions regions_student ON students.region_id = regions_student.region_id " +
        "INNER JOIN " +
            "regions regions_teacher ON teachers.region_id = regions_teacher.region_id " +
        "WHERE " +
            "teachers.teacher_id = ? " +
        "GROUP BY " +
            "students.username, listings.list_id;";


        DB db =  new DB();
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try{
            con = db.getConnection();
            stmt = con.prepareStatement(sql);
            stmt.setInt(1,teacher_id);
            rs = stmt.executeQuery();

            // Add Interest objects  to the list
            while(rs.next()){
                interested_students.add(new Interest(new Student(rs.getInt("students.student_id"),rs.getString("student_firstName"),rs.getString("student_lastName"),
                rs.getInt("student_age"),rs.getString("student_region_name"),rs.getString("student_email"),rs.getString("student_username"),rs.getString("student_password")),
                new Listing(rs.getInt("listings.list_id"), new Teacher(rs.getInt("teachers.teacher_id"),rs.getString("teacher_firstName"),rs.getString("teacher_lastName"),
                rs.getInt("teacher_age"),rs.getString("teacher_region_name"),rs.getString("teacher_email"),rs.getString("teacher_username"),rs.getString("teacher_password")),
                rs.getString("teacher_firstName"),rs.getString("languages.lang_name"),rs.getInt("listings.experience"),rs.getString("cefrlevels.cefr_name"),
                rs.getString("listings.education"),rs.getString("listings.certifications"),rs.getDouble("listings.price_per_hour")), rs.getString("interest.interest_date")));
            }

            rs.close();
            stmt.close();
            db.close();

            return interested_students;
        } catch(Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            try{
                db.close();
            } catch(Exception e) {
                
            }
        }
    }
    
}