using System;
using System.Management;
using Microsoft.Win32;
using System.Management.Automation;
using System.Linq;
using WUApiLib;

namespace SecurityPatchChecker
{
    /// <summary>
    /// Example class demonstrating Windows OS security patch checking
    /// This code would be detected by the windows-security-patches.ql query
    /// </summary>
    public class WindowsPatchChecker
    {
        /// <summary>
        /// Checks if security patches from the last 6 months have been applied
        /// Uses Windows Update API - DETECTED by CodeQL query
        /// </summary>
        public bool HasRecentSecurityPatches()
        {
            try
            {
                // This Windows Update API call would be detected
                var updateSession = new UpdateSession();
                var updateSearcher = updateSession.CreateUpdateSearcher();
                
                // Search for installed updates - DETECTED
                var searchResult = updateSearcher.Search("IsInstalled=1 and Type='Software'");
                
                var sixMonthsAgo = DateTime.Now.AddMonths(-6); // Date range - DETECTED
                
                foreach (IUpdate update in searchResult.Updates)
                {
                    if (update.LastDeploymentChangeTime >= sixMonthsAgo && 
                        update.Categories.Contains("Security Updates"))
                    {
                        return true;
                    }
                }
                
                return false;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error checking patches: {ex.Message}");
                return false;
            }
        }
        
        /// <summary>
        /// Uses WMI to check for hotfixes - DETECTED by CodeQL query
        /// </summary>
        public void CheckHotfixesViaWMI()
        {
            // WMI query for hotfixes - DETECTED
            var searcher = new ManagementObjectSearcher(
                "SELECT * FROM Win32_QuickFixEngineering WHERE InstalledOn > '" + 
                DateTime.Now.AddDays(-180).ToString("yyyyMMdd") + "'"
            );
            
            foreach (ManagementObject hotfix in searcher.Get())
            {
                Console.WriteLine($"Hotfix: {hotfix["HotFixID"]}, Installed: {hotfix["InstalledOn"]}");
            }
        }
        
        /// <summary>
        /// Checks registry for patch information - DETECTED by CodeQL query
        /// </summary>
        public void CheckPatchesViaRegistry()
        {
            // Registry access for patch info - DETECTED
            using (var key = Registry.LocalMachine.OpenSubKey(
                @"SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing"))
            {
                if (key != null)
                {
                    var subKeyNames = key.GetSubKeyNames();
                    foreach (var subKeyName in subKeyNames)
                    {
                        if (subKeyName.StartsWith("Package_"))
                        {
                            // Process patch information
                            Console.WriteLine($"Found package: {subKeyName}");
                        }
                    }
                }
            }
        }
        
        /// <summary>
        /// Uses PowerShell to get update history - DETECTED by CodeQL query
        /// </summary>
        public void CheckUpdatesViaPowerShell()
        {
            using (var powershell = PowerShell.Create())
            {
                // PowerShell command for updates - DETECTED
                powershell.AddScript("Get-HotFix | Where-Object {$_.InstalledOn -gt (Get-Date).AddMonths(-6)}");
                
                var results = powershell.Invoke();
                foreach (var result in results)
                {
                    Console.WriteLine($"Recent hotfix: {result}");
                }
            }
        }
        
        /// <summary>
        /// Specific security bulletin check - DETECTED by CodeQL query
        /// </summary>
        public bool IsSecurityBulletinInstalled(string bulletinId)
        {
            // Security bulletin check - DETECTED
            var searcher = new ManagementObjectSearcher(
                $"SELECT * FROM Win32_QuickFixEngineering WHERE HotFixID = '{bulletinId}'"
            );
            
            return searcher.Get().Count > 0;
        }
        
        /// <summary>
        /// Comprehensive patch validation for the last 6 months
        /// </summary>
        public PatchValidationResult ValidateRecentPatches()
        {
            var result = new PatchValidationResult();
            var sixMonthsAgo = DateTime.Now.AddMonths(-6); // Date filtering - DETECTED
            
            // Multiple detection points in this method
            result.HasRecentSecurityUpdates = HasRecentSecurityPatches();
            result.RecentHotfixCount = GetRecentHotfixCount(sixMonthsAgo);
            result.LastValidationTime = DateTime.UtcNow;
            
            return result;
        }
        
        private int GetRecentHotfixCount(DateTime since)
        {
            // Additional WMI usage - DETECTED
            var query = $"SELECT * FROM Win32_QuickFixEngineering WHERE InstalledOn >= '{since:yyyyMMdd}'";
            var searcher = new ManagementObjectSearcher(query);
            
            return searcher.Get().Count;
        }
    }
    
    public class PatchValidationResult
    {
        public bool HasRecentSecurityUpdates { get; set; }
        public int RecentHotfixCount { get; set; }
        public DateTime LastValidationTime { get; set; }
    }
}