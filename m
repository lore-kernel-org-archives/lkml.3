Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab3HDR6o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 13:58:44 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:35068 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537Ab3HDR6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 13:58:42 -0400
From: kumargauravgupta3@gmail.com
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] Staging:xgifb:Fixed a warning of Space before semicolon
Date: Sun,  4 Aug 2013 23:28:21 +0530
Message-Id: <1375639102-6337-1-git-send-email-kumargauravgupta3@gmail.com>
X-Mailer: git-send-email 1.7.9.5
signed-off-by: Kumar Gaurav <kumargauravgupta3@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kumar Gaurav <kumar@AnandLinux.(none)>

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

