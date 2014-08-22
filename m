Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679AbaHVR6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 13:58:34 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:53663 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410AbaHVR6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 13:58:33 -0400
From: Greg Donald <gdonald@gmail.com>
To: Greg Kroah-Hartman <gregkh@linux.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Larry Finger <Larry.Finger@lwfinger.net>, linux-kernel@vger.kernel.org
Cc: Greg Donald <gdonald@gmail.com>
Subject: [PATCH] drivers: staging: rtl8723au: Fix space prohibited before that close parenthesis ')' errors
Date: Fri, 22 Aug 2014 12:58:13 -0500
Message-Id: <1408730293-22582-1-git-send-email-gdonald@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl space prohibited before that close parenthesis ')' errors

Signed-off-by: Greg Donald <gdonald@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_efuse.c        | 2 +-
 drivers/staging/rtl8723au/include/osdep_service.h | 2 +-
 drivers/staging/rtl8723au/include/rtl8723a_spec.h | 6 +++---
 drivers/staging/rtl8723au/include/rtw_efuse.h     | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_efuse.c b/drivers/staging/rtl8723au/core/rtw_efuse.c
index abc5d3c..9f6ce7d 100644
--- a/drivers/staging/rtl8723au/core/rtw_efuse.c
+++ b/drivers/staging/rtl8723au/core/rtw_efuse.c
@@ -731,7 +731,7 @@ EFUSE_ShadowRead23a(
 	struct rtw_adapter *	pAdapter,
 	u8		Type,
 	u16		Offset,
-	u32		*Value	)
+	u32		*Value)
 {
 	if (Type == 1)
 		efuse_ShadowRead1Byte(pAdapter, Offset, (u8 *)Value);
diff --git a/drivers/staging/rtl8723au/include/osdep_service.h b/drivers/staging/rtl8723au/include/osdep_service.h
index a5ebdb8..51a5d7b 100644
--- a/drivers/staging/rtl8723au/include/osdep_service.h
+++ b/drivers/staging/rtl8723au/include/osdep_service.h
@@ -62,7 +62,7 @@ static inline int rtw_netif_queue_stopped(struct net_device *pnetdev)
 	return (netif_tx_queue_stopped(netdev_get_tx_queue(pnetdev, 0)) &&
 		netif_tx_queue_stopped(netdev_get_tx_queue(pnetdev, 1)) &&
 		netif_tx_queue_stopped(netdev_get_tx_queue(pnetdev, 2)) &&
-		netif_tx_queue_stopped(netdev_get_tx_queue(pnetdev, 3)) );
+		netif_tx_queue_stopped(netdev_get_tx_queue(pnetdev, 3)));
 }
 
 static inline u32 CHKBIT(u32 x)
diff --git a/drivers/staging/rtl8723au/include/rtl8723a_spec.h b/drivers/staging/rtl8723au/include/rtl8723a_spec.h
index 59b545b..2f18689 100644
--- a/drivers/staging/rtl8723au/include/rtl8723a_spec.h
+++ b/drivers/staging/rtl8723au/include/rtl8723a_spec.h
@@ -1367,9 +1367,9 @@ Current IOREG MAP
 #define _TXDMA_HIQ_MAP(x)		(((x)&0x3) << 14)
 #define _TXDMA_MGQ_MAP(x)		(((x)&0x3) << 12)
 #define _TXDMA_BKQ_MAP(x)		(((x)&0x3) << 10)
-#define _TXDMA_BEQ_MAP(x)		(((x)&0x3) << 8 )
-#define _TXDMA_VIQ_MAP(x)		(((x)&0x3) << 6 )
-#define _TXDMA_VOQ_MAP(x)		(((x)&0x3) << 4 )
+#define _TXDMA_BEQ_MAP(x)		(((x)&0x3) << 8)
+#define _TXDMA_VIQ_MAP(x)		(((x)&0x3) << 6)
+#define _TXDMA_VOQ_MAP(x)		(((x)&0x3) << 4)
 
 #define QUEUE_LOW			1
 #define QUEUE_NORMAL			2
diff --git a/drivers/staging/rtl8723au/include/rtw_efuse.h b/drivers/staging/rtl8723au/include/rtw_efuse.h
index 07bdc34..3e9bad5 100644
--- a/drivers/staging/rtl8723au/include/rtw_efuse.h
+++ b/drivers/staging/rtl8723au/include/rtw_efuse.h
@@ -55,7 +55,7 @@ enum _EFUSE_DEF_TYPE {
 #define		EFUSE_MAX_HW_SIZE		512
 #define		EFUSE_MAX_SECTION_BASE	16
 
-#define EXT_HEADER(header) ((header & 0x1F ) == 0x0F)
+#define EXT_HEADER(header) ((header & 0x1F) == 0x0F)
 #define ALL_WORDS_DISABLED(wde)	((wde & 0x0F) == 0x0F)
 #define GET_HDR_OFFSET_2_0(header) ( (header & 0xE0) >> 5)
 
-- 
1.9.1

