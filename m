Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676AbaAFQYk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:24:40 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43737 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815AbaAFQXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:23:25 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Renninger <trenn@suse.de>,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [PATCH 1/3] cpupower tools: adjust README to reflect rename
Date: Mon,  6 Jan 2014 21:53:23 +0530
Message-Id: <1389025405-3463-2-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.2.227.g53f3478
In-Reply-To: <1389025405-3463-1-git-send-email-artagnon@gmail.com>
References: <1389025405-3463-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename cpufrequtils -> cpupower, and libcpufreq -> libcpupower.

Cc: Thomas Renninger <trenn@suse.de>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/power/cpupower/README | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/power/cpupower/README b/tools/power/cpupower/README
index fd9d4c0..96ff1ff 100644
--- a/tools/power/cpupower/README
+++ b/tools/power/cpupower/README
@@ -1,4 +1,4 @@
-The cpufrequtils package (homepage: 
+The cpupower package (homepage:
 http://www.kernel.org/pub/linux/utils/kernel/cpufreq/cpufrequtils.html ) 
 consists of the following elements:
 
@@ -11,10 +11,10 @@ providing cpuid.h is needed.
 For both it's not explicitly checked for (yet).
 
 
-libcpufreq
+libcpupower
 ----------
 
-"libcpufreq" is a library which offers a unified access method for userspace
+"libcpupower" is a library which offers a unified access method for userspace
 tools and programs to the cpufreq core and drivers in the Linux kernel. This
 allows for code reduction in userspace tools, a clean implementation of
 the interaction to the cpufreq core, and support for both the sysfs and proc
@@ -28,7 +28,7 @@ make
 su
 make install
 
-should suffice on most systems. It builds default libcpufreq,
+should suffice on most systems. It builds default libcpupower,
 cpufreq-set and cpufreq-info files and installs them in /usr/lib and
 /usr/bin, respectively. If you want to set up the paths differently and/or
 want to configure the package to your specific needs, you need to open
@@ -39,11 +39,11 @@ CONFIGURATION.
 THANKS
 ------
 Many thanks to Mattia Dongili who wrote the autotoolization and
-libtoolization, the manpages and the italian language file for cpufrequtils;
+libtoolization, the manpages and the italian language file for cpupower;
 to Dave Jones for his feedback and his dump_psb tool; to Bruno Ducrot for his
 powernow-k8-decode and intel_gsic tools as well as the french language file;
 and to various others commenting on the previous (pre-)releases of 
-cpufrequtils.
+cpupower.
 
 
         Dominik Brodowski
-- 
1.8.5.2.227.g53f3478

