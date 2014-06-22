Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632AbaFVIho (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:37:44 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:51833 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaFVIhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:37:15 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 20/42] staging: rtl8188eu: osdep_service.h: Remove unused macro, enum and variables
Date: Sun, 22 Jun 2014 14:06:26 +0530
Message-Id: <1403426208-12413-4-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403426208-12413-1-git-send-email-navin.patidar@gmail.com>
References: <1403426208-12413-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/osdep_service.h |   27 ---------------------
 1 file changed, 27 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index e9d5309..294b234 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -163,30 +163,6 @@ static inline int rtw_netif_queue_stopped(struct net_device *pnetdev)
 
 extern int RTW_STATUS_CODE(int error_code);
 
-/* flags used for rtw_update_mem_stat() */
-enum {
-	MEM_STAT_VIR_ALLOC_SUCCESS,
-	MEM_STAT_VIR_ALLOC_FAIL,
-	MEM_STAT_VIR_FREE,
-	MEM_STAT_PHY_ALLOC_SUCCESS,
-	MEM_STAT_PHY_ALLOC_FAIL,
-	MEM_STAT_PHY_FREE,
-	MEM_STAT_TX, /* used to distinguish TX/RX, asigned from caller */
-	MEM_STAT_TX_ALLOC_SUCCESS,
-	MEM_STAT_TX_ALLOC_FAIL,
-	MEM_STAT_TX_FREE,
-	MEM_STAT_RX, /* used to distinguish TX/RX, asigned from caller */
-	MEM_STAT_RX_ALLOC_SUCCESS,
-	MEM_STAT_RX_ALLOC_FAIL,
-	MEM_STAT_RX_FREE
-};
-
-extern unsigned char MCS_rate_2R[16];
-extern unsigned char MCS_rate_1R[16];
-extern unsigned char RTW_WPA_OUI[];
-extern unsigned char WPA_TKIP_CIPHER[4];
-extern unsigned char RSN_TKIP_CIPHER[4];
-
 #define rtw_update_mem_stat(flag, sz) do {} while (0)
 u8 *_rtw_malloc(u32 sz);
 void _rtw_mfree(u8 *pbuf, u32 sz);
@@ -277,9 +253,6 @@ static inline u32 bitshift(u32 bitmask)
 	return i;
 }
 
-/*  limitation of path length */
-#define PATH_LENGTH_MAX PATH_MAX
-
 struct rtw_netdev_priv_indicator {
 	void *priv;
 	u32 sizeof_priv;
-- 
1.7.10.4

