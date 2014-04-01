Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397AbaDAKPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 06:15:23 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56356 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbaDAKPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 06:15:22 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <linux@arm.linux.org.uk>, <tony@atomide.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: <tomi.valkeinen@ti.com>, <eduardo.valentin@ti.com>, <arnd@arndb.de>,
        <kishon@ti.com>, <balbi@ti.com>
Subject: [PATCH] ARM: OMAP2+: Fix config name for USB3 PHY
Date: Tue, 1 Apr 2014 15:44:34 +0530
Message-ID: <1396347274-32750-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit a70143 (drivers: phy: usb3/pipe3: Adapt pipe3 driver to Generic PHY
Framework) moved phy-omap-usb3 driver in drivers/usb/phy to drivers/phy and
also renamed the file to phy-ti-pipe3. It also renamed the config from
OMAP_USB3 to TI_PIPE3 in Kconfig. However the config name was not changed in
omap2plus_defconfig. Fixed it here.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/configs/omap2plus_defconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
index a966795..a4e8d01 100644
--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -226,7 +226,7 @@ CONFIG_USB_DWC3=m
 CONFIG_USB_TEST=y
 CONFIG_NOP_USB_XCEIV=y
 CONFIG_OMAP_USB2=y
-CONFIG_OMAP_USB3=y
+CONFIG_TI_PIPE3=y
 CONFIG_AM335X_PHY_USB=y
 CONFIG_USB_GADGET=y
 CONFIG_USB_GADGET_DEBUG=y
-- 
1.7.9.5

