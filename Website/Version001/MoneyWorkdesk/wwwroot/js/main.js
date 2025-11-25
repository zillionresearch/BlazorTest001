/**
 * MoneyWorkdesk - Main Application Script
 * Handles theme toggling, language switching, mobile menu, and interactive elements
 */

class MoneyWorkdeskApp {
    constructor() {
        this.themeToggle = document.getElementById('themeToggle');
        this.langBtn = document.getElementById('langBtn');
        this.langDropdown = document.querySelector('.lang-dropdown');
        this.mobileMenuToggle = document.getElementById('mobileMenuBtn');
        this.mobileMenu = document.getElementById('mobileMenu');
        this.currentLangDisplay = document.getElementById('currentLang');

        this.init();
    }

    init() {
        console.log('[MoneyWorkdeskApp] Initializing...');

        // Initialize theme
        this.initTheme();

        // Setup event listeners
        this.setupThemeToggle();
        this.setupLanguageSelector();
        this.setupMobileMenu();
        this.setupSmoothScroll();
        this.setupUserAvatar();

        // Close dropdowns on outside click
        this.setupOutsideClickHandlers();

        console.log('[MoneyWorkdeskApp] Initialized successfully');
    }

    /**
     * Initialize theme based on localStorage or system preference
     */
    initTheme() {
        const storedTheme = localStorage.getItem('moneyworkdesk_theme');
        const systemPrefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;

        const theme = storedTheme || (systemPrefersDark ? 'dark' : 'light');
        this.setTheme(theme, false);

        console.log('[Theme] Initialized:', theme);
    }

    /**
     * Set theme
     */
    setTheme(theme, save = true) {
        const html = document.documentElement;

        // Remove both classes first
        html.classList.remove('theme-light', 'theme-dark');

        // Add the correct theme class
        html.classList.add(`theme-${theme}`);

        // Update toggle button icon
        if (this.themeToggle) {
            const sunIcon = this.themeToggle.querySelector('.sun-icon');
            const moonIcon = this.themeToggle.querySelector('.moon-icon');

            if (theme === 'dark') {
                sunIcon.style.opacity = '0';
                moonIcon.style.opacity = '1';
            } else {
                sunIcon.style.opacity = '1';
                moonIcon.style.opacity = '0';
            }
        }

        // Save to localStorage
        if (save) {
            localStorage.setItem('moneyworkdesk_theme', theme);
            console.log('[Theme] Switched to:', theme);
        }
    }

    /**
     * Setup theme toggle button
     */
    setupThemeToggle() {
        if (!this.themeToggle) return;

        this.themeToggle.addEventListener('click', () => {
            const currentTheme = document.documentElement.classList.contains('theme-dark') ? 'dark' : 'light';
            const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
            this.setTheme(newTheme);
        });

        console.log('[Theme] Toggle button initialized');
    }

    /**
     * Setup language selector
     */
    setupLanguageSelector() {
        if (!this.langBtn || !this.langDropdown) return;

        // Toggle dropdown on button click
        this.langBtn.addEventListener('click', (e) => {
            e.stopPropagation();
            this.langDropdown.classList.toggle('active');
        });

        // Handle language selection
        const langButtons = this.langDropdown.querySelectorAll('button[data-lang]');
        langButtons.forEach(button => {
            button.addEventListener('click', (e) => {
                e.stopPropagation();
                const lang = button.dataset.lang;
                this.changeLanguage(lang);
                this.langDropdown.classList.remove('active');
            });
        });

        // Update current language display on init
        this.updateCurrentLanguageDisplay();

        console.log('[Language] Selector initialized');
    }

    /**
     * Change language
     */
    changeLanguage(lang) {
        if (window.i18n) {
            window.i18n.setLanguage(lang);
            this.updateCurrentLanguageDisplay();
            console.log('[Language] Changed to:', lang);
        } else {
            console.error('[Language] i18n not available');
        }
    }

    /**
     * Update current language display in button
     */
    updateCurrentLanguageDisplay() {
        if (!this.currentLangDisplay || !window.i18n) return;

        const langMap = {
            'en': 'EN',
            'nl-be': 'BE',
            'nl': 'NL',
            'fr': 'FR',
            'de': 'DE',
            'es': 'ES'
        };

        const currentLang = window.i18n.currentLang || 'en';
        this.currentLangDisplay.textContent = langMap[currentLang] || 'EN';
    }

    /**
     * Setup mobile menu
     */
    setupMobileMenu() {
        if (!this.mobileMenuToggle || !this.mobileMenu) return;

        this.mobileMenuToggle.addEventListener('click', (e) => {
            e.stopPropagation();
            this.toggleMobileMenu();
        });

        // Close menu when clicking on a link
        const mobileLinks = this.mobileMenu.querySelectorAll('a');
        mobileLinks.forEach(link => {
            link.addEventListener('click', () => {
                this.closeMobileMenu();
            });
        });

        console.log('[Mobile] Menu initialized');
    }

