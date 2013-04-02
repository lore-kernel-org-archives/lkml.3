Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762155Ab3DBSW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:22:27 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:52165 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761993Ab3DBSUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:20:34 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: tomi.valkeinen@ti.com
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-arm-kernel@lists.infradead.org, plagnioj@jcrosoft.com,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCHv3 3/6] video: vt8500: Correct descriptions in video/Kconfig
Date: Wed,  3 Apr 2013 07:20:35 +1300
Message-Id: <1364926838-6721-4-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364926838-6721-1-git-send-email-linux@prisktech.co.nz>
References: <1364926838-6721-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch corrects the descriptions for the VIA VT8500 and
Wondermedia WM8xxx-series framebuffer drivers to correctly reflect
which hardware they support.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
Reviewed-by: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
---
 drivers/video/Kconfig |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 661aa54..ad762ed 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -1789,7 +1789,7 @@ config FB_AU1200
 	  option au1200fb:panel=<name>.
 
 config FB_VT8500
-	bool "VT8500 LCD Driver"
+	bool "VIA VT8500 framebuffer support"
 	depends on (FB = y) && ARM && ARCH_VT8500
 	select FB_SYS_FILLRECT if (!FB_WMT_GE_ROPS)
 	select FB_SYS_COPYAREA if (!FB_WMT_GE_ROPS)
@@ -1799,17 +1799,18 @@ config FB_VT8500
 	  controller.
 
 config FB_WM8505
-	bool "WM8505 frame buffer support"
+	bool "Wondermedia WM8xxx-series frame buffer support"
 	depends on (FB = y) && ARM && ARCH_VT8500
 	select FB_SYS_FILLRECT if (!FB_WMT_GE_ROPS)
 	select FB_SYS_COPYAREA if (!FB_WMT_GE_ROPS)
 	select FB_SYS_IMAGEBLIT
 	help
-	  This is the framebuffer driver for WonderMedia WM8505/WM8650
-	  integrated LCD controller.
+	  This is the framebuffer driver for WonderMedia WM8xxx-series
+	  integrated LCD controller. This driver covers the WM8505, WM8650
+	  and WM8850 SoCs.
 
 config FB_WMT_GE_ROPS
-	bool "VT8500/WM85xx accelerated raster ops support"
+	bool "VT8500/WM8xxx accelerated raster ops support"
 	depends on (FB = y) && (FB_VT8500 || FB_WM8505)
 	default n
 	help
-- 
1.7.9.5

