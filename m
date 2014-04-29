Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933981AbaD2MWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 08:22:21 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:56710 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933447AbaD2MWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 08:22:18 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: plagnioj@jcrosoft.com, tomi.valkeinen@ti.com, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH 2/2] video: fbdev: Fix format string mismatch in gbefb.c
Date: Tue, 29 Apr 2014 21:21:55 +0900
Message-Id: <1398774115-15353-2-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.0.0.rc1
In-Reply-To: <1398774115-15353-1-git-send-email-standby24x7@gmail.com>
References: <1398774115-15353-1-git-send-email-standby24x7@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix format string mismatch in gbefb_show_memsize().

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/video/fbdev/gbefb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/gbefb.c b/drivers/video/fbdev/gbefb.c
index 3ec65a8..4aa56ba 100644
--- a/drivers/video/fbdev/gbefb.c
+++ b/drivers/video/fbdev/gbefb.c
@@ -1068,7 +1068,7 @@ static struct fb_ops gbefb_ops = {
 
 static ssize_t gbefb_show_memsize(struct device *dev, struct device_attribute *attr, char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%d\n", gbe_mem_size);
+	return snprintf(buf, PAGE_SIZE, "%u\n", gbe_mem_size);
 }
 
 static DEVICE_ATTR(size, S_IRUGO, gbefb_show_memsize, NULL);
-- 
2.0.0.rc1

