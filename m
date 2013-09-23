Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab3IWThS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 15:37:18 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:62408 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab3IWThR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 15:37:17 -0400
From: Richard Weinberger <richard@nod.at>
To: x86@kernel.org
Cc: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, rob@landley.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, bp@suse.de,
        dave.hansen@linux.intel.com, tony.luck@intel.com,
        naveen.n.rao@linux.vnet.ibm.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH] Documentation: Update x86_64/boot-options.txt
Date: Mon, 23 Sep 2013 21:36:57 +0200
Message-Id: <1379965017-29776-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed obsolte parameters from boot-options.txt.
Verified by grepping around in arch/x86/.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 Documentation/x86/x86_64/boot-options.txt | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
index 1228b22..5223479 100644
--- a/Documentation/x86/x86_64/boot-options.txt
+++ b/Documentation/x86/x86_64/boot-options.txt
@@ -78,14 +78,6 @@ APICs
 
    no_timer_check Don't check the IO-APIC timer. This can work around
 		 problems with incorrect timer initialization on some boards.
-
-   apicmaintimer Run time keeping from the local APIC timer instead
-                 of using the PIT/HPET interrupt for this. This is useful
-                 when the PIT/HPET interrupts are unreliable.
-
-   noapicmaintimer  Don't do time keeping using the APIC timer.
-		 Useful when this option was auto selected, but doesn't work.
-
    apicpmtimer
 		 Do APIC timer calibration using the pmtimer. Implies
 		 apicmaintimer. Useful when your PIT timer is totally
@@ -144,11 +136,6 @@ Non Executable Mappings
   on      Enable(default)
   off     Disable
 
-SMP
-
-  additional_cpus=NUM Allow NUM more CPUs for hotplug
-		 (defaults are specified by the BIOS, see Documentation/x86/x86_64/cpu-hotplug-spec)
-
 NUMA
 
   numa=off	Only set up a single NUMA node spanning all memory.
@@ -289,16 +276,6 @@ Debugging
 
   kstack=N	Print N words from the kernel stack in oops dumps.
 
-  pagefaulttrace  Dump all page faults. Only useful for extreme debugging
-		and will create a lot of output.
-
-  call_trace=[old|both|newfallback|new]
-		old: use old inexact backtracer
-		new: use new exact dwarf2 unwinder
- 		both: print entries from both
-		newfallback: use new unwinder but fall back to old if it gets
-			stuck (default)
-
 Miscellaneous
 
 	nogbpages
-- 
1.8.3.1

