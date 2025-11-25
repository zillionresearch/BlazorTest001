/**
 * MoneyWorkdesk - Hero Slider
 * Auto-playing carousel with manual controls
 */

class HeroSlider {
    constructor() {
        this.slides = document.querySelectorAll('.slide');
        this.currentSlide = 0;
        this.autoPlayInterval = null;
        this.autoPlayDelay = 5000; // 5 seconds

        this.init();
    }

    init() {
        if (this.slides.length === 0) return;

        // Create dots
        this.createDots();

        // Add event listeners
        this.addEventListeners();

        // Start autoplay
        this.startAutoPlay();

        console.log('[Slider] Initialized with', this.slides.length, 'slides');
    }

    createDots() {
        const dotsContainer = document.getElementById('sliderDots');
        if (!dotsContainer) return;

        dotsContainer.innerHTML = '';

        this.slides.forEach((_, index) => {
            const dot = document.createElement('div');
            dot.classList.add('slider-dot');
            if (index === 0) dot.classList.add('active');

            dot.addEventListener('click', () => this.goToSlide(index));

            dotsContainer.appendChild(dot);
        });

        this.dots = document.querySelectorAll('.slider-dot');
    }

    addEventListeners() {
        const prevBtn = document.getElementById('prevSlide');
        const nextBtn = document.getElementById('nextSlide');

        if (prevBtn) {
            prevBtn.addEventListener('click', () => this.prev());
        }

        if (nextBtn) {
            nextBtn.addEventListener('click', () => this.next());
        }

        // Pause on hover
        const sliderContainer = document.querySelector('.slider-container');
        if (sliderContainer) {
            sliderContainer.addEventListener('mouseenter', () => this.stopAutoPlay());
            sliderContainer.addEventListener('mouseleave', () => this.startAutoPlay());
        }

        // Keyboard navigation
        document.addEventListener('keydown', (e) => {
            if (e.key === 'ArrowLeft') this.prev();
            if (e.key === 'ArrowRight') this.next();
        });
    }

    goToSlide(index) {
        // Remove active class from current slide
        this.slides[this.currentSlide].classList.remove('active');
        if (this.dots && this.dots[this.currentSlide]) {
            this.dots[this.currentSlide].classList.remove('active');
        }

        // Update current slide
        this.currentSlide = index;

        // Add active class to new slide
        this.slides[this.currentSlide].classList.add('active');
        if (this.dots && this.dots[this.currentSlide]) {
            this.dots[this.currentSlide].classList.add('active');
        }

        // Restart autoplay
        this.resetAutoPlay();
    }

    next() {
        const nextSlide = (this.currentSlide + 1) % this.slides.length;
        this.goToSlide(nextSlide);
    }

    prev() {
        const prevSlide = (this.currentSlide - 1 + this.slides.length) % this.slides.length;
        this.goToSlide(prevSlide);
    }

    startAutoPlay() {
        this.stopAutoPlay(); // Clear any existing interval
        this.autoPlayInterval = setInterval(() => this.next(), this.autoPlayDelay);
    }

    stopAutoPlay() {
        if (this.autoPlayInterval) {
            clearInterval(this.autoPlayInterval);
            this.autoPlayInterval = null;
        }
    }

    resetAutoPlay() {
        this.stopAutoPlay();
        this.startAutoPlay();
    }
}

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    const slider = new HeroSlider();
    window.heroSlider = slider;
});
