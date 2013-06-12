Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab3FLIVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 04:21:23 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:42559 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819Ab3FLIVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 04:21:20 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com, arnd@arndb.de,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Eric Miao <eric.y.miao@gmail.com>
Subject: [PATCH 08/11] cpufreq: pxa: select CPU_FREQ_TABLE
Date: Wed, 12 Jun 2013 13:45:15 +0530
Message-Id: <84ae068c277e32cebbf3bf869e89798f88332106.1371022830.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1371022830.git.viresh.kumar@linaro.org>
References: <cover.1371022830.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1371022830.git.viresh.kumar@linaro.org>
References: <cover.1371022830.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPUFreq driver of this platform uses APIs from freq_table.c and so must select
CPU_FREQ_TABLE.

Cc: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/mach-pxa/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mach-pxa/Kconfig b/arch/arm/mach-pxa/Kconfig
index 96100db..a842711 100644
--- a/arch/arm/mach-pxa/Kconfig
+++ b/arch/arm/mach-pxa/Kconfig
@@ -615,12 +615,14 @@ endmenu
 config PXA25x
 	bool
 	select CPU_XSCALE
+	select CPU_FREQ_TABLE if CPU_FREQ
 	help
 	  Select code specific to PXA21x/25x/26x variants
 
 config PXA27x
 	bool
 	select CPU_XSCALE
+	select CPU_FREQ_TABLE if CPU_FREQ
 	help
 	  Select code specific to PXA27x variants
 
@@ -633,6 +635,7 @@ config CPU_PXA26x
 config PXA3xx
 	bool
 	select CPU_XSC3
+	select CPU_FREQ_TABLE if CPU_FREQ
 	help
 	  Select code specific to PXA3xx variants
 
-- 
1.7.12.rc2.18.g61b472e

