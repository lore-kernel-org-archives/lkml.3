Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851AbaFAMUH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 08:20:07 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:47384 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757012AbaFAMUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 08:20:03 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 21/26] staging: rtl8188eu: Remove unused member variable of struct adapter
Date: Sun,  1 Jun 2014 17:46:47 +0530
Message-Id: <1401625013-11208-21-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
References: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/drv_types.h |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/drv_types.h b/drivers/staging/rtl8188eu/include/drv_types.h
index 9cdab6a..a459206 100644
--- a/drivers/staging/rtl8188eu/include/drv_types.h
+++ b/drivers/staging/rtl8188eu/include/drv_types.h
@@ -189,7 +189,6 @@ static inline struct device *dvobj_to_dev(struct dvobj_priv *dvobj)
 
 struct adapter {
 	int	pid[3];/* process id from UI, 0:wps, 1:hostapd, 2:dhcpcd */
-	int	bDongle;/* build-in module or external dongle */
 	u16	chip_type;
 
 	struct dvobj_priv *dvobj;
@@ -221,19 +220,11 @@ struct adapter {
 	s32	bSurpriseRemoved;
 	s32	bCardDisableWOHSM;
 
-	u32	IsrContent;
-	u32	ImrContent;
-
 	u8	EepromAddressSize;
 	u8	hw_init_completed;
-	u8	bDriverIsGoingToUnload;
-	u8	init_adpt_in_progress;
-	u8	bHaltInProgress;
 
 	void *cmdThread;
 	void *evtThread;
-	void *xmitThread;
-	void *recvThread;
 	void (*intf_start)(struct adapter *adapter);
 	void (*intf_stop)(struct adapter *adapter);
 	struct  net_device *pnetdev;
@@ -253,7 +244,6 @@ struct adapter {
 
 	int net_closed;
 	u8 bFWReady;
-	u8 bBTFWReady;
 	u8 bReadPortCancel;
 	u8 bWritePortCancel;
 	u8 bRxRSSIDisplay;
-- 
1.7.10.4

