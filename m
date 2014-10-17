Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbaJQNNz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 09:13:55 -0400
Received: from mail.logicbricks.com ([89.201.165.134]:17285 "EHLO
	mail.logicbricks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbaJQNNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 09:13:04 -0400
From: Davor Joja <davorjoja@logicbricks.com>
To: <linux-kernel@vger.kernel.org>
CC: Davor Joja <davorjoja@logicbricks.com>
Subject: [PATCH 08/10] fbdev: Xylon framebuffer driver to fbdev Kconfig and Makefile
Date: Fri, 17 Oct 2014 15:06:59 +0200
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413551221-15187-1-git-send-email-davorjoja@logicbricks.com>
References: <1413551221-15187-1-git-send-email-davorjoja@logicbricks.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.0.95]
Message-ID: <2c72d71f-1ade-45ad-bea5-57068d3d2191@mail.xylon.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Xylon framebuffer driver to fbdev Kconfig and Makefile.

Signed-off-by: Davor Joja <davorjoja@logicbricks.com>
---
 drivers/video/fbdev/Kconfig  | 1 +
 drivers/video/fbdev/Makefile | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index ccbe2ae..9fb8dcc 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -2473,6 +2473,7 @@ source "drivers/video/fbdev/omap/Kconfig"
 source "drivers/video/fbdev/omap2/Kconfig"
 source "drivers/video/fbdev/exynos/Kconfig"
 source "drivers/video/fbdev/mmp/Kconfig"
+source "drivers/video/fbdev/xylon/Kconfig"
 
 config FB_SH_MOBILE_MERAM
 	tristate "SuperH Mobile MERAM read ahead support"
diff --git a/drivers/video/fbdev/Makefile b/drivers/video/fbdev/Makefile
index 1979aff..537fcb2 100644
--- a/drivers/video/fbdev/Makefile
+++ b/drivers/video/fbdev/Makefile
@@ -132,6 +132,7 @@ obj-$(CONFIG_FB_JZ4740)		  += jz4740_fb.o
 obj-$(CONFIG_FB_PUV3_UNIGFX)      += fb-puv3.o
 obj-$(CONFIG_FB_HYPERV)		  += hyperv_fb.o
 obj-$(CONFIG_FB_OPENCORES)	  += ocfb.o
+obj-y                             += xylon/
 
 # Platform or fallback drivers go here
 obj-$(CONFIG_FB_UVESA)            += uvesafb.o
-- 
1.9.1

