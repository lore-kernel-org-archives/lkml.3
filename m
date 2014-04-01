Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511AbaDAMjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:39:49 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:62034 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaDAMjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 08:39:47 -0400
From: jon@ringle.org
To: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Cc: tomi.valkeinen@ti.com, plagnioj@jcrosoft.com,
        Jon Ringle <jringle@gridpoint.com>
Subject: [PATCH v3 1/2] video: da8xx-fb: Add support for Densitron 84-0023-001T
Date: Tue,  1 Apr 2014 08:39:33 -0400
Message-Id: <1396355974-2257-1-git-send-email-jon@ringle.org>
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
index e030e17..233f65f 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -243,6 +243,20 @@ static struct fb_videomode known_lcd_panels[] = {
 		.sync           = FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
 		.flag           = 0,
 	},
+	[3] = {
+		/* Densitron 84-0023-001T */
+		.name           = "Densitron_84-0023-001T",
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

