Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbaK3K63 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 05:58:29 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33183 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaK3K62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 05:58:28 -0500
From: Anjana Sasindran <anjanasasindran123@gmail.com>
To: gregkh@linuxfoundation.org, joe@perches.com, m.chehab@samsung.com,
        hans.verkuil@cisco.com
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Anjana Sasindran <anjanasasindran123@gmail.com>
Subject: [PATCH] drivers:staging:media:omap24xx:v4l2-int-device.h: Added a '*' before ')'--(parenthesis closing)
Date: Sun, 30 Nov 2014 16:28:02 +0530
Message-Id: <1417345082-3526-1-git-send-email-anjanasasindran123@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix a checkpatch.pl error:

ERROR: space prohibited before ')' parenthesis closing

Signed-off-by: Anjana Sasindran <anjanasasindran123@gmail.com>
---
 drivers/staging/media/omap24xx/v4l2-int-device.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/omap24xx/v4l2-int-device.h b/drivers/staging/media/omap24xx/v4l2-int-device.h
index 0286c95..9490595 100644
--- a/drivers/staging/media/omap24xx/v4l2-int-device.h
+++ b/drivers/staging/media/omap24xx/v4l2-int-device.h
@@ -292,7 +292,7 @@ V4L2_INT_WRAPPER_1(s_video_routing, struct v4l2_routing, *);
 
 V4L2_INT_WRAPPER_0(dev_init);
 V4L2_INT_WRAPPER_0(dev_exit);
-V4L2_INT_WRAPPER_1(s_power, enum v4l2_power, );
+V4L2_INT_WRAPPER_1(s_power, enum v4l2_power, *);
 V4L2_INT_WRAPPER_1(g_priv, void, *);
 V4L2_INT_WRAPPER_1(g_ifparm, struct v4l2_ifparm, *);
 V4L2_INT_WRAPPER_1(g_needs_reset, void, *);
-- 
1.9.1

