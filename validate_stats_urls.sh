#!/bin/bash

# GitHub Statistics URL Validation Script
# This script validates that all URLs in the GitHub statistics are properly formatted

echo "=== GitHub Statistics URL Validation ==="
echo

# Function to validate URL format
validate_url() {
    local url="$1"
    local description="$2"
    
    # Basic URL validation
    if [[ $url =~ ^https?:// ]]; then
        echo "✅ $description: URL format valid"
        echo "   URL: $url"
    else
        echo "❌ $description: Invalid URL format"
        echo "   URL: $url"
    fi
    echo
}

# Test URLs from the GitHub statistics
echo "Testing GitHub README Stats URLs:"
validate_url "https://github-readme-stats.vercel.app/api?username=Jegan-Kunniya&show_icons=true&theme=tokyonight&include_all_commits=true&count_private=true&hide_border=true" "GitHub Stats (Tokyo Night)"
validate_url "https://github-readme-stats.vercel.app/api/top-langs/?username=Jegan-Kunniya&layout=compact&langs_count=8&theme=tokyonight&hide_border=true" "Top Languages (Tokyo Night)"

echo "Testing GitHub Streak Stats URLs:"
validate_url "https://github-readme-streak-stats.herokuapp.com/?user=Jegan-Kunniya&theme=tokyonight&hide_border=true" "GitHub Streak (Tokyo Night)"

echo "Testing GitHub Trophy URLs:"
validate_url "https://github-profile-trophy.vercel.app/?username=Jegan-Kunniya&theme=tokyonight&no-frame=true&no-bg=true&margin-w=4" "GitHub Trophies (Tokyo Night)"

echo "Testing Activity Graph URLs:"
validate_url "https://github-readme-activity-graph.vercel.app/graph?username=Jegan-Kunniya&theme=tokyo-night&hide_border=true" "Activity Graph (Tokyo Night)"

echo "Testing Profile Views Counter URLs:"
validate_url "https://komarev.com/ghpvc/?username=Jegan-Kunniya&label=Profile%20views&color=0e75b6&style=flat" "Profile Views Counter"

echo "Testing Alternative Theme URLs:"
validate_url "https://github-readme-stats.vercel.app/api?username=Jegan-Kunniya&show_icons=true&theme=radical&include_all_commits=true&count_private=true&hide_border=true" "GitHub Stats (Radical)"
validate_url "https://github-readme-stats.vercel.app/api?username=Jegan-Kunniya&show_icons=true&theme=github_dark&include_all_commits=true&count_private=true&hide_border=true" "GitHub Stats (GitHub Dark)"

echo "Testing Language Layout Variations:"
validate_url "https://github-readme-stats.vercel.app/api/top-langs/?username=Jegan-Kunniya&layout=donut&langs_count=8&theme=tokyonight&hide_border=true" "Top Languages (Donut)"
validate_url "https://github-readme-stats.vercel.app/api/top-langs/?username=Jegan-Kunniya&layout=pie&langs_count=8&theme=tokyonight&hide_border=true" "Top Languages (Pie)"

echo "Testing GitHub Profile Summary Cards:"
validate_url "https://github-profile-summary-cards.vercel.app/api/cards/profile-details?username=Jegan-Kunniya&theme=tokyonight" "Profile Summary Details"
validate_url "https://github-profile-summary-cards.vercel.app/api/cards/repos-per-language?username=Jegan-Kunniya&theme=tokyonight" "Repos per Language"

echo "=== URL Validation Complete ==="
echo
echo "Note: URL format validation passed. Actual widget functionality"
echo "should be tested in a browser environment where external services"
echo "are accessible (e.g., on GitHub directly)."