---
name: TCM Industrial Precision
colors:
  surface: '#f8f9fb'
  surface-dim: '#d9dadc'
  surface-bright: '#f8f9fb'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f4f6'
  surface-container: '#edeef0'
  surface-container-high: '#e7e8ea'
  surface-container-highest: '#e1e2e4'
  on-surface: '#191c1e'
  on-surface-variant: '#434655'
  inverse-surface: '#2e3132'
  inverse-on-surface: '#f0f1f3'
  outline: '#737686'
  outline-variant: '#c3c6d7'
  surface-tint: '#0053db'
  primary: '#004ac6'
  on-primary: '#ffffff'
  primary-container: '#2563eb'
  on-primary-container: '#eeefff'
  inverse-primary: '#b4c5ff'
  secondary: '#545f73'
  on-secondary: '#ffffff'
  secondary-container: '#d5e0f8'
  on-secondary-container: '#586377'
  tertiary: '#006242'
  on-tertiary: '#ffffff'
  tertiary-container: '#007d55'
  on-tertiary-container: '#bdffdb'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#dbe1ff'
  primary-fixed-dim: '#b4c5ff'
  on-primary-fixed: '#00174b'
  on-primary-fixed-variant: '#003ea8'
  secondary-fixed: '#d8e3fb'
  secondary-fixed-dim: '#bcc7de'
  on-secondary-fixed: '#111c2d'
  on-secondary-fixed-variant: '#3c475a'
  tertiary-fixed: '#6ffbbe'
  tertiary-fixed-dim: '#4edea3'
  on-tertiary-fixed: '#002113'
  on-tertiary-fixed-variant: '#005236'
  background: '#f8f9fb'
  on-background: '#191c1e'
  surface-variant: '#e1e2e4'
typography:
  display-data:
    fontFamily: Hanken Grotesk
    fontSize: 72px
    fontWeight: '800'
    lineHeight: 80px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Hanken Grotesk
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
  headline-lg-mobile:
    fontFamily: Hanken Grotesk
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
  headline-md:
    fontFamily: Hanken Grotesk
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  body-lg:
    fontFamily: Hanken Grotesk
    fontSize: 20px
    fontWeight: '500'
    lineHeight: 30px
  body-md:
    fontFamily: Hanken Grotesk
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-data:
    fontFamily: JetBrains Mono
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.05em
rounded:
  sm: 0.5rem
  DEFAULT: 1rem
  md: 1.5rem
  lg: 2rem
  xl: 3rem
  full: 9999px
spacing:
  base-unit: 8px
  touch-target-min: 56px
  gutter-desktop: 24px
  margin-desktop: 40px
  gutter-mobile: 16px
  margin-mobile: 16px
---

## Brand & Style
The design system focuses on the intersection of industrial reliability and medical precision. It is engineered for a Traditional Chinese Medicine (TCM) storage environment where legibility from a distance and high-stakes accuracy are paramount. The target audience includes warehouse staff and agricultural technicians who require an interface that minimizes cognitive load during physical labor.

The style is **Corporate/Modern** with a strong emphasis on **Industrial Utility**. It utilizes high-contrast elements, substantial touch targets, and a rigorous hierarchy to ensure the UI remains accessible in variable lighting conditions. The emotional response is one of stability, cleanliness, and uncompromising clinical safety.

## Colors
The palette is rooted in functional utility. **Medical Blue (#2563EB)** serves as the primary action color, signaling professionalism and trust. The background uses **Industrial Light Gray (#F3F4F6)** to reduce screen glare in warehouse environments while providing a clean canvas for high-contrast data cards. 

**Alert Red (#EF4444)** is reserved exclusively for warning states, alarms, and critical storage temperature deviations. A secondary Slate Blue is used for iconography and structural elements to maintain a professional, hardware-integrated aesthetic.

## Typography
The typography system prioritizes data visibility. **Hanken Grotesk** is used for all primary UI elements due to its sharp, contemporary geometry and exceptional legibility at heavy weights. For numeric data—such as temperature, humidity, and stock counts—oversized weights are utilized to ensure visibility from several feet away.

**JetBrains Mono** is employed for labels and technical IDs to provide a distinct visual "coding" that separates metadata from primary human-readable content. For mobile and small tablets, display sizes scale down aggressively to maintain layout integrity without sacrificing the "bold data" philosophy.

## Layout & Spacing
The layout follows a **Fluid Grid** model optimized for touch-screen kiosks and ruggedized tablets. It utilizes a 12-column system on desktop and a 4-column system on mobile. 

A strict 8px spacing rhythm ensures alignment across complex data sets. To accommodate users wearing gloves or operating in high-activity environments, the minimum touch target is set to 56px. Spacing between interactive elements is generous to prevent accidental triggers.

## Elevation & Depth
In this design system, depth is communicated through **Tonal Layers** and **Low-Contrast Outlines**. Since the environment is industrial, we avoid complex shadows that can appear "muddy" on lower-quality LCD panels. 

Surface containers are distinguished by subtle shifts in background value (e.g., White cards on a Light Gray background). For active states or critical focus, a 2px solid border in Primary Blue is preferred over high-elevation shadows to maintain a flat, high-clarity interface.

## Shapes
The shape language uses **Pill-shaped (3)** roundedness. Large corner radii (up to 3xl for cards and primary buttons) provide a friendly, approachable feel that counteracts the coldness of industrial data. These soft edges also create distinct visual containers that are easier for the eye to group quickly when scanning stock levels.

## Components

### Buttons
Buttons are oversized (minimum 56px height) with full rounded caps (pill-shaped). Primary buttons use the Medical Blue background with white bold text. Secondary buttons use a thick 2px outline.

### Data Cards
Cards are the primary container for storage metrics. They feature a white background, 24px internal padding, and 32px (2xl) corner radius. Use "Display-Data" typography for the primary metric (e.g., 18°C) to make it the clear focal point.

### Status Badges
High-visibility badges for "Stable," "Warning," and "Critical." These use high-saturation background fills with white text, positioned in the top-right of data cards for immediate status assessment.

### Input Fields
Inputs are large with visible borders at all times. The focus state is indicated by a thick 3px Medical Blue border. Labels are always persistent (not floating) to ensure the user never loses context of the data being entered.

### Toggle Switches
Oversized toggles are used for binary controls (e.g., Ventilation ON/OFF), providing clear tactile feedback through high-contrast color shifts.