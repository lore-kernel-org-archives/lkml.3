Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831AbaJKFrH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 01:47:07 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:46045 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaJKFrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 01:47:05 -0400
From: Tsung-Han Lin <tsunghan.tw@gmail.com>
To: m.chehab@samsung.com
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH] staging: media: omap24xx: fix missing asterisk
Date: Sat, 11 Oct 2014 13:46:49 +0800
Message-Id: <1413006409-11237-1-git-send-email-tsunghan.tw@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix missing asterisk in one V4L2_INT_WRAPPER_1 usage.
Reported by checkpatch.pl as:

ERROR: space prohibited before that close parenthesis ')'
+V4L2_INT_WRAPPER_1(s_power, enum v4l2_power, );

Signed-off-by: Tsung-Han Lin <tsunghan.tw@gmail.com>
---
 drivers/staging/media/omap24xx/v4l2-int-device.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/omap24xx/v4l2-int-device.h b/drivers/staging/media/omap24xx/v4l2-int-device.h
index 0286c95814ff..94905951245c 100644
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

