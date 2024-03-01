document.addEventListener("DOMContentLoaded", function() {
    const togglePassword = document.querySelectorAll(".password-toggle");
    
    togglePassword.forEach(function(icon) {
        icon.addEventListener("click", function() {
            const passwordField = this.previousElementSibling;
            const type = passwordField.getAttribute("type") === "password" ? "text" : "password";
            passwordField.setAttribute("type", type);
            
            // Change icon based on password visibility
            this.querySelector("i").classList.toggle("fa-eye-slash");
        });
    });
});