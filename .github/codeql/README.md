# CodeQL Queries for Windows Security Patch Detection

This directory contains CodeQL queries to detect and analyze code that checks for Windows OS security patches applied within the last 6 months.

## Files

- **`windows-security-patches.ql`**: Main CodeQL query to detect Windows patch checking code
- **`WindowsPatchLib.qll`**: Supporting library with common patterns and utilities
- **`README.md`**: This documentation file

## Query Overview

The `windows-security-patches.ql` query identifies code patterns that:

1. **Windows Update API Usage**: Detects calls to Windows Update Agent APIs
2. **Registry Access**: Finds registry queries for patch information
3. **PowerShell Commands**: Identifies PowerShell cmdlets for update checking
4. **Date Range Filtering**: Locates 6-month time range filters for recent patches
5. **Security-Specific Checks**: Finds code that specifically looks for security bulletins

## What the Query Detects

### Windows Update API Calls
```csharp
// Examples of detected patterns:
var updateSession = new UpdateSession();
var updateSearcher = updateSession.CreateUpdateSearcher();
var searchResult = updateSearcher.Search("IsInstalled=1");

// WMI queries
var searcher = new ManagementObjectSearcher("SELECT * FROM Win32_QuickFixEngineering");
```

### Registry Access for Patches
```csharp
// Registry key access for patch information
using (var key = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Microsoft\Updates"))
{
    // Patch enumeration code
}
```

### PowerShell Update Commands
```csharp
// PowerShell execution for update checking
powershell.AddScript("Get-HotFix | Where-Object {$_.InstalledOn -gt (Get-Date).AddMonths(-6)}");
```

### Date Range Filtering
```csharp
// 6-month date filtering
var sixMonthsAgo = DateTime.Now.AddMonths(-6);
var recentPatches = patches.Where(p => p.InstallDate >= sixMonthsAgo);
```

## Usage

### Running the Query

1. **With CodeQL CLI**:
   ```bash
   codeql query run windows-security-patches.ql --database <database-path>
   ```

2. **In GitHub Advanced Security**:
   - Add the query to your `.github/codeql/` directory
   - Configure CodeQL analysis in your workflow
   - The query will run automatically on code scans

### Integration with CI/CD

Add to your GitHub Actions workflow:

```yaml
- name: Run CodeQL Analysis
  uses: github/codeql-action/analyze@v2
  with:
    queries: .github/codeql/queries/windows-security-patches.ql
```

## Query Results

The query produces results indicating:
- **Location**: File and line where patch checking code is found
- **Pattern Type**: What kind of patch checking is being performed
- **Recommendation**: Guidance on ensuring 6-month patch validation

## Customization

### Extending the Query

To customize for your environment:

1. **Add Custom APIs**: Modify `WindowsPatchLib.qll` to include your organization's patch checking methods
2. **Adjust Time Range**: Change the 6-month pattern in `WindowsUpdatePatterns::isSixMonthTimeRange`
3. **Add Classifications**: Extend `SecurityPatchCategories` for specific security standards

### Example Extensions

```ql
// Add custom patch management system
predicate isCustomPatchApi(string api) {
  api.matches([
    "MyOrg.PatchManager.%",
    "CustomUpdate.%"
  ])
}
```

## Best Practices

1. **Regular Scanning**: Run the query regularly to ensure patch checking code remains active
2. **Validation**: Verify that detected code actually validates recent patches (not just queries them)
3. **Coverage**: Ensure all critical applications have patch checking mechanisms
4. **Documentation**: Document the patch checking strategy for each detected pattern

## Compliance Considerations

This query helps with:
- **Security Auditing**: Verify applications check for recent OS patches
- **Compliance Reporting**: Document patch validation mechanisms
- **Risk Assessment**: Identify applications that may not validate OS security state
- **Incident Response**: Quickly locate patch checking code during security incidents

## Limitations

- Query detects code patterns, not runtime behavior
- May not catch all custom patch checking implementations
- Requires C# codebase for full effectiveness
- Does not validate actual patch installation, only checking mechanisms