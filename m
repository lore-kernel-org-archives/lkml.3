Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937745Ab3DKAL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 20:11:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64606 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937392Ab3DKAGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 20:06:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 14/30] thermal/exynos: remove unnecessary header inclusions
Date: Thu, 11 Apr 2013 02:04:56 +0200
Message-Id: <1365638712-1028578-15-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:Tuqy+8oWwSOMxQNarcfP31yA5nYPw81TrApqRgH1HH9
 eoZTDvBXf2W+KhO5o50W0QBZSTBp0IaX7k5L68HyK33hoNj9Tk
 P6lmRL4xOLxRdbmQrsrGTmPVtc8kNIZiqzRlnZWTzFSFNrgIrG
 Eqoz+dlQl5vYErIfWYE9RnDmmx8p8n5V3/sbPGFk9PNpRNYTeZ
 X8S9sU4buR3DTSAv++LPlumba0ZTVN4PfA8wgClOTUPdESO+I6
 uo7kR39xBqOoeEYra3LKwEOatS2fMRw1J2u8NJINe8+xNZ88+V
 wlUKumlxRfwjBvmUWHJ2J3jG2LpSSpCTUNktz79w6IMBLwc0ZB
 GvgLww/gcaC8gWHZbN1BYQ8IhKaixOGPv88W0xb5RiCGtvnC0i
 ARkIYaf3FHm1g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In multiplatform configurations, we cannot include headers
provided by only the exynos platform. Fortunately a number
of drivers that include those headers do not actually need
them, so we can just remove the inclusions.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: linux-pm@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>
---
 drivers/thermal/exynos_thermal.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
index 46568c0..b777ae6 100644
--- a/drivers/thermal/exynos_thermal.c
+++ b/drivers/thermal/exynos_thermal.c
@@ -39,8 +39,6 @@
 #include <linux/cpu_cooling.h>
 #include <linux/of.h>
 
-#include <plat/cpu.h>
-
 /* Exynos generic registers */
 #define EXYNOS_TMU_REG_TRIMINFO		0x0
 #define EXYNOS_TMU_REG_CONTROL		0x20
-- 
1.8.1.2

