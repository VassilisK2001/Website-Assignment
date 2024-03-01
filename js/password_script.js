document.addEventListener("DOMContentLoaded", function() {
    const togglePassword = document.querySelectorAll(".password-toggle");
    
    togglePassword.forEach(function(icon) {
        icon.addEventListener("click", function() {
            const passwordField = this.previousElementSibling;
            const type = passwordField.getAttribute("type") === "password" ? "text" : "password";
            passwordField.setAttribute("type", type);
            
            // Toggle eye and eye-slash icons
            const iconElement = this.querySelector("i");
            if (type === "password") {
                iconElement.classList.remove("fa-eye-slash");
                iconElement.classList.add("fa-eye");
            } else {
                iconElement.classList.remove("fa-eye");
                iconElement.classList.add("fa-eye-slash");
            }
        });
    });
});