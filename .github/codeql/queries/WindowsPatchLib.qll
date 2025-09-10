/**
 * Library for Windows patch detection patterns and utilities
 */

import csharp
import dotnet

/**
 * Common Windows Update service and API patterns
 */
module WindowsUpdatePatterns {
  
  /**
   * Known Windows Update related namespaces and classes
   */
  predicate isWindowsUpdateNamespace(string namespace) {
    namespace.matches([
      "WUApiLib.%",
      "Microsoft.Update.%",
      "Microsoft.UpdateServices.%", 
      "System.Management%"
    ])
  }
  
  /**
   * Registry keys commonly used for patch information
   */
  predicate isPatchRegistryKey(string key) {
    key.matches([
      "%SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Component Based Servicing%",
      "%SOFTWARE\\Microsoft\\Updates%", 
      "%SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Hotfix%",
      "%SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\WindowsUpdate%"
    ])
  }
  
  /**
   * WMI classes that contain patch and update information  
   */
  predicate isPatchWmiClass(string wmiClass) {
    wmiClass.matches([
      "%Win32_QuickFixEngineering%",
      "%Win32_OperatingSystem%",
      "%Win32_ReliabilityRecords%", 
      "%Win32_SystemDriver%"
    ])
  }
  
  /**
   * PowerShell cmdlets for Windows Update management
   */
  predicate isUpdatePowerShellCmdlet(string cmdlet) {
    cmdlet.matches([
      "%Get-HotFix%",
      "%Get-WindowsUpdate%",
      "%Get-WUHistory%", 
      "%Get-WUInstall%",
      "%Install-WindowsUpdate%"
    ])
  }
  
  /**
   * Common time range patterns for 6 months
   */
  predicate isSixMonthTimeRange(string timePattern) {
    timePattern.matches([
      "%AddMonths(-6)%",
      "%AddDays(-180)%",
      "%AddDays(-183)%", // 6 months ≈ 183 days
      "%TimeSpan.FromDays(180)%"
    ])
  }
}

/**
 * Security patch categories and classifications
 */
module SecurityPatchCategories {
  
  /**
   * Microsoft security bulletin patterns
   */
  predicate isSecurityBulletin(string bulletin) {
    bulletin.matches([
      "%MS%-%", // Microsoft Security Bulletin format
      "%KB%",   // Knowledge Base article format
      "%CVE-%"  // Common Vulnerabilities and Exposures format  
    ])
  }
  
  /**
   * Update classification levels that indicate security patches
   */
  predicate isSecurityUpdateClassification(string classification) {
    classification.toLowerCase().matches([
      "%security%",
      "%critical%", 
      "%important%",
      "%moderate%"
    ])
  }
}

/**
 * Helper predicates for date and time validation
 */
module TimeRangeHelpers {
  
  /**
   * Detects date arithmetic that could represent 6 months
   */
  predicate isSixMonthDateArithmetic(BinaryOperation op) {
    op.getOperator().matches(["+", "-"]) and
    (
      op.getRightOperand().getValue().toString().matches(["6", "180", "183"]) or
      op.getLeftOperand().getValue().toString().matches(["6", "180", "183"])
    )
  }
  
  /**
   * Common date comparison operators for filtering patches
   */
  predicate isDateComparisonOperator(string operator) {
    operator.matches([">=", "<=", ">", "<", "==", "!="])
  }
}