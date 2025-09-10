/**
 * @name Test Windows Security Patches Detection
 * @description Test query to validate the windows-security-patches.ql query functionality
 * @kind test
 * @problem.severity info
 * @precision high
 * @id windows/test-security-patches-check
 */

import csharp
import dotnet

// Simple test to verify the query can detect basic Windows Update API calls
from MethodCall call
where 
  call.getTarget().getDeclaringType().getQualifiedName().matches("WUApiLib.%") or
  call.getTarget().getName().matches(["Search", "GetUpdateHistory"]) or
  call.getAnArgument().getValue().toString().matches("%Win32_QuickFixEngineering%")
select call, "Test: Found potential Windows patch checking code"