Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab3HDSlT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 14:41:19 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:56490 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab3HDSlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 14:41:18 -0400
From: Kumar Gaurav <kumargauravgupta3@gmail.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Kumar Gaurav <kumargauravgupta3@gmail.com>
Subject: [PATCH] Staging:xgifb:Fixed a warning of Space before semicolon
Date: Mon,  5 Aug 2013 00:11:02 +0530
Message-Id: <1375641662-17378-1-git-send-email-kumargauravgupta3@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed issue by removing Space before semicolon

Signed-off-by: Kumar Gaurav <kumargauravgupta3@gmail.com>
---
 drivers/staging/xgifb/vb_setmode.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/xgifb/vb_setmode.h b/drivers/staging/xgifb/vb_setmode.h
index 2c0a31c..679a822 100644
--- a/drivers/staging/xgifb/vb_setmode.h
+++ b/drivers/staging/xgifb/vb_setmode.h
@@ -13,7 +13,7 @@ extern void XGI_GetVBType(struct vb_device_info *);
 extern void XGI_SenseCRT1(struct vb_device_info *);
 extern unsigned char XGISetModeNew(struct xgifb_video_info *xgifb_info,
 				   struct xgi_hw_device_info *HwDeviceExtension,
-				   unsigned short ModeNo) ;
+				   unsigned short ModeNo);
 
 extern unsigned char XGI_SearchModeID(unsigned short ModeNo,
 				      unsigned short *ModeIdIndex,
-- 
1.7.9.5

