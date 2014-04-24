Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660AbaDXQs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:48:58 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:63423 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756268AbaDXQsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:48:51 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
        linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH 2/2] staging: rtl8192e: Fix typo in rtl8192e
Date: Fri, 25 Apr 2014 01:48:41 +0900
Message-Id: <1398358121-26805-2-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.0.0.rc0.26.g779792a
In-Reply-To: <1398358121-26805-1-git-send-email-standby24x7@gmail.com>
References: <1398358121-26805-1-git-send-email-standby24x7@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix spelling typo in comments within rtl8192e.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/staging/rtl8192e/rtl8192e/r8192E_cmdpkt.c | 2 +-
 drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c    | 2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_wx.c        | 2 +-
 drivers/staging/rtl8192e/rtl819x_TSProc.c         | 2 +-
 drivers/staging/rtl8192e/rtllib_rx.c              | 2 +-
 drivers/staging/rtl8192e/rtllib_softmac.c         | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_cmdpkt.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_cmdpkt.c
index 5f10e40..79d86b9 100644
--- a/drivers/staging/rtl8192e/rtl8192e/r8192E_cmdpkt.c
+++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_cmdpkt.c
@@ -373,7 +373,7 @@ u32 cmpk_message_handle_rx(struct net_device *dev,
 		default:
 
 			RT_TRACE(COMP_CMDPKT, "---->cmpk_message_handle_rx():"
-				 "unknow CMD Element\n");
+				 "unknown CMD Element\n");
 			return 1;
 		}
 
diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c
index 5d6d304..b4bfafe 100644
--- a/drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c
+++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c
@@ -1555,7 +1555,7 @@ static bool SetRFPowerState8190(struct net_device *dev,
 
 		default:
 			bResult = false;
-			RT_TRACE(COMP_ERR, "SetRFPowerState8190(): unknow state"
+			RT_TRACE(COMP_ERR, "SetRFPowerState8190(): unknown state"
 				 " to set: 0x%X!!!\n", eRFPowerState);
 			break;
 		}
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
index 498995d..59494f5 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
@@ -1213,7 +1213,7 @@ static iw_handler r8192_wx_handlers[] = {
 };
 
 /*
- * the following rule need to be follwing,
+ * the following rule need to be following,
  * Odd : get (world access),
  * even : set (root access)
  * */
diff --git a/drivers/staging/rtl8192e/rtl819x_TSProc.c b/drivers/staging/rtl8192e/rtl819x_TSProc.c
index 29608e5..52b2977 100644
--- a/drivers/staging/rtl8192e/rtl819x_TSProc.c
+++ b/drivers/staging/rtl8192e/rtl819x_TSProc.c
@@ -79,7 +79,7 @@ static void RxPktPendingTimeout(unsigned long data)
 
 		if (index > REORDER_WIN_SIZE) {
 			RTLLIB_DEBUG(RTLLIB_DL_ERR, "RxReorderIndicatePacket():"
-				     " Rx Reorer struct buffer full!!\n");
+				     " Rx Reorder struct buffer full!!\n");
 			spin_unlock_irqrestore(&(ieee->reorder_spinlock),
 					       flags);
 			return;
diff --git a/drivers/staging/rtl8192e/rtllib_rx.c b/drivers/staging/rtl8192e/rtllib_rx.c
index 6c8a8e1..7413816 100644
--- a/drivers/staging/rtl8192e/rtllib_rx.c
+++ b/drivers/staging/rtl8192e/rtllib_rx.c
@@ -712,7 +712,7 @@ static void RxReorderIndicatePacket(struct rtllib_device *ieee,
 
 		if (index > REORDER_WIN_SIZE) {
 			RTLLIB_DEBUG(RTLLIB_DL_ERR, "RxReorderIndicatePacket():"
-				     " Rx Reorer struct buffer full!!\n");
+				     " Rx Reorder struct buffer full!!\n");
 			spin_unlock_irqrestore(&(ieee->reorder_spinlock),
 					       flags);
 			return;
diff --git a/drivers/staging/rtl8192e/rtllib_softmac.c b/drivers/staging/rtl8192e/rtllib_softmac.c
index 4bf72bc..d65cba4 100644
--- a/drivers/staging/rtl8192e/rtllib_softmac.c
+++ b/drivers/staging/rtl8192e/rtllib_softmac.c
@@ -543,7 +543,7 @@ void rtllib_softmac_scan_syncro(struct rtllib_device *ieee, u8 is_mesh)
 				goto out; /* scan completed */
 		} while (!ieee->active_channel_map[ch]);
 
-		/* this fuction can be called in two situations
+		/* this function can be called in two situations
 		 * 1- We have switched to ad-hoc mode and we are
 		 *    performing a complete syncro scan before conclude
 		 *    there are no interesting cell and to create a
-- 
2.0.0.rc0.26.g779792a

