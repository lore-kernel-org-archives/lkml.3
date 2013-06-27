Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab3F0DnN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 23:43:13 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60687 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024Ab3F0DnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 23:43:09 -0400
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Mark Brown <broonie@linaro.org>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
CC: Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Joel Fernandes <joelf@ti.com>
Subject: [PATCH v2 1/2] ARM: configs: Enable TI_EDMA in omap2plus_defconfig
Date: Wed, 26 Jun 2013 22:42:03 -0500
Message-ID: <1372304523-30742-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Build EDMA in by default to avoid fewer people stepping on their toes
with broken DMA on drivers needing EDMA.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/configs/omap2plus_defconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
index abbe319..7e00deb 100644
--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -236,6 +236,7 @@ CONFIG_RTC_DRV_TWL92330=y
 CONFIG_RTC_DRV_TWL4030=y
 CONFIG_RTC_DRV_OMAP=y
 CONFIG_DMADEVICES=y
+CONFIG_TI_EDMA=y
 CONFIG_DMA_OMAP=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
-- 
1.7.9.5

