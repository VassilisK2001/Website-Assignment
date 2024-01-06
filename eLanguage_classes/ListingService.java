package eLanguage_classes;

import java.util.ArrayList;
import java.util.List;
import java.sql.*;

public class ListingService {

    
    /**
     * Saves a new listing to the database.
     *
     * @param teacher        Teacher associated with the listing
     * @param file_name      File name of the listing
     * @param language       Language of the listing
     * @param experience     Experience required for the listing
     * @param cefr           CEFR level of the listing
     * @param education      Education level required for the listing
     * @param certifications Certifications required for the listing
     * @param price          Price per hour for the listing
     * @throws Exception if an error occurs during the save operation
     */

    public void saveListing(Teacher teacher, String file_name, String language, int experience, String cefr, String education, String certifications, double price ) 
    throws Exception{

		Connection con = null;

         // SQL query to insert a new listing into the database
		String sql = "INSERT INTO listings(experience,education,price_per_hour,certifications,file_name,teacher_id,lang_id,cefr_id)" +
		             "VALUES (?,?,?,?,?,?, (SELECT lang_id FROM languages WHERE lang_name = ?), (SELECT cefr_id FROM cefrlevels WHERE cefr_name = ?));";

		DB db = new DB();
	    PreparedStatement stmt = null;

		int id = 0;

		try{
			con = db.getConnection();
			stmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
			stmt.setInt(1,experience);
			stmt.setString(2,education);
			stmt.setDouble(3,price);
			stmt.setString(4,certifications);
			stmt.setString(5,file_name);
			stmt.setInt(6,teacher.getId());
			stmt.setString(7,language);
            stmt.setString(8,cefr);
			stmt.executeUpdate();

            // Retrieve the generated keys to obtain the listing's ID
			ResultSet rs = stmt.getGeneratedKeys();

			if(rs.next()){
				id = rs.getInt(1);
				Listing listing = new Listing(id,teacher,file_name,language,experience,cefr,education,certifications,price);
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

    //MyListings.jsp method

    /**
     * Retrieves listings associated with a specific teacher.
     *
     * @param teacher Teacher for whom listings are retrieved
     * @return List of listings associated with the teacher
     * @throws Exception if an error occurs during the retrieval
     */
    public List<Listing> getTeacherListings(Teacher teacher) throws Exception{

        Connection con = null;

        String sql = "SELECT "
        + "listings.list_id, "
        + "teachers.teacher_id, "
        + "teachers.firstName, "
        + "teachers.lastName, "
        + "teachers.age, "
        + "regions.region_name, "
        + "teachers.email, "
        + "teachers.username, "
        + "teachers.password, "
        + "listings.file_name, "
        + "languages.lang_name, "
        + "listings.experience, "
        + "cefrlevels.cefr_name, "
        + "listings.education, "
        + "listings.certifications, "
        + "listings.price_per_hour "
        + "FROM teachers "
        + "INNER JOIN regions ON regions.region_id = teachers.region_id "
        + "INNER JOIN listings ON teachers.teacher_id = listings.teacher_id "
        + "INNER JOIN languages ON listings.lang_id = languages.lang_id "
        + "INNER JOIN cefrlevels ON listings.cefr_id = cefrlevels.cefr_id "
        + "WHERE teachers.teacher_id = ?;";

        DB db = new DB();
        PreparedStatement stmt = null;
        ResultSet rs = null;

        List<Listing> teacher_listings = new ArrayList<Listing>();

        try{
            // open connection and get Connection object
            con = db.getConnection();

            stmt = con.prepareStatement(sql);

            stmt.setInt(1, teacher.getId());
            
            // execute the SQL statement (QUERY - SELECT) and get the results in a ResultSet)
             rs = stmt.executeQuery();

             // Populate the list with Listing objects
            while(rs.next()){
                teacher_listings.add(new Listing(rs.getInt("listings.list_id"),new Teacher(rs.getInt("teachers.teacher_id"),rs.getString("teachers.firstName"),rs.getString("teachers.lastName"),
                rs.getInt("teachers.age"),rs.getString("regions.region_name"), rs.getString("teachers.email"),rs.getString("teachers.username"),rs.getString("teachers.password")),
                rs.getString("listings.file_name"),rs.getString("languages.lang_name"),rs.getInt("listings.experience"), rs.getString("cefrlevels.cefr_name"),
                rs.getString("listings.education"),  rs.getString("listings.certifications"),rs.getDouble("listings.price_per_hour"))); 
            }

            rs.close(); // closing ResultSet
			stmt.close(); // closing PreparedStatement
			db.close(); // closing connection

            return teacher_listings;


        }catch(Exception e){
            throw new Exception(e.getMessage());

        }finally{
            try {
                db.close();
           } catch (Exception e) {

           }
        }
	} 

    //newListingController.jsp method

    /**
     * Checks if a teacher has already created a listing for a specific language.
     *
     * @param teacher  Teacher to check for
     * @param language Language to check uniqueness
     * @return True if the language is already exists in a listing created by the teacher, false otherwise
     * @throws Exception if an error occurs during the check
     */

    public boolean checkUniqueLang(Teacher teacher, String language) throws Exception{

        Connection con = null;

        boolean flag = false;

        // SQL query to count how many times a language appears in listings created by the teacher
        String sql = "SELECT COUNT(listings.lang_id) "
        +"FROM listings "
        +"INNER JOIN languages ON listings.lang_id = languages.lang_id "
        +"WHERE listings.teacher_id = ?  AND languages.lang_id = (SELECT lang_id FROM languages WHERE lang_name = ?);";

        DB db = new DB();
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try{
            con = db.getConnection();
            stmt = con.prepareStatement(sql);
            stmt.setInt(1,teacher.getId());
            stmt.setString(2, language);
            rs = stmt.executeQuery();

            if(rs.next()){

                // If the language already appears in one of teacher's listings return true, otherwise false
                if(rs.getInt("COUNT(listings.lang_id)") >= 1){
                    flag = true;
                } 
            }

            rs.close();
			stmt.close();
			db.close();

            return flag;

        } catch(Exception e){
            throw new Exception(e.getMessage());
        }finally{
            try {
                db.close();
            } catch (Exception e) {

            }
        }   
    }

    //ListingsByLanguage.jsp

     /**
     * Retrieves listings associated with a specific language.
     *
     * @param language Language for which listings are retrieved
     * @return List of listings associated with the language
     * @throws Exception if an error occurs during the retrieval
     */

    public List<Listing> getLangListings(String language) throws Exception{

        Connection con = null;

        List<Listing> lang_listings = new ArrayList<Listing>();

        String sql = "SELECT "
        + "listings.list_id, "
        + "teachers.teacher_id, "
        + "teachers.firstName, "
        + "teachers.lastName, "
        + "teachers.age, "
        + "regions.region_name, "
        + "teachers.email, "
        + "teachers.username, "
        + "teachers.password, "
        + "listings.file_name, "
        + "languages.lang_name, "
        + "listings.experience, "
        + "cefrlevels.cefr_name, "
        + "listings.education, "
        + "listings.certifications, "
        + "listings.price_per_hour "
        + "FROM teachers "
        + "INNER JOIN regions ON regions.region_id = teachers.region_id "
        + "INNER JOIN listings ON teachers.teacher_id = listings.teacher_id "
        + "INNER JOIN languages ON listings.lang_id = languages.lang_id "
        + "INNER JOIN cefrlevels ON listings.cefr_id = cefrlevels.cefr_id "
        + "WHERE languages.lang_name = ?;";

        DB db = new DB();
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try{
            con = db.getConnection();
            stmt = con.prepareStatement(sql);
            stmt.setString(1, language);
            rs = stmt.executeQuery();

            // Populate the list with Listing objects
            while(rs.next()){

                lang_listings.add(new Listing(rs.getInt("listings.list_id"),new Teacher(rs.getInt("teachers.teacher_id"),rs.getString("teachers.firstName"),rs.getString("teachers.lastName"),
                rs.getInt("teachers.age"),rs.getString("regions.region_name"), rs.getString("teachers.email"),rs.getString("teachers.username"),rs.getString("teachers.password")),
                rs.getString("listings.file_name"),rs.getString("languages.lang_name"),rs.getInt("listings.experience"), rs.getString("cefrlevels.cefr_name"),
                rs.getString("listings.education"),  rs.getString("listings.certifications"),rs.getDouble("listings.price_per_hour")));
            }

            rs.close();
			stmt.close();
			db.close();

            return lang_listings;

        } catch(Exception e){
            throw new Exception(e.getMessage());
        }finally{
            try {
                db.close();
            } catch (Exception e) {

            }
        }   
    }  

    /**
     * Deletes a listing from the database.
     *
     * @param listingId ID of the listing to be deleted
     * @throws Exception if an error occurs during the deletion
     */

    public void deleteListing(int listingId) throws Exception {

        Connection con = null;

        // First delete the ID of the listing from the table interest, where it is stored as foreign key
        String sql1 = "DELETE FROM interest WHERE list_id = ?;";

        // Then delete the ID of the listing from the listings table
        String sql2 = "DELETE FROM listings WHERE list_id = ?;";

        DB db = new DB();
        PreparedStatement stmt1 = null;
        PreparedStatement stmt2 = null;

        try{
            con = db.getConnection();
            stmt1 = con.prepareStatement(sql1);
            stmt1.setInt(1,listingId);
            stmt1.executeUpdate();
            stmt2 = con.prepareStatement(sql2);
            stmt2.setInt(1,listingId);
            stmt2.executeUpdate();

            stmt1.close();
            stmt2.close();
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
}