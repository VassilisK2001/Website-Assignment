package eLanguage_classes;

import java.util.ArrayList;
import java.util.List;
import java.sql.*;

public class DBDAO {

    public List<String> getLanguages() throws Exception {

        DB db = new DB();
        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        String sql = "SELECT lang_name FROM languages;";

        List<String> languages = new ArrayList<String>();

        try{

            con = db.getConnection();
            stmt = con.prepareStatement(sql);
            rs = stmt.executeQuery();

            while(rs.next()){
                languages.add(rs.getString("lang_name"));
            }

            rs.close();
            stmt.close();
            db.close();

            return languages;
        } catch(Exception e){
            throw new Exception(e.getMessage());
        } finally {
            try{
                db.close();
            } catch(Exception e){

            }
        }
    }


    public List<String> getRegions() throws Exception {

        DB db = new DB();
        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        String sql = "SELECT region_name FROM regions ORDER BY region_name ASC;";

        List<String> regions = new ArrayList<String>();

        try{

            con = db.getConnection();
            stmt = con.prepareStatement(sql);
            rs = stmt.executeQuery();

            while(rs.next()){
                regions.add(rs.getString("region_name"));
            }

            rs.close();
            stmt.close();
            db.close();

            return regions;
        } catch(Exception e){
            throw new Exception(e.getMessage());
        } finally {
            try{
                db.close();
            } catch(Exception e){

            }
        }
    }


    public List<String> getCEFRlevels() throws Exception {

        DB db = new DB();
        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        String sql = "SELECT cefr_name FROM cefrlevels;";

        List<String> cefrlevels = new ArrayList<String>();

        try{

            con = db.getConnection();
            stmt = con.prepareStatement(sql);
            rs = stmt.executeQuery();

            while(rs.next()){
                cefrlevels.add(rs.getString("cefr_name"));
            }

            rs.close();
            stmt.close();
            db.close();

            return cefrlevels;
        } catch(Exception e){
            throw new Exception(e.getMessage());
        } finally {
            try{
                db.close();
            } catch(Exception e){

            }
        }
    }
 
}