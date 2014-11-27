Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751070AbaK0Pa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 10:30:27 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:55519 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaK0Pa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 10:30:26 -0500
From: Anjana Sasindran <anjanasasindran123@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Anjana Sasindran <anjanasasindran123@gmail.com>
Subject: [PATCH] staging:drivers:rtl8712:drv_types.h: Added blank line after declarations
Date: Thu, 27 Nov 2014 21:00:03 +0530
Message-Id: <1417102203-7093-1-git-send-email-anjanasasindran123@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

        This patch fixes the two checkpatch.pl warnings:

        WARNING:Missing a blank line after declaration

Signed-off-by: Anjana Sasindran <anjanasasindran123@gmail.com>
---
 drivers/staging/rtl8712/drv_types.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8712/drv_types.h b/drivers/staging/rtl8712/drv_types.h
index 3d0a98b..3d8abfa 100644
--- a/drivers/staging/rtl8712/drv_types.h
+++ b/drivers/staging/rtl8712/drv_types.h
@@ -1,4 +1,4 @@
-/******************************************************************************
+0/******************************************************************************
  *
  * Copyright(c) 2007 - 2010 Realtek Corporation. All rights reserved.
  *
@@ -129,6 +129,7 @@ struct dvobj_priv {
 	struct _adapter *padapter;
 	u32 nr_endpoint;
 	u8   ishighspeed;
+
 	uint(*inirp_init)(struct _adapter *adapter);
 	uint(*inirp_deinit)(struct _adapter *adapter);
 	struct usb_device *pusbdev;
@@ -166,6 +167,7 @@ struct _adapter {
 	 pid_t evtThread;
 	struct task_struct *xmitThread;
 	pid_t recvThread;
+
 	uint(*dvobj_init)(struct _adapter *adapter);
 	void (*dvobj_deinit)(struct _adapter *adapter);
 	struct net_device *pnetdev;
-- 
1.9.1

