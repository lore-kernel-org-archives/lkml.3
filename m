Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbaEWTYt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 15:24:49 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:39509 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaEWTYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 15:24:48 -0400
From: Chaitanya Hazarey <c@24.io>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, ebru.akagunduz@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, c@24.io
Subject: [PATCH] Staging: xgifb: Fixed a code-style warning
Date: Fri, 23 May 2014 12:24:37 -0700
Message-Id: <1400873077-32402-1-git-send-email-c@24.io>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a blank line after declarations to fix the following warning issued by checkpatch.pl:

drivers/staging/xgifb/vb_init.c:800: WARNING: Missing a blank line after declarations

Signed-off-by: Chaitanya Hazarey <c@24.io>
---
 drivers/staging/xgifb/vb_setmode.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index c638c8f..8795e17 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -5462,6 +5462,7 @@ unsigned char XGISetModeNew(struct xgifb_video_info *xgifb_info,
 	unsigned short ModeIdIndex;
 	struct vb_device_info VBINF;
 	struct vb_device_info *pVBInfo = &VBINF;
+
 	pVBInfo->IF_DEF_LVDS = 0;
 
 	if (HwDeviceExtension->jChipType >= XG20)
-- 
1.7.9.5

