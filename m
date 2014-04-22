Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbaDVFMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 01:12:17 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:51823 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaDVFMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 01:12:14 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: Make linux-pm@vger.kernel.org official mailing list
Date: Tue, 22 Apr 2014 10:42:05 +0530
Message-Id: <b2b1ad7b6c034a1dafc0595507baf50ffc3a4c1a.1398143512.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There have been confusion all the time about which mailing list to follow for
cpufreq activities, linux-pm@vger.kernel.org or cpufreq@vger.kernel.org.
As Maintainers always wanted people to send patches to linux-pm@vger.kernel.org
and kernel source asked them to use cpufreq@vger.kernel.org.

Lets make linux-pm@vger.kernel.org the official mailing list for cpufreq stuff
and remove all references of cpufreq@vger.kernel.org from kernel source.

Later, we can remove the list as well from vger.kernel.org.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 Documentation/ABI/testing/sysfs-devices-system-cpu   | 4 ++--
 Documentation/cpu-freq/index.txt                     | 4 ++--
 MAINTAINERS                                          | 2 --
 drivers/cpufreq/speedstep-centrino.c                 | 2 +-
 tools/power/cpupower/Makefile                        | 2 +-
 tools/power/cpupower/debug/kernel/cpufreq-test_tsc.c | 2 +-
 6 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index d5a0d33..acb9bfc 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -128,7 +128,7 @@ Description:	Discover cpuidle policy and mechanism
 
 What:		/sys/devices/system/cpu/cpu#/cpufreq/*
 Date:		pre-git history
-Contact:	cpufreq@vger.kernel.org
+Contact:	linux-pm@vger.kernel.org
 Description:	Discover and change clock speed of CPUs
 
 		Clock scaling allows you to change the clock speed of the
@@ -146,7 +146,7 @@ Description:	Discover and change clock speed of CPUs
 
 What:		/sys/devices/system/cpu/cpu#/cpufreq/freqdomain_cpus
 Date:		June 2013
-Contact:	cpufreq@vger.kernel.org
+Contact:	linux-pm@vger.kernel.org
 Description:	Discover CPUs in the same CPU frequency coordination domain
 
 		freqdomain_cpus is the list of CPUs (online+offline) that share
diff --git a/Documentation/cpu-freq/index.txt b/Documentation/cpu-freq/index.txt
index 3d0b915..dc024ab 100644
--- a/Documentation/cpu-freq/index.txt
+++ b/Documentation/cpu-freq/index.txt
@@ -35,8 +35,8 @@ Mailing List
 ------------
 There is a CPU frequency changing CVS commit and general list where
 you can report bugs, problems or submit patches. To post a message,
-send an email to cpufreq@vger.kernel.org, to subscribe go to
-http://vger.kernel.org/vger-lists.html#cpufreq and follow the
+send an email to linux-pm@vger.kernel.org, to subscribe go to
+http://vger.kernel.org/vger-lists.html#linux-pm and follow the
 instructions there.
 
 Links
diff --git a/MAINTAINERS b/MAINTAINERS
index 6dc67b1..88b60d9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2415,7 +2415,6 @@ F:	drivers/net/ethernet/ti/cpmac.c
 CPU FREQUENCY DRIVERS
 M:	Rafael J. Wysocki <rjw@rjwysocki.net>
 M:	Viresh Kumar <viresh.kumar@linaro.org>
-L:	cpufreq@vger.kernel.org
 L:	linux-pm@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
@@ -2426,7 +2425,6 @@ F:	include/linux/cpufreq.h
 CPU FREQUENCY DRIVERS - ARM BIG LITTLE
 M:	Viresh Kumar <viresh.kumar@linaro.org>
 M:	Sudeep Holla <sudeep.holla@arm.com>
-L:	cpufreq@vger.kernel.org
 L:	linux-pm@vger.kernel.org
 W:	http://www.arm.com/products/processors/technologies/biglittleprocessing.php
 S:	Maintained
diff --git a/drivers/cpufreq/speedstep-centrino.c b/drivers/cpufreq/speedstep-centrino.c
index 6723f03..7d4a315 100644
--- a/drivers/cpufreq/speedstep-centrino.c
+++ b/drivers/cpufreq/speedstep-centrino.c
@@ -28,7 +28,7 @@
 #include <asm/cpu_device_id.h>
 
 #define PFX		"speedstep-centrino: "
-#define MAINTAINER	"cpufreq@vger.kernel.org"
+#define MAINTAINER	"linux-pm@vger.kernel.org"
 
 #define INTEL_MSR_RANGE	(0xffff)
 
diff --git a/tools/power/cpupower/Makefile b/tools/power/cpupower/Makefile
index cbfec92..3651db7 100644
--- a/tools/power/cpupower/Makefile
+++ b/tools/power/cpupower/Makefile
@@ -62,7 +62,7 @@ LIB_MAJ=			0.0.0
 LIB_MIN=			0
 
 PACKAGE =			cpupower
-PACKAGE_BUGREPORT =		cpufreq@vger.kernel.org
+PACKAGE_BUGREPORT =		linux-pm@vger.kernel.org
 LANGUAGES = 			de fr it cs pt
 
 
diff --git a/tools/power/cpupower/debug/kernel/cpufreq-test_tsc.c b/tools/power/cpupower/debug/kernel/cpufreq-test_tsc.c
index 0f10b81..5224ee5 100644
--- a/tools/power/cpupower/debug/kernel/cpufreq-test_tsc.c
+++ b/tools/power/cpupower/debug/kernel/cpufreq-test_tsc.c
@@ -18,7 +18,7 @@
  * 5.) if the third value, "diff_pmtmr", changes between 2. and 4., the
  *     TSC-based delay routine on the Linux kernel does not correctly
  *     handle the cpufreq transition. Please report this to
- *     cpufreq@vger.kernel.org
+ *     linux-pm@vger.kernel.org
  */
 
 #include <linux/kernel.h>
-- 
1.7.12.rc2.18.g61b472e

