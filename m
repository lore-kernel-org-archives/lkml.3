Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab3EMJXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 05:23:50 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:54952 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750912Ab3EMJXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 05:23:49 -0400
Message-ID: <1368437025.1350.35.camel@x61.thuisdomein>
Subject: [PATCH] cpufreq: rename references to CPU_FREQ_SA11x0
From: Paul Bolle <pebolle@tiscali.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 13 May 2013 11:23:45 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 May 2013 09:23:46.0242 (UTC) FILETIME=[91B5EA20:01CE4FBB]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbols CPU_FREQ_SA1100 and CPU_FREQ_SA1110 were renamed in
commit 59a2e613d0 ("cpufreq: sa11x0: move cpufreq driver to
drivers/cpufreq"). Rename the last references to those symbols too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 drivers/cpufreq/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index a1488f5..534fcb8 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -47,7 +47,7 @@ config CPU_FREQ_STAT_DETAILS
 
 choice
 	prompt "Default CPUFreq governor"
-	default CPU_FREQ_DEFAULT_GOV_USERSPACE if CPU_FREQ_SA1100 || CPU_FREQ_SA1110
+	default CPU_FREQ_DEFAULT_GOV_USERSPACE if ARM_SA1100_CPUFREQ || ARM_SA1110_CPUFREQ
 	default CPU_FREQ_DEFAULT_GOV_PERFORMANCE
 	help
 	  This option sets which CPUFreq governor shall be loaded at
-- 
1.7.11.7

