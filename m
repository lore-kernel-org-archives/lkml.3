Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbaDEVfO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 17:35:14 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:40339 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbaDEVfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 17:35:11 -0400
From: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        silentquote@gmail.com,
        Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
Subject: [PATCH 09/10] driver: staging: wlan-ng: Removed #if 0 lines from hfa384x_usb.c
Date: Sat,  5 Apr 2014 23:35:06 +0200
Message-Id: <1396733706-16048-1-git-send-email-shehabaldin.sherif@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed lines that were ignored by #if 0

Signed-off-by: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
---
 drivers/staging/wlan-ng/hfa384x_usb.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index cf27030..867edb4 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -2019,12 +2019,6 @@ int hfa384x_drvr_flashdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
 	    HFA384x_ADDR_AUX_MKFLAT(hw->bufinfo.page, hw->bufinfo.offset);
 	pr_debug("dlbuf.page=0x%04x dlbuf.offset=0x%04x dlbufaddr=0x%08x\n",
 		 hw->bufinfo.page, hw->bufinfo.offset, dlbufaddr);
-
-#if 0
-	netdev_warn(hw->wlandev->netdev,
-		    "dlbuf@0x%06lx len=%d to=%d\n", dlbufaddr,
-		    hw->bufinfo.len, hw->dltimeout);
-#endif
 	/* Calculations to determine how many fills of the dlbuffer to do
 	 * and how many USB wmemreq's to do for each fill.  At this point
 	 * in time, the dlbuffer size and the wmemreq size are the same.
-- 
1.7.9.5