    /**
     * Toggle mobile menu
     */
    toggleMobileMenu() {
        this.mobileMenu.classList.toggle('active');
        this.mobileMenuToggle.classList.toggle('active');
        document.body.style.overflow = this.mobileMenu.classList.contains('active') ? 'hidden' : '';
    }

    /**
     * Close mobile menu
     */
    closeMobileMenu() {
        this.mobileMenu.classList.remove('active');
        this.mobileMenuToggle.classList.remove('active');
        document.body.style.overflow = '';
    }

    /**
     * Setup smooth scrolling for anchor links
     */
    setupSmoothScroll() {
        const anchorLinks = document.querySelectorAll('a[href^="#"]');

        anchorLinks.forEach(link => {
            link.addEventListener('click', (e) => {
                const href = link.getAttribute('href');

                // Skip if it's just "#"
                if (href === '#') return;

                e.preventDefault();

                const targetId = href.substring(1);
                const targetElement = document.getElementById(targetId);

                if (targetElement) {
                    // Close mobile menu if open
                    this.closeMobileMenu();

                    // Get navigation height for offset
                    const navHeight = document.querySelector('.top-nav')?.offsetHeight || 80;

                    // Scroll to element with offset
                    const elementPosition = targetElement.getBoundingClientRect().top + window.pageYOffset;
                    const offsetPosition = elementPosition - navHeight - 20;

                    window.scrollTo({
                        top: offsetPosition,
                        behavior: 'smooth'
                    });
                }
            });
        });

        console.log('[Scroll] Smooth scrolling initialized for', anchorLinks.length, 'links');
    }

    /**
     * Setup user avatar dropdown
     */
    setupUserAvatar() {
        const userAvatar = document.querySelector('.user-avatar');
        const userDropdown = document.querySelector('.user-dropdown');

        if (!userAvatar || !userDropdown) return;

        userAvatar.addEventListener('click', (e) => {
            e.stopPropagation();
            userDropdown.classList.toggle('active');
        });

        console.log('[User] Avatar dropdown initialized');
    }

    /**
     * Close dropdowns when clicking outside
     */
    setupOutsideClickHandlers() {
        document.addEventListener('click', (e) => {
            // Close language dropdown
            if (this.langDropdown && !this.langBtn.contains(e.target)) {
                this.langDropdown.classList.remove('active');
            }

            // Close user dropdown
            const userDropdown = document.querySelector('.user-dropdown');
            const userAvatar = document.querySelector('.user-avatar');
            if (userDropdown && userAvatar && !userAvatar.contains(e.target)) {
                userDropdown.classList.remove('active');
            }

            // Close mobile menu when clicking outside
            if (this.mobileMenu &&
                this.mobileMenu.classList.contains('active') &&
                !this.mobileMenu.contains(e.target) &&
                !this.mobileMenuToggle.contains(e.target)) {
                this.closeMobileMenu();
            }
        });

        // Close mobile menu on escape key
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape' && this.mobileMenu && this.mobileMenu.classList.contains('active')) {
                this.closeMobileMenu();
            }
        });
    }
}

/**
 * Toast notification system
 */
class Toast {
    static show(message, type = 'info', duration = 3000) {
        // Create toast container if it doesn't exist
        let container = document.getElementById('toastContainer');
        if (!container) {
            container = document.createElement('div');
            container.id = 'toastContainer';
            container.className = 'toast-container';
            document.body.appendChild(container);
        }

        // Create toast element
        const toast = document.createElement('div');
        toast.className = `toast toast-${type}`;
        toast.textContent = message;

        // Add to container
        container.appendChild(toast);

        // Trigger animation
        setTimeout(() => toast.classList.add('show'), 10);

        // Remove after duration
        setTimeout(() => {
            toast.classList.remove('show');
            setTimeout(() => toast.remove(), 300);
        }, duration);
    }
}

// Make Toast available globally
window.Toast = Toast;

/**
 * Initialize app when DOM is ready
 */
document.addEventListener('DOMContentLoaded', () => {
    console.log('[MoneyWorkdesk] DOM Ready');

    // Initialize main app
    window.moneyworkdeskApp = new MoneyWorkdeskApp();

    // Add scroll effect to navigation
    let lastScroll = 0;
    const nav = document.querySelector('.top-nav');

    window.addEventListener('scroll', () => {
        const currentScroll = window.pageYOffset;

        if (currentScroll > 100) {
            nav.classList.add('scrolled');
        } else {
            nav.classList.remove('scrolled');
        }

        lastScroll = currentScroll;
    });

    console.log('[MoneyWorkdesk] Ready! 🚀');
});

/**
 * Handle page visibility changes (pause/resume features)
 */
document.addEventListener('visibilitychange', () => {
    if (document.hidden) {
        console.log('[MoneyWorkdesk] Page hidden');
        // Could pause slider or other animations here
    } else {
        console.log('[MoneyWorkdesk] Page visible');
        // Could resume slider or other animations here
    }
});
