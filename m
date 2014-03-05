Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbaCESFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 13:05:24 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:38809 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbaCESFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 13:05:23 -0500
From: jon@ringle.org
To: plagnioj@jcrosoft.com, tomi.valkeinen@ti.com
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jon Ringle <jringle@gridpoint.com>
Subject: [PATCH] video: da8xx-fb: Add support for Densitron 84-0023-001T
Date: Wed,  5 Mar 2014 13:05:11 -0500
Message-Id: <1394042711-7907-1-git-send-email-jon@ringle.org>
X-Mailer: git-send-email 1.8.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jon Ringle <jringle@gridpoint.com>

Signed-off-by: Jon Ringle <jringle@gridpoint.com>
---
 drivers/video/da8xx-fb.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index e7f5937..83c43b2 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -243,6 +243,20 @@ static struct fb_videomode known_lcd_panels[] = {
 		.sync           = FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
 		.flag           = 0,
 	},
+	[3] = {
+		/* Densitron 84-0023-001T */
+		.name           = "Densitron_LCD",
+		.xres           = 320,
+		.yres           = 240,
+		.pixclock       = KHZ2PICOS(6400),
+		.left_margin    = 0,
+		.right_margin   = 0,
+		.upper_margin   = 0,
+		.lower_margin   = 0,
+		.hsync_len      = 30,
+		.vsync_len      = 3,
+		.sync           = 0,
+	},
 };
 
 static bool da8xx_fb_is_raster_enabled(void)
-- 
1.8.5.4

