Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983Ab3DZKi3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 06:38:29 -0400
Received: from mail-da0-f49.google.com ([209.85.210.49]:62142 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759959Ab3DZKiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 06:38:23 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.kachhap@gmail.com,
        Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH V2 03/20] thermal: exynos: Rename exynos_thermal.c to exynos_tmu.c
Date: Fri, 26 Apr 2013 16:07:34 +0530
Message-Id: <1366972671-9227-4-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1366972671-9227-1-git-send-email-amit.daniel@samsung.com>
References: <1366972671-9227-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch renames exynos_thermal.c to exynos_tmu.c. This change is needed as
this file now just contains exynos tmu driver related codes and thermal zone
or cpufreq cooling registration related changes are not there anymore.

Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/samsung/Makefile                   |    2 +-
 .../samsung/{exynos_thermal.c => exynos_tmu.c}     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
 rename drivers/thermal/samsung/{exynos_thermal.c => exynos_tmu.c} (99%)

diff --git a/drivers/thermal/samsung/Makefile b/drivers/thermal/samsung/Makefile
index fcda5b4..75e1f97 100644
--- a/drivers/thermal/samsung/Makefile
+++ b/drivers/thermal/samsung/Makefile
@@ -2,5 +2,5 @@
 # Samsung thermal specific Makefile
 #
 obj-$(CONFIG_EXYNOS_SOC_THERMAL)		+= exynos_soc_thermal.o
-exynos_soc_thermal-y				:= exynos_thermal.o
+exynos_soc_thermal-y				:= exynos_tmu.o
 exynos_soc_thermal-$(CONFIG_EXYNOS_COMMON)	+= exynos_thermal_common.o
diff --git a/drivers/thermal/samsung/exynos_thermal.c b/drivers/thermal/samsung/exynos_tmu.c
similarity index 99%
rename from drivers/thermal/samsung/exynos_thermal.c
rename to drivers/thermal/samsung/exynos_tmu.c
index 4c85945..3de3e61 100644
--- a/drivers/thermal/samsung/exynos_thermal.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -1,5 +1,5 @@
 /*
- * exynos_thermal.c - Samsung EXYNOS TMU (Thermal Management Unit)
+ * exynos_tmu.c - Samsung EXYNOS TMU (Thermal Management Unit)
  *
  *  Copyright (C) 2011 Samsung Electronics
  *  Donggeun Kim <dg77.kim@samsung.com>
-- 
1.7.1

