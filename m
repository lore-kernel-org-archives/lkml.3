Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbaKJLke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 06:40:34 -0500
Received: from mail.kapsi.fi ([217.30.184.167]:34176 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbaKJLkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 06:40:33 -0500
From: Mikko Perttunen <mikko.perttunen@kapsi.fi>
To: viresh.kumar@linaro.org
Cc: swarren@wwwdotorg.org, thierry.reding@gmail.com, gnurou@gmail.com,
        pdeschrijver@nvidia.com, rjw@rjwysocki.net, mturquette@linaro.org,
        pwalmsley@nvidia.com, vinceh@nvidia.com, pgaikwad@nvidia.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        tuomas.tynkkynen@iki.fi, Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        Mikko Perttunen <mikko.perttunen@kapsi.fi>
Subject: [PATCH v5 12/16] cpufreq: tegra: Rename tegra-cpufreq to tegra20-cpufreq
Date: Mon, 10 Nov 2014 13:40:19 +0200
Message-Id: <1415619619-2765-1-git-send-email-mikko.perttunen@kapsi.fi>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <CAKohpo=Kdh2vuvSoQBLdWfZJn3xDezpNBjqM389u45_BdizPXQ@mail.gmail.com>
References: <CAKohpo=Kdh2vuvSoQBLdWfZJn3xDezpNBjqM389u45_BdizPXQ@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:708:30:12d0:beee:7bff:fe5b:f272
X-SA-Exim-Mail-From: mikko.perttunen@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>

The Tegra124 will use a different driver for frequency scaling, so
rename the old driver (which handles only Tegra20) appropriately.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Signed-off-by: Mikko Perttunen <mikko.perttunen@kapsi.fi>
---
Sorry, I was not aware of those options.

 drivers/cpufreq/Kconfig.arm                            | 6 +++---
 drivers/cpufreq/Makefile                               | 2 +-
 drivers/cpufreq/{tegra-cpufreq.c => tegra20-cpufreq.c} | 0
 3 files changed, 4 insertions(+), 4 deletions(-)
 rename drivers/cpufreq/{tegra-cpufreq.c => tegra20-cpufreq.c} (100%)

diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index 83a75dc..22419f4 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -241,9 +241,9 @@ config ARM_SPEAR_CPUFREQ
 	help
 	  This adds the CPUFreq driver support for SPEAr SOCs.
 
-config ARM_TEGRA_CPUFREQ
-	bool "TEGRA CPUFreq support"
+config ARM_TEGRA20_CPUFREQ
+	bool "Tegra20 CPUFreq support"
 	depends on ARCH_TEGRA
 	default y
 	help
-	  This adds the CPUFreq driver support for TEGRA SOCs.
+	  This adds the CPUFreq driver support for Tegra20 SOCs.
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index 40c53dc..0d3ec1c 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -75,7 +75,7 @@ obj-$(CONFIG_ARM_S5PV210_CPUFREQ)	+= s5pv210-cpufreq.o
 obj-$(CONFIG_ARM_SA1100_CPUFREQ)	+= sa1100-cpufreq.o
 obj-$(CONFIG_ARM_SA1110_CPUFREQ)	+= sa1110-cpufreq.o
 obj-$(CONFIG_ARM_SPEAR_CPUFREQ)		+= spear-cpufreq.o
-obj-$(CONFIG_ARM_TEGRA_CPUFREQ)		+= tegra-cpufreq.o
+obj-$(CONFIG_ARM_TEGRA20_CPUFREQ)	+= tegra20-cpufreq.o
 obj-$(CONFIG_ARM_VEXPRESS_SPC_CPUFREQ)	+= vexpress-spc-cpufreq.o
 
 ##################################################################################
diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra20-cpufreq.c
similarity index 100%
rename from drivers/cpufreq/tegra-cpufreq.c
rename to drivers/cpufreq/tegra20-cpufreq.c
-- 
2.1.3

