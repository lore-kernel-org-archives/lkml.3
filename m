Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552AbaFAMTF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 08:19:05 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:53092 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021AbaFAMTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 08:19:01 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 12/26] staging: rtl8188eu: Remove unused members of struct dvobj_priv
Date: Sun,  1 Jun 2014 17:46:38 +0530
Message-Id: <1401625013-11208-12-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
References: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/drv_types.h |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/drv_types.h b/drivers/staging/rtl8188eu/include/drv_types.h
index d38f861..3181418 100644
--- a/drivers/staging/rtl8188eu/include/drv_types.h
+++ b/drivers/staging/rtl8188eu/include/drv_types.h
@@ -152,7 +152,6 @@ struct rt_firmware {
 
 struct dvobj_priv {
 	struct adapter *if1;
-	struct adapter *if2;
 	struct rt_firmware firmware;
 
 	/* For 92D, DMDP have 2 interface. */
@@ -164,8 +163,6 @@ struct dvobj_priv {
 	int	RtOutPipe[3];
 	u8	Queue2Pipe[HW_QUEUE_ENTRY];/* for out pipe mapping */
 
-	u8	irq_alloc;
-
 /*-------- below is for USB INTERFACE --------*/
 
 	u8	nr_endpoint;
@@ -173,7 +170,6 @@ struct dvobj_priv {
 	u8	RtNumInPipes;
 	u8	RtNumOutPipes;
 	int	ep_num[5]; /* endpoint number */
-	int	RegUsbSS;
 	struct semaphore usb_suspend_sema;
 	struct mutex  usb_vendor_req_mutex;
 
-- 
1.7.10.4

