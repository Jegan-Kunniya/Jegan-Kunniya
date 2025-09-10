/**
 * @name Windows OS Security Patches Detection
 * @description Detects code that checks for Windows OS security patches applied in the last 6 months
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id windows/security-patches-check
 * @tags security
 *       windows
 *       patches
 *       compliance
 */

import csharp
import dotnet
import WindowsPatchLib

/**
 * Represents Windows Update API calls that could be used to check for installed patches
 */
class WindowsUpdateApiCall extends MethodCall {
  WindowsUpdateApiCall() {
    // Windows Update Agent API calls using library patterns
    WindowsUpdatePatterns::isWindowsUpdateNamespace(this.getTarget().getDeclaringType().getQualifiedName()) or
    
    // Common method names for patch checking
    this.getTarget().getName().matches([
      "Search",
      "BeginSearch", 
      "GetTotalHistoryCount",
      "QueryHistory",
      "GetUpdateHistory",
      "GetUpdates"
    ]) or
    
    // WMI queries for hotfixes and updates using library patterns
    (this.getTarget().getName().matches(["Get", "Query"]) and 
     exists(string arg | 
       arg = this.getAnArgument().getValue().toString() and
       WindowsUpdatePatterns::isPatchWmiClass(arg)
     ))
  }
}

/**
 * Represents registry access calls that could check for patch information
 */
class WindowsPatchRegistryAccess extends MethodCall {
  WindowsPatchRegistryAccess() {
    this.getTarget().getDeclaringType().getQualifiedName().matches([
      "Microsoft.Win32.Registry%",
      "Microsoft.Win32.RegistryKey"
    ]) and
    exists(string key |
      key = this.getAnArgument().getValue().toString() and
      WindowsUpdatePatterns::isPatchRegistryKey(key)
    )
  }
}

/**
 * Represents PowerShell commands that check for Windows updates
 */
class PowerShellUpdateCommand extends MethodCall {
  PowerShellUpdateCommand() {
    this.getTarget().getName().matches([
      "AddScript",
      "AddCommand", 
      "Invoke"
    ]) and
    exists(string cmd |
      cmd = this.getAnArgument().getValue().toString() and
      WindowsUpdatePatterns::isUpdatePowerShellCmdlet(cmd)
    )
  }
}

/**
 * Represents system calls that might check patch installation dates within last 6 months
 */
class SixMonthDateRangeCheck extends BinaryOperation {
  SixMonthDateRangeCheck() {
    TimeRangeHelpers::isDateComparisonOperator(this.getOperator()) and
    (
      // Check for date comparisons with 6 months ago
      this.getAnOperand().getType().getName().matches(["DateTime", "DateTimeOffset"]) or
      exists(string timePattern |
        timePattern = this.getAnOperand().toString() and
        WindowsUpdatePatterns::isSixMonthTimeRange(timePattern)
      ) or
      // Detect date arithmetic that represents 6 months
      TimeRangeHelpers::isSixMonthDateArithmetic(this)
    )
  }
}

/**
 * Represents security-specific patch checking
 */
class SecurityPatchCheck extends MethodCall {
  SecurityPatchCheck() {
    exists(string arg |
      arg = this.getAnArgument().getValue().toString() and
      (
        SecurityPatchCategories::isSecurityBulletin(arg) or
        SecurityPatchCategories::isSecurityUpdateClassification(arg)
      )
    )
  }
}

/**
 * Main predicate to find code that checks for recent Windows security patches
 */
predicate checksRecentWindowsPatches(Expr expr, string reason) {
  (
    expr instanceof WindowsUpdateApiCall and
    reason = "Uses Windows Update API to query for installed patches"
  ) or
  (
    expr instanceof WindowsPatchRegistryAccess and  
    reason = "Accesses Windows registry for patch installation information"
  ) or
  (
    expr instanceof PowerShellUpdateCommand and
    reason = "Executes PowerShell cmdlets to retrieve Windows update information"
  ) or
  (
    expr instanceof SixMonthDateRangeCheck and
    exists(WindowsUpdateApiCall wuCall | 
      wuCall.getEnclosingCallable() = expr.getEnclosingCallable()
    ) and
    reason = "Filters patches by 6-month date range for recent security updates"
  ) or
  (
    expr instanceof SecurityPatchCheck and
    reason = "Specifically checks for security patches and bulletins"
  )
}

from Expr patchCheck, string reason
where checksRecentWindowsPatches(patchCheck, reason)
select patchCheck, "Code that validates Windows OS security patches: " + reason + ". Ensure patches from the last 6 months are properly checked and applied."