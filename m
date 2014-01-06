Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbaAFQYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:24:05 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:53193 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578AbaAFQXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:23:30 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Renninger <trenn@suse.de>,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [PATCH 3/3] cpupower tools: update uninstall target
Date: Mon,  6 Jan 2014 21:53:25 +0530
Message-Id: <1389025405-3463-4-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.2.227.g53f3478
In-Reply-To: <1389025405-3463-1-git-send-email-artagnon@gmail.com>
References: <1389025405-3463-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Thomas Renninger <trenn@suse.de>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/power/cpupower/Makefile | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/power/cpupower/Makefile b/tools/power/cpupower/Makefile
index cbfec92..dca6b43 100644
--- a/tools/power/cpupower/Makefile
+++ b/tools/power/cpupower/Makefile
@@ -295,8 +295,12 @@ uninstall:
 	- rm -f $(DESTDIR)${libdir}/libcpupower.*
 	- rm -f $(DESTDIR)${includedir}/cpufreq.h
 	- rm -f $(DESTDIR)${bindir}/utils/cpupower
-	- rm -f $(DESTDIR)${mandir}/man1/cpufreq-set.1
-	- rm -f $(DESTDIR)${mandir}/man1/cpufreq-info.1
+	- rm -f $(DESTDIR)${mandir}/man1/cpupower.1
+	- rm -f $(DESTDIR)${mandir}/man1/cpupower-frequency-set.1
+	- rm -f $(DESTDIR)${mandir}/man1/cpupower-frequency-info.1
+	- rm -f $(DESTDIR)${mandir}/man1/cpupower-set.1
+	- rm -f $(DESTDIR)${mandir}/man1/cpupower-info.1
+	- rm -f $(DESTDIR)${mandir}/man1/cpupower-monitor.1
 	- for HLANG in $(LANGUAGES); do \
 		rm -f $(DESTDIR)${localedir}/$$HLANG/LC_MESSAGES/cpupower.mo; \
 	  done;
-- 
1.8.5.2.227.g53f3478

