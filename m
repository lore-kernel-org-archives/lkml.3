Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab3FGUsl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 16:48:41 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44111 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab3FGUsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 16:48:38 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <tony@atomide.com>, <grant.likely@linaro.org>
CC: <linux-pm@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux@arm.linux.org.uk>, Eduardo Valentin <eduardo.valentin@ti.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        AnilKumar Ch <anilkumar@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv3 5/6] arm: omap2plus_defconfig: enable TI bandgap driver
Date: Fri, 7 Jun 2013 16:46:07 -0400
Message-ID: <1370637968-23299-6-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1370637968-23299-1-git-send-email-eduardo.valentin@ti.com>
References: <1370637968-23299-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the bandgap driver for TI SoCs thermal support.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: AnilKumar Ch <anilkumar@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 arch/arm/configs/omap2plus_defconfig | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
index c1ef64b..6e6c494 100644
--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -151,6 +151,13 @@ CONFIG_W1=y
 CONFIG_POWER_SUPPLY=y
 CONFIG_SENSORS_LM75=m
 CONFIG_WATCHDOG=y
+CONFIG_THERMAL=y
+CONFIG_THERMAL_HWMON=y
+CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
+CONFIG_THERMAL_GOV_FAIR_SHARE=y
+CONFIG_THERMAL_GOV_STEP_WISE=y
+CONFIG_THERMAL_GOV_USER_SPACE=y
+CONFIG_CPU_THERMAL=y
 CONFIG_OMAP_WATCHDOG=y
 CONFIG_TWL4030_WATCHDOG=y
 CONFIG_MFD_TPS65217=y
@@ -237,6 +244,10 @@ CONFIG_RTC_DRV_TWL4030=y
 CONFIG_RTC_DRV_OMAP=y
 CONFIG_DMADEVICES=y
 CONFIG_DMA_OMAP=y
+CONFIG_TI_SOC_THERMAL=y
+CONFIG_TI_THERMAL=y
+CONFIG_OMAP4_THERMAL=y
+CONFIG_OMAP5_THERMAL=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 # CONFIG_EXT3_FS_XATTR is not set
-- 
1.8.2.1.342.gfa7285d

