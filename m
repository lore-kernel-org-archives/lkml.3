Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbaBISsa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 13:48:30 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62409 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbaBISs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 13:48:26 -0500
From: Richard Weinberger <richard@nod.at>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-usb@vger.kernel.org (open list:USB PHY LAYER),
        linux-kernel@vger.kernel.org (open list),
        linux-fbdev@vger.kernel.org (open list:FRAMEBUFFER LAYER)
Cc: Richard Weinberger <richard@nod.at>
Subject: [PATCH 01/28] Remove CPU_MMP3
Date: Sun,  9 Feb 2014 19:47:39 +0100
Message-Id: <1391971686-9517-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1391971686-9517-1-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol is an orphan, get rid of it.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/usb/phy/Kconfig      | 1 -
 drivers/video/mmp/Kconfig    | 2 +-
 drivers/video/mmp/hw/Kconfig | 2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
index 7d1451d..b9b1c52 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -61,7 +61,6 @@ config KEYSTONE_USB_PHY
 
 config MV_U3D_PHY
 	bool "Marvell USB 3.0 PHY controller Driver"
-	depends on CPU_MMP3
 	select USB_PHY
 	help
 	  Enable this to support Marvell USB 3.0 phy controller for Marvell
diff --git a/drivers/video/mmp/Kconfig b/drivers/video/mmp/Kconfig
index e9ea39e..969925d 100644
--- a/drivers/video/mmp/Kconfig
+++ b/drivers/video/mmp/Kconfig
@@ -1,6 +1,6 @@
 menuconfig MMP_DISP
         tristate "Marvell MMP Display Subsystem support"
-        depends on CPU_PXA910 || CPU_MMP2 || CPU_MMP3 || CPU_PXA988
+        depends on CPU_PXA910 || CPU_MMP2 || CPU_PXA988
         help
 	  Marvell Display Subsystem support.
 
diff --git a/drivers/video/mmp/hw/Kconfig b/drivers/video/mmp/hw/Kconfig
index 02f109a..57b03e2 100644
--- a/drivers/video/mmp/hw/Kconfig
+++ b/drivers/video/mmp/hw/Kconfig
@@ -2,7 +2,7 @@ if MMP_DISP
 
 config MMP_DISP_CONTROLLER
 	bool "mmp display controller hw support"
-	depends on CPU_PXA910 || CPU_MMP2 || CPU_MMP3 || CPU_PXA988
+	depends on CPU_PXA910 || CPU_MMP2 || CPU_PXA988
 	default n
 	help
 		Marvell MMP display hw controller support
-- 
1.8.4.2

