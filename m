Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbaAFQXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:23:32 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:42167 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575AbaAFQXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:23:30 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Renninger <trenn@suse.de>,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [PATCH 2/3] cpupower tools: update README
Date: Mon,  6 Jan 2014 21:53:24 +0530
Message-Id: <1389025405-3463-3-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.2.227.g53f3478
In-Reply-To: <1389025405-3463-1-git-send-email-artagnon@gmail.com>
References: <1389025405-3463-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove dead link to homepage, and update the targets built.

Cc: Thomas Renninger <trenn@suse.de>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/power/cpupower/README | 16 +++++++---------
 tools/power/cpupower/ToDo   |  1 -
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/tools/power/cpupower/README b/tools/power/cpupower/README
index 96ff1ff..1c68f47 100644
--- a/tools/power/cpupower/README
+++ b/tools/power/cpupower/README
@@ -1,6 +1,4 @@
-The cpupower package (homepage:
-http://www.kernel.org/pub/linux/utils/kernel/cpufreq/cpufrequtils.html ) 
-consists of the following elements:
+The cpupower package consists of the following elements:
 
 requirements
 ------------
@@ -28,12 +26,12 @@ make
 su
 make install
 
-should suffice on most systems. It builds default libcpupower,
-cpufreq-set and cpufreq-info files and installs them in /usr/lib and
-/usr/bin, respectively. If you want to set up the paths differently and/or
-want to configure the package to your specific needs, you need to open
-"Makefile" with an editor of your choice and edit the block marked
-CONFIGURATION.
+should suffice on most systems. It builds libcpupower to put in
+/usr/lib; cpupower, cpufreq-bench_plot.sh to put in /usr/bin; and
+cpufreq-bench to put in /usr/sbin. If you want to set up the paths
+differently and/or want to configure the package to your specific
+needs, you need to open "Makefile" with an editor of your choice and
+edit the block marked CONFIGURATION.
 
 
 THANKS
diff --git a/tools/power/cpupower/ToDo b/tools/power/cpupower/ToDo
index 874b78b..6e8b89f 100644
--- a/tools/power/cpupower/ToDo
+++ b/tools/power/cpupower/ToDo
@@ -3,7 +3,6 @@ ToDos sorted by priority:
 - Use bitmask functions to parse CPU topology more robust
   (current implementation has issues on AMD)
 - Try to read out boost states and frequencies on Intel
-- Adjust README
 - Somewhere saw the ability to read power consumption of
   RAM from HW on Intel SandyBridge -> another monitor?
 - Add another c1e debug idle monitor
-- 
1.8.5.2.227.g53f3478

