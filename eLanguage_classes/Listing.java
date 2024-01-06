package eLanguage_classes;

public class Listing {
    
    private int id;
    private Teacher creator;  // The Teacher object representing the creator of the listing
    private String file_name; // The name of the file associated with the photo of the lteacher who creates the listing
    private String language;  // The foreign language that the teacher wants to teach
    private int experience;   // Years of experience teaching the foreign language 
    private String teach_comp; // Teaching Competency ranging from A1 to C2 level
    private String education;  // Abrief description related to teacher's education
    private String certifications; // Additional certifications if the teacher has any
    private double price;  // Price per hour defined by the teacher for private lessons 

    public Listing(int id, Teacher creator, String file_name, String language, int experience, String teach_comp, String education, String certifications, double price){
        
        this.id = id;
        this.creator = creator;
        this.file_name = file_name;
        this.language = language;
        this.experience = experience;
        this.teach_comp = teach_comp;
        this.education = education;
        this.certifications = certifications;
        this.price = price;
    }

    public int getId(){
        return id;
    }

    public void setId(int id){
        this.id = id;
    }

    public Teacher getCreator(){
        return creator;
    }

    public void setCreator(Teacher creator){
        this.creator = creator;
    }

    public String getFileName(){
        return file_name;
    }

    public void setFileName(String file_name){
        this.file_name = file_name;
    }

    public String getLanguage(){
        return language;
    }

    public void setLanguage(String language){
        this.language = language;
    }

    public int getExperience(){
        return experience;
    }

    public void setExperience(int experience){
        this.experience = experience;
    }

    public String getTeachComp(){
        return teach_comp;
    }

    public void setTeachComp(String teach_comp){
        this.teach_comp = teach_comp;
    }

    public String getEducation(){
        return education;
    }

    public void setEducation(String education){
        this.education = education;
    }

    public String getCertifications(){
        return certifications;
    }

    public void setCertifications(String certifications){
        this.certifications = certifications;
    }

    public double getPrice(){
        return price;
    }

    public void setPrice(double price){
        this.price = price;
    }
   
}