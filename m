Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab3FLIU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 04:20:58 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:58231 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819Ab3FLIUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 04:20:53 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com, arnd@arndb.de,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 06/11] cpufreq: imx: select CPU_FREQ_TABLE
Date: Wed, 12 Jun 2013 13:45:13 +0530
Message-Id: <7568bf22f9e40425bb0fe86cd6f44c4dc2d0c7c5.1371022830.git.viresh.kumar@linaro.org>
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

Cc: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/Kconfig.arm | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index 891dd1c..dc26303 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -72,6 +72,7 @@ config ARM_IMX6Q_CPUFREQ
 	tristate "Freescale i.MX6Q cpufreq support"
 	depends on SOC_IMX6Q
 	depends on REGULATOR_ANATOP
+	select CPU_FREQ_TABLE
 	help
 	  This adds cpufreq driver support for Freescale i.MX6Q SOC.
 
-- 
1.7.12.rc2.18.g61b472e

