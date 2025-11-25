namespace MoneyWorkdesk.Services;

public interface IAuthService
{
    Task<AuthResult> LoginAsync(string email, string password, bool rememberMe);
    Task<AuthResult> RegisterAsync(RegisterRequest request);
    Task<AuthResult> LoginWithProviderAsync(string provider);
    Task LogoutAsync();
    Task<bool> IsAuthenticatedAsync();
    Task<string?> GetCurrentUserEmailAsync();
}

public class RegisterRequest
{
    public string FullName { get; set; } = "";
    public string Email { get; set; } = "";
    public string Company { get; set; } = "";
    public string Password { get; set; } = "";
    public bool AcceptTerms { get; set; }
}

public class AuthResult
{
    public bool Success { get; set; }
    public string? ErrorMessage { get; set; }
    public string? Email { get; set; }
}
