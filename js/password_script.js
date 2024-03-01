document.addEventListener('DOMContentLoaded', function() {
    const togglePassword = document.querySelector('#togglePassword');
    const password = document.querySelector('#password');

    togglePassword.addEventListener('click', function() {
        const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
        password.setAttribute('type', type);

        if (type === 'password') {
            togglePassword.querySelector('i').classList.remove('fa-eye-slash');
            togglePassword.querySelector('i').classList.add('fa-eye');
        } else {
            togglePassword.querySelector('i').classList.remove('fa-eye');
            togglePassword.querySelector('i').classList.add('fa-eye-slash');
        }
    });
});