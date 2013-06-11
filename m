Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab3FKNDH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 09:03:07 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:42864 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207Ab3FKMyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 08:54:20 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.kachhap@gmail.com, Kukjin Kim <kgene.kim@samsung.com>,
        jonghwa3.lee@samsung.com
Subject: [PATCH V5 05/30] thermal: exynos: Rename exynos_thermal.c to exynos_tmu.c
Date: Tue, 11 Jun 2013 18:23:15 +0530
Message-Id: <1370955220-2949-6-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1370955220-2949-1-git-send-email-amit.daniel@samsung.com>
References: <1370955220-2949-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch renames exynos_thermal.c to exynos_tmu.c. This change is needed as
this file now just contains exynos tmu driver related codes and thermal zone
or cpufreq cooling registration related changes are not there anymore.

Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/samsung/Makefile                   |    6 +++---
 .../samsung/{exynos_thermal.c => exynos_tmu.c}     |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)
 rename drivers/thermal/samsung/{exynos_thermal.c => exynos_tmu.c} (99%)

diff --git a/drivers/thermal/samsung/Makefile b/drivers/thermal/samsung/Makefile
index 6227d4f..22528d6 100644
--- a/drivers/thermal/samsung/Makefile
+++ b/drivers/thermal/samsung/Makefile
@@ -1,6 +1,6 @@
 #
 # Samsung thermal specific Makefile
 #
-obj-$(CONFIG_EXYNOS_THERMAL)			+= exynos_soc_thermal.o
-exynos_soc_thermal-y				:= exynos_thermal.o
-exynos_soc_thermal-$(CONFIG_EXYNOS_THERMAL_CORE) += exynos_thermal_common.o
+obj-$(CONFIG_EXYNOS_THERMAL)			+= exynos_thermal.o
+exynos_thermal-y				:= exynos_tmu.o
+exynos_thermal-$(CONFIG_EXYNOS_THERMAL_CORE)	+= exynos_thermal_common.o
diff --git a/drivers/thermal/samsung/exynos_thermal.c b/drivers/thermal/samsung/exynos_tmu.c
similarity index 99%
rename from drivers/thermal/samsung/exynos_thermal.c
rename to drivers/thermal/samsung/exynos_tmu.c
index 5293849..22a8874 100644
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

