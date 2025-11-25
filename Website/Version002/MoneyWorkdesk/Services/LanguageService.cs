namespace MoneyWorkdesk.Services;

public class LanguageService
{
    public event Action? OnLanguageChanged;

    private string _currentLanguage = "en";

    public string CurrentLanguage
    {
        get => _currentLanguage;
        set
        {
            if (_currentLanguage != value)
            {
                _currentLanguage = value;
                OnLanguageChanged?.Invoke();
            }
        }
    }

    private Dictionary<string, Dictionary<string, string>> translations = new()
    {
        ["en"] = new()
        {
            ["nav.features"] = "Features",
            ["nav.pricing"] = "Pricing",
            ["nav.about"] = "About",
            ["nav.contact"] = "Contact",
            ["nav.login"] = "Login",
            ["nav.getStarted"] = "Get Started",

            ["hero.slide1.title"] = "Smart Money Operations for <span class='gradient-text'>European Business</span>",
            ["hero.slide1.subtitle"] = "Invoicing, expenses, cash flow & payments. Beautifully simple. Peppol-ready. Built for Belgium, France, Germany & beyond.",
            ["hero.slide1.cta"] = "Start Free Trial",
            ["hero.slide1.learn"] = "Learn More",

            ["hero.slide2.title"] = "Get a <span class='gradient-text'>Free 15-Min Consultation</span>",
            ["hero.slide2.subtitle"] = "Not sure where to start? Let's talk! Book a free 15-minute consultation with our money operations experts.",
            ["hero.slide2.email"] = "Email: hello@moneyworkdesk.com",
            ["hero.slide2.phone"] = "Phone: +32 2 123 4567",
            ["hero.slide2.cta"] = "Book on Calendly",

            ["hero.slide3.title"] = "<span class='gradient-text'>Peppol-Ready</span> from Day One",
            ["hero.slide3.subtitle"] = "Send & receive invoices through the European Peppol network. Automatic setup. Instant delivery. Government-compliant.",
            ["hero.slide3.cta"] = "Discover Peppol",

            ["hero.slide4.title"] = "Powerful Features.<br><span class='gradient-text'>Beautifully Simple.</span>",
            ["hero.slide4.subtitle"] = "Custom invoice layouts. Your logo. Your colors. Automated follow-ups. Payment tracking. Everything you need, nothing you don't.",
            ["hero.slide4.cta"] = "Try It Free",

            ["features.title"] = "Everything You Need to Run Your Business",
            ["features.subtitle"] = "Built specifically for European businesses with local compliance in mind",

            ["testimonials.title"] = "Trusted by European Businesses",
            ["testimonials.subtitle"] = "See what our customers are saying",

            // Login Page
            ["login.pageTitle"] = "Login",
            ["login.title"] = "Welcome back",
            ["login.subtitle"] = "Sign in to your MoneyWorkdesk account",
            ["login.email"] = "Email address",
            ["login.emailPlaceholder"] = "you@company.com",
            ["login.password"] = "Password",
            ["login.passwordPlaceholder"] = "Enter your password",
            ["login.rememberMe"] = "Remember me",
            ["login.forgotPassword"] = "Forgot password?",
            ["login.loginButton"] = "Sign in",
            ["login.loggingIn"] = "Signing in...",
            ["login.noAccount"] = "Don't have an account?",
            ["login.signUp"] = "Sign up",
            ["login.continueWithGoogle"] = "Continue with Google",
            ["login.continueWithMicrosoft"] = "Continue with Microsoft",
            ["login.orContinueWith"] = "Or continue with email",
            ["login.errorRequired"] = "Email and password are required",
            ["login.errorInvalid"] = "Invalid email or password",

            // Register Page
            ["register.pageTitle"] = "Sign Up",
            ["register.title"] = "Create your account",
            ["register.subtitle"] = "Start your free trial - no credit card required",
            ["register.fullName"] = "Full name",
            ["register.fullNamePlaceholder"] = "John Doe",
            ["register.email"] = "Email address",
            ["register.emailPlaceholder"] = "you@company.com",
            ["register.company"] = "Company name (optional)",
            ["register.companyPlaceholder"] = "Acme Inc.",
            ["register.password"] = "Password",
            ["register.passwordPlaceholder"] = "Create a password",
            ["register.passwordHint"] = "At least 8 characters",
            ["register.confirmPassword"] = "Confirm password",
            ["register.confirmPasswordPlaceholder"] = "Re-enter your password",
            ["register.acceptTermsPrefix"] = "I agree to the",
            ["register.termsLink"] = "Terms of Service",
            ["register.and"] = "and",
            ["register.privacyLink"] = "Privacy Policy",
            ["register.createButton"] = "Create account",
            ["register.creating"] = "Creating account...",
            ["register.haveAccount"] = "Already have an account?",
            ["register.login"] = "Sign in",
            ["register.continueWithGoogle"] = "Continue with Google",
            ["register.continueWithMicrosoft"] = "Continue with Microsoft",
            ["register.orContinueWith"] = "Or continue with email",
            ["register.errorRequired"] = "Please fill in all required fields",
            ["register.errorPasswordMismatch"] = "Passwords do not match",
            ["register.errorPasswordLength"] = "Password must be at least 8 characters",
            ["register.errorTerms"] = "You must accept the terms and privacy policy",
            ["register.errorInvalid"] = "Invalid email address",
        },

        ["fr"] = new()
        {
            ["nav.features"] = "Fonctionnalités",
            ["nav.pricing"] = "Tarifs",
            ["nav.about"] = "À propos",
            ["nav.contact"] = "Contact",
            ["nav.login"] = "Connexion",
            ["nav.getStarted"] = "Commencer",

            ["hero.slide1.title"] = "Opérations Financières Intelligentes pour <span class='gradient-text'>les Entreprises Européennes</span>",
            ["hero.slide1.subtitle"] = "Facturation, dépenses, trésorerie et paiements. Merveilleusement simple. Prêt pour Peppol. Conçu pour la Belgique, la France, l'Allemagne et au-delà.",
            ["hero.slide1.cta"] = "Essai Gratuit",
            ["hero.slide1.learn"] = "En Savoir Plus",

            ["hero.slide2.title"] = "Obtenez une <span class='gradient-text'>Consultation Gratuite de 15 Min</span>",
            ["hero.slide2.subtitle"] = "Vous ne savez pas par où commencer ? Parlons-en ! Réservez une consultation gratuite de 15 minutes avec nos experts.",
            ["hero.slide2.email"] = "Email : hello@moneyworkdesk.com",
            ["hero.slide2.phone"] = "Tél : +32 2 123 4567",
            ["hero.slide2.cta"] = "Réserver sur Calendly",

            ["hero.slide3.title"] = "<span class='gradient-text'>Prêt pour Peppol</span> dès le Premier Jour",
            ["hero.slide3.subtitle"] = "Envoyez et recevez des factures via le réseau européen Peppol. Configuration automatique. Livraison instantanée. Conforme.",
            ["hero.slide3.cta"] = "Découvrir Peppol",

            ["hero.slide4.title"] = "Fonctionnalités Puissantes.<br><span class='gradient-text'>Merveilleusement Simples.</span>",
            ["hero.slide4.subtitle"] = "Modèles de factures personnalisés. Votre logo. Vos couleurs. Relances automatisées. Suivi des paiements.",
            ["hero.slide4.cta"] = "Essayez Gratuitement",

            ["features.title"] = "Tout ce dont Vous Avez Besoin pour Gérer Votre Entreprise",
            ["features.subtitle"] = "Conçu spécifiquement pour les entreprises européennes avec la conformité locale à l'esprit",

            ["testimonials.title"] = "Approuvé par les Entreprises Européennes",
            ["testimonials.subtitle"] = "Découvrez ce que disent nos clients",
        },

        ["nl"] = new()
        {
            ["nav.features"] = "Functies",
            ["nav.pricing"] = "Prijzen",
            ["nav.about"] = "Over Ons",
            ["nav.contact"] = "Contact",
            ["nav.login"] = "Inloggen",
            ["nav.getStarted"] = "Begin Nu",

            ["hero.slide1.title"] = "Slimme Geldbeheer voor <span class='gradient-text'>Europese Bedrijven</span>",
            ["hero.slide1.subtitle"] = "Facturering, uitgaven, cashflow en betalingen. Verrassend eenvoudig. Peppol-klaar. Gebouwd voor België, Frankrijk, Duitsland en daarbuiten.",
            ["hero.slide1.cta"] = "Gratis Proberen",
            ["hero.slide1.learn"] = "Meer Informatie",

            ["hero.slide2.title"] = "Ontvang een <span class='gradient-text'>Gratis 15-Min Consultatie</span>",
            ["hero.slide2.subtitle"] = "Weet je niet waar te beginnen? Laten we praten! Boek een gratis consultatie van 15 minuten met onze experts.",
            ["hero.slide2.email"] = "Email: hello@moneyworkdesk.com",
            ["hero.slide2.phone"] = "Tel: +32 2 123 4567",
            ["hero.slide2.cta"] = "Boek op Calendly",

            ["hero.slide3.title"] = "<span class='gradient-text'>Peppol-Klaar</span> vanaf Dag Één",
            ["hero.slide3.subtitle"] = "Verstuur en ontvang facturen via het Europese Peppol-netwerk. Automatische installatie. Directe levering.",
            ["hero.slide3.cta"] = "Ontdek Peppol",

            ["hero.slide4.title"] = "Krachtige Functies.<br><span class='gradient-text'>Verrassend Eenvoudig.</span>",
            ["hero.slide4.subtitle"] = "Aangepaste factuurlay-outs. Uw logo. Uw kleuren. Geautomatiseerde herinneringen. Betalingen volgen.",
            ["hero.slide4.cta"] = "Probeer Gratis",

            ["features.title"] = "Alles wat U Nodig Hebt om Uw Bedrijf te Runnen",
            ["features.subtitle"] = "Speciaal gebouwd voor Europese bedrijven met lokale compliance in gedachten",

            ["testimonials.title"] = "Vertrouwd door Europese Bedrijven",
            ["testimonials.subtitle"] = "Bekijk wat onze klanten zeggen",
        },

        ["de"] = new()
        {
            ["nav.features"] = "Funktionen",
            ["nav.pricing"] = "Preise",
            ["nav.about"] = "Über Uns",
            ["nav.contact"] = "Kontakt",
            ["nav.login"] = "Anmelden",
            ["nav.getStarted"] = "Jetzt Starten",

            ["hero.slide1.title"] = "Intelligente Finanzverwaltung für <span class='gradient-text'>Europäische Unternehmen</span>",
            ["hero.slide1.subtitle"] = "Rechnungsstellung, Ausgaben, Cashflow und Zahlungen. Wunderbar einfach. Peppol-bereit.",
            ["hero.slide1.cta"] = "Kostenlos Testen",
            ["hero.slide1.learn"] = "Mehr Erfahren",

            ["hero.slide2.title"] = "Holen Sie sich eine <span class='gradient-text'>Kostenlose 15-Min Beratung</span>",
            ["hero.slide2.subtitle"] = "Nicht sicher, wo Sie anfangen sollen? Lassen Sie uns sprechen! Buchen Sie eine kostenlose 15-minütige Beratung.",
            ["hero.slide2.email"] = "Email: hello@moneyworkdesk.com",
            ["hero.slide2.phone"] = "Tel: +32 2 123 4567",
            ["hero.slide2.cta"] = "Auf Calendly buchen",

            ["hero.slide3.title"] = "<span class='gradient-text'>Peppol-Bereit</span> ab Tag Eins",
            ["hero.slide3.subtitle"] = "Senden und empfangen Sie Rechnungen über das europäische Peppol-Netzwerk.",
            ["hero.slide3.cta"] = "Peppol Entdecken",

            ["hero.slide4.title"] = "Leistungsstarke Funktionen.<br><span class='gradient-text'>Wunderbar Einfach.</span>",
            ["hero.slide4.subtitle"] = "Benutzerdefinierte Rechnungslayouts. Ihr Logo. Ihre Farben. Automatisierte Erinnerungen.",
            ["hero.slide4.cta"] = "Kostenlos Testen",

            ["features.title"] = "Alles, was Sie Brauchen, um Ihr Geschäft zu Führen",
            ["features.subtitle"] = "Speziell für europäische Unternehmen mit lokaler Compliance entwickelt",

            ["testimonials.title"] = "Vertraut von Europäischen Unternehmen",
            ["testimonials.subtitle"] = "Sehen Sie, was unsere Kunden sagen",
        },

        ["es"] = new()
        {
            ["nav.features"] = "Características",
            ["nav.pricing"] = "Precios",
            ["nav.about"] = "Acerca de",
            ["nav.contact"] = "Contacto",
            ["nav.login"] = "Iniciar Sesión",
            ["nav.getStarted"] = "Comenzar",

            ["hero.slide1.title"] = "Operaciones Financieras Inteligentes para <span class='gradient-text'>Empresas Europeas</span>",
            ["hero.slide1.subtitle"] = "Facturación, gastos, flujo de caja y pagos. Maravillosamente simple. Listo para Peppol.",
            ["hero.slide1.cta"] = "Prueba Gratuita",
            ["hero.slide1.learn"] = "Saber Más",

            ["hero.slide2.title"] = "Obtenga una <span class='gradient-text'>Consulta Gratuita de 15 Min</span>",
            ["hero.slide2.subtitle"] = "¿No sabe por dónde empezar? ¡Hablemos! Reserve una consulta gratuita de 15 minutos con nuestros expertos.",
            ["hero.slide2.email"] = "Email: hello@moneyworkdesk.com",
            ["hero.slide2.phone"] = "Tel: +32 2 123 4567",
            ["hero.slide2.cta"] = "Reservar en Calendly",

            ["hero.slide3.title"] = "<span class='gradient-text'>Listo para Peppol</span> desde el Primer Día",
            ["hero.slide3.subtitle"] = "Envíe y reciba facturas a través de la red europea Peppol. Configuración automática.",
            ["hero.slide3.cta"] = "Descubrir Peppol",

            ["hero.slide4.title"] = "Funciones Potentes.<br><span class='gradient-text'>Maravillosamente Simples.</span>",
            ["hero.slide4.subtitle"] = "Diseños de facturas personalizados. Su logo. Sus colores. Recordatorios automatizados.",
            ["hero.slide4.cta"] = "Pruébelo Gratis",

            ["features.title"] = "Todo lo que Necesita para Dirigir su Negocio",
            ["features.subtitle"] = "Creado específicamente para empresas europeas con cumplimiento local en mente",

            ["testimonials.title"] = "Confiado por Empresas Europeas",
            ["testimonials.subtitle"] = "Vea lo que dicen nuestros clientes",
        },

        ["nl-be"] = new()
        {
            ["nav.features"] = "Functies",
            ["nav.pricing"] = "Prijzen",
            ["nav.about"] = "Over Ons",
            ["nav.contact"] = "Contact",
            ["nav.login"] = "Aanmelden",
            ["nav.getStarted"] = "Start Nu",

            ["hero.slide1.title"] = "Slim Geldbe heer voor <span class='gradient-text'>Europese Bedrijven</span>",
            ["hero.slide1.subtitle"] = "Facturatie, uitgaven, cashflow en betalingen. Verrassend eenvoudig. Peppol-klaar.",
            ["hero.slide1.cta"] = "Gratis Uitproberen",
            ["hero.slide1.learn"] = "Meer Info",

            ["hero.slide2.title"] = "Ontvang een <span class='gradient-text'>Gratis 15-Min Consultatie</span>",
            ["hero.slide2.subtitle"] = "Weet u niet waar te beginnen? Laten we praten! Boek een gratis consultatie van 15 minuten.",
            ["hero.slide2.email"] = "Email: hello@moneyworkdesk.com",
            ["hero.slide2.phone"] = "Tel: +32 2 123 4567",
            ["hero.slide2.cta"] = "Boek op Calendly",

            ["hero.slide3.title"] = "<span class='gradient-text'>Peppol-Klaar</span> vanaf Dag Één",
            ["hero.slide3.subtitle"] = "Verstuur en ontvang facturen via het Europese Peppol-netwerk.",
            ["hero.slide3.cta"] = "Ontdek Peppol",

            ["hero.slide4.title"] = "Krachtige Functies.<br><span class='gradient-text'>Verrassend Eenvoudig.</span>",
            ["hero.slide4.subtitle"] = "Aangepaste factuurlay-outs. Uw logo. Uw kleuren.",
            ["hero.slide4.cta"] = "Probeer Gratis",

            ["features.title"] = "Alles wat U Nodig Hebt om Uw Bedrijf te Leiden",
            ["features.subtitle"] = "Speciaal gebouwd voor Europese bedrijven met lokale compliance",

            ["testimonials.title"] = "Vertrouwd door Europese Bedrijven",
            ["testimonials.subtitle"] = "Bekijk wat onze klanten zeggen",
        }
    };

    public string Translate(string key)
    {
        if (translations.TryGetValue(_currentLanguage, out var langDict))
        {
            if (langDict.TryGetValue(key, out var translation))
            {
                return translation;
            }
        }

        // Fallback to English
        if (translations.TryGetValue("en", out var enDict))
        {
            if (enDict.TryGetValue(key, out var translation))
            {
                return translation;
            }
        }

        return key;
    }
}
