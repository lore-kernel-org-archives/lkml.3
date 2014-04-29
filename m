Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934008AbaD2MWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 08:22:44 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:65472 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933447AbaD2MWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 08:22:41 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: plagnioj@jcrosoft.com, tomi.valkeinen@ti.com, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH 1/2] video: fbdev: Fix format string mismatch in wm8505fb.c
Date: Tue, 29 Apr 2014 21:21:54 +0900
Message-Id: <1398774115-15353-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.0.0.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix format string mismatch in contrast_show().

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/video/fbdev/wm8505fb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/wm8505fb.c b/drivers/video/fbdev/wm8505fb.c
index 537d199..d2fafbb 100644
--- a/drivers/video/fbdev/wm8505fb.c
+++ b/drivers/video/fbdev/wm8505fb.c
@@ -162,7 +162,7 @@ static ssize_t contrast_show(struct device *dev,
 	struct fb_info *info = dev_get_drvdata(dev);
 	struct wm8505fb_info *fbi = to_wm8505fb_info(info);
 
-	return sprintf(buf, "%d\n", fbi->contrast);
+	return sprintf(buf, "%u\n", fbi->contrast);
 }
 
 static ssize_t contrast_store(struct device *dev,
-- 
2.0.0.rc1

