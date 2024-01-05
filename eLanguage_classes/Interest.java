package eLanguage_classes;

public class Interest {

    private Student student;
    private Listing listing;
    private String interest_date;
    
    public Interest(Student student,Listing listing, String interest_date) {
        this.student = student;
        this.listing = listing;
        this.interest_date = interest_date;
    }

    public Student getStudent(){
        return student;
    }

    public void setStudent(Student student){
        this.student = student;
    }

    public void setListing(Listing listing){
        this.listing = listing;
    }

    public Listing getListing(){
        return listing;
    }

    public String getInterestDate(){
        return interest_date;
    }

    public void setInterestDate(String interest_date){
        this.interest_date = interest_date;
    }

}



