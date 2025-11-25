using Microsoft.JSInterop;

namespace MoneyWorkdesk.Services;

public class AuthService : IAuthService
{
    private readonly IJSRuntime _js;
    private readonly LanguageService _langService;

    public AuthService(IJSRuntime js, LanguageService langService)
    {
        _js = js;
        _langService = langService;
    }

    public async Task<AuthResult> LoginAsync(string email, string password, bool rememberMe)
    {
        // Simulate API call delay
        await Task.Delay(1000);

        // Validate input
        if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(password))
        {
            return new AuthResult
            {
                Success = false,
                ErrorMessage = _langService.Translate("login.errorRequired")
            };
        }

        // Demo validation - accept any valid email format with password length >= 6
        // In production, this would call your authentication API
        if (email.Contains("@") && password.Length >= 6)
        {
            // Store user session
            await _js.InvokeVoidAsync("localStorage.setItem", "user", email);
            if (rememberMe)
            {
                await _js.InvokeVoidAsync("localStorage.setItem", "rememberMe", "true");
            }

            return new AuthResult
            {
                Success = true,
                Email = email
            };
        }

        return new AuthResult
        {
            Success = false,
            ErrorMessage = _langService.Translate("login.errorInvalid")
        };
    }

    public async Task<AuthResult> RegisterAsync(RegisterRequest request)
    {
        // Simulate API call delay
        await Task.Delay(1000);

        // Validate required fields
        if (string.IsNullOrWhiteSpace(request.FullName) ||
            string.IsNullOrWhiteSpace(request.Email) ||
            string.IsNullOrWhiteSpace(request.Password))
        {
            return new AuthResult
            {
                Success = false,
                ErrorMessage = _langService.Translate("register.errorRequired")
            };
        }

        // Validate email format
        if (!request.Email.Contains("@"))
        {
            return new AuthResult
            {
                Success = false,
                ErrorMessage = _langService.Translate("register.errorInvalid")
            };
        }

        // Validate password length
        if (request.Password.Length < 8)
        {
            return new AuthResult
            {
                Success = false,
                ErrorMessage = _langService.Translate("register.errorPasswordLength")
            };
        }

        // Validate terms acceptance
        if (!request.AcceptTerms)
        {
            return new AuthResult
            {
                Success = false,
                ErrorMessage = _langService.Translate("register.errorTerms")
            };
        }

        // Demo: Accept registration
        // In production, this would call your registration API
        await _js.InvokeVoidAsync("localStorage.setItem", "user", request.Email);
        await _js.InvokeVoidAsync("localStorage.setItem", "userName", request.FullName);

        if (!string.IsNullOrWhiteSpace(request.Company))
        {
            await _js.InvokeVoidAsync("localStorage.setItem", "userCompany", request.Company);
        }

        return new AuthResult
        {
            Success = true,
            Email = request.Email
        };
    }

    public async Task<AuthResult> LoginWithProviderAsync(string provider)
    {
        // In production, this would redirect to OAuth provider
        // For now, just show an alert
        await _js.InvokeVoidAsync("alert", $"Login with {provider} coming soon!");

        return new AuthResult
        {
            Success = false,
            ErrorMessage = "OAuth login not yet implemented"
        };
    }

    public async Task LogoutAsync()
    {
        await _js.InvokeVoidAsync("localStorage.removeItem", "user");
        await _js.InvokeVoidAsync("localStorage.removeItem", "userName");
        await _js.InvokeVoidAsync("localStorage.removeItem", "userCompany");
        await _js.InvokeVoidAsync("localStorage.removeItem", "rememberMe");
    }

    public async Task<bool> IsAuthenticatedAsync()
    {
        try
        {
            var user = await _js.InvokeAsync<string?>("localStorage.getItem", "user");
            return !string.IsNullOrEmpty(user);
        }
        catch
        {
            return false;
        }
    }

    public async Task<string?> GetCurrentUserEmailAsync()
    {
        try
        {
            return await _js.InvokeAsync<string?>("localStorage.getItem", "user");
        }
        catch
        {
            return null;
        }
    }
}
