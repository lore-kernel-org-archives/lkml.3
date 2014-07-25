Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760870AbaGYQFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:05:50 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:51964 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbaGYQFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:05:48 -0400
From: Igor Bezukh <igbzkh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, forest@alittletooquiet.net,
        linux-kernel@vger.kernel.org, igbzkh@gmail.com
Subject: [PATCH] Staging: vt6655: removed redundant comments from desc.h
Date: Fri, 25 Jul 2014 19:05:31 +0300
Message-Id: <1406304331-31463-1-git-send-email-igbzkh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed redundant comments from desc.h header file.

Signed-off-by: Igor Bezukh <igbzkh@gmail.com>
C99 style comments will be fixed in further patches.
---
 drivers/staging/vt6655/desc.h |  185 +++++++++++++++++++----------------------
 1 file changed, 87 insertions(+), 98 deletions(-)

diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index c620cbfb..05efa4e 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -36,79 +36,77 @@
 #include "ttype.h"
 #include "tether.h"
 
-/*---------------------  Export Definitions -------------------------*/
-
-#define B_OWNED_BY_CHIP     1           //
-#define B_OWNED_BY_HOST     0           //
+#define B_OWNED_BY_CHIP     1
+#define B_OWNED_BY_HOST     0
 
 //
 // Bits in the RSR register
 //
-#define RSR_ADDRBROAD       0x80        // 1000 0000
-#define RSR_ADDRMULTI       0x40        // 0100 0000
-#define RSR_ADDRUNI         0x00        // 0000 0000
-#define RSR_IVLDTYP         0x20        // 0010 0000 , invalid packet type
-#define RSR_IVLDLEN         0x10        // 0001 0000 , invalid len (> 2312 byte)
-#define RSR_BSSIDOK         0x08        // 0000 1000
-#define RSR_CRCOK           0x04        // 0000 0100
-#define RSR_BCNSSIDOK       0x02        // 0000 0010
-#define RSR_ADDROK          0x01        // 0000 0001
+#define RSR_ADDRBROAD       0x80
+#define RSR_ADDRMULTI       0x40
+#define RSR_ADDRUNI         0x00
+#define RSR_IVLDTYP         0x20
+#define RSR_IVLDLEN         0x10        // invalid len (> 2312 byte)
+#define RSR_BSSIDOK         0x08
+#define RSR_CRCOK           0x04
+#define RSR_BCNSSIDOK       0x02
+#define RSR_ADDROK          0x01
 
 //
 // Bits in the new RSR register
 //
-#define NEWRSR_DECRYPTOK    0x10        // 0001 0000
-#define NEWRSR_CFPIND       0x08        // 0000 1000
-#define NEWRSR_HWUTSF       0x04        // 0000 0100
-#define NEWRSR_BCNHITAID    0x02        // 0000 0010
-#define NEWRSR_BCNHITAID0   0x01        // 0000 0001
+#define NEWRSR_DECRYPTOK    0x10
+#define NEWRSR_CFPIND       0x08
+#define NEWRSR_HWUTSF       0x04
+#define NEWRSR_BCNHITAID    0x02
+#define NEWRSR_BCNHITAID0   0x01
 
 //
 // Bits in the TSR0 register
 //
-#define TSR0_PWRSTS1_2      0xC0        // 1100 0000
-#define TSR0_PWRSTS7        0x20        // 0010 0000
-#define TSR0_NCR            0x1F        // 0001 1111
+#define TSR0_PWRSTS1_2      0xC0
+#define TSR0_PWRSTS7        0x20
+#define TSR0_NCR            0x1F
 
 //
 // Bits in the TSR1 register
 //
-#define TSR1_TERR           0x80        // 1000 0000
-#define TSR1_PWRSTS4_6      0x70        // 0111 0000
-#define TSR1_RETRYTMO       0x08        // 0000 1000
-#define TSR1_TMO            0x04        // 0000 0100
-#define TSR1_PWRSTS3        0x02        // 0000 0010
-#define ACK_DATA            0x01        // 0000 0000
+#define TSR1_TERR           0x80
+#define TSR1_PWRSTS4_6      0x70
+#define TSR1_RETRYTMO       0x08
+#define TSR1_TMO            0x04
+#define TSR1_PWRSTS3        0x02
+#define ACK_DATA            0x01
 
 //
 // Bits in the TCR register
 //
-#define EDMSDU              0x04        // 0000 0100 end of sdu
-#define TCR_EDP             0x02        // 0000 0010 end of packet
-#define TCR_STP             0x01        // 0000 0001 start of packet
+#define EDMSDU              0x04        // end of sdu
+#define TCR_EDP             0x02        // end of packet
+#define TCR_STP             0x01        // start of packet
 
 // max transmit or receive buffer size
-#define CB_MAX_BUF_SIZE     2900U       // max buffer size
+#define CB_MAX_BUF_SIZE     2900U
 					// NOTE: must be multiple of 4
-#define CB_MAX_TX_BUF_SIZE          CB_MAX_BUF_SIZE // max Tx buffer size
-#define CB_MAX_RX_BUF_SIZE_NORMAL   CB_MAX_BUF_SIZE // max Rx buffer size when not use Multi-RD
+#define CB_MAX_TX_BUF_SIZE          CB_MAX_BUF_SIZE
+#define CB_MAX_RX_BUF_SIZE_NORMAL   CB_MAX_BUF_SIZE
 
-#define CB_BEACON_BUF_SIZE  512U        // default beacon buffer size
+#define CB_BEACON_BUF_SIZE  512U
 
-#define CB_MAX_RX_DESC      128         // max # of descriptor
-#define CB_MIN_RX_DESC      16          // min # of rx descriptor
-#define CB_MAX_TX_DESC      64          // max # of descriptor
-#define CB_MIN_TX_DESC      16          // min # of tx descriptor
+#define CB_MAX_RX_DESC      128
+#define CB_MIN_RX_DESC      16
+#define CB_MAX_TX_DESC      64
+#define CB_MIN_TX_DESC      16
 
-#define CB_MAX_RECEIVED_PACKETS     16  // max # of received packets at one time
+#define CB_MAX_RECEIVED_PACKETS     16
 					// limit our receive routine to indicating
 					// this many at a time for 2 reasons:
 					// 1. driver flow control to protocol layer
 					// 2. limit the time used in ISR routine
 
-#define CB_EXTRA_RD_NUM     32          // default # of Extra RD
-#define CB_RD_NUM           32          // default # of RD
-#define CB_TD_NUM           32          // default # of TD
+#define CB_EXTRA_RD_NUM     32
+#define CB_RD_NUM           32
+#define CB_TD_NUM           32
 
 // max number of physical segments
 // in a single NDIS packet. Above this threshold, the packet
@@ -128,61 +126,61 @@
 #ifdef __BIG_ENDIAN
 
 // WMAC definition FIFO Control
-#define FIFOCTL_AUTO_FB_1   0x0010 // 0001 0000 0000 0000
-#define FIFOCTL_AUTO_FB_0   0x0008 // 0000 1000 0000 0000
-#define FIFOCTL_GRPACK      0x0004 // 0000 0100 0000 0000
-#define FIFOCTL_11GA        0x0003 // 0000 0011 0000 0000
-#define FIFOCTL_11GB        0x0002 // 0000 0010 0000 0000
-#define FIFOCTL_11B         0x0001 // 0000 0001 0000 0000
-#define FIFOCTL_11A         0x0000 // 0000 0000 0000 0000
-#define FIFOCTL_RTS         0x8000 // 0000 0000 1000 0000
-#define FIFOCTL_ISDMA0      0x4000 // 0000 0000 0100 0000
-#define FIFOCTL_GENINT      0x2000 // 0000 0000 0010 0000
-#define FIFOCTL_TMOEN       0x1000 // 0000 0000 0001 0000
-#define FIFOCTL_LRETRY      0x0800 // 0000 0000 0000 1000
-#define FIFOCTL_CRCDIS      0x0400 // 0000 0000 0000 0100
-#define FIFOCTL_NEEDACK     0x0200 // 0000 0000 0000 0010
-#define FIFOCTL_LHEAD       0x0100 // 0000 0000 0000 0001
+#define FIFOCTL_AUTO_FB_1   0x0010
+#define FIFOCTL_AUTO_FB_0   0x0008
+#define FIFOCTL_GRPACK      0x0004
+#define FIFOCTL_11GA        0x0003
+#define FIFOCTL_11GB        0x0002
+#define FIFOCTL_11B         0x0001
+#define FIFOCTL_11A         0x0000
+#define FIFOCTL_RTS         0x8000
+#define FIFOCTL_ISDMA0      0x4000
+#define FIFOCTL_GENINT      0x2000
+#define FIFOCTL_TMOEN       0x1000
+#define FIFOCTL_LRETRY      0x0800
+#define FIFOCTL_CRCDIS      0x0400
+#define FIFOCTL_NEEDACK     0x0200
+#define FIFOCTL_LHEAD       0x0100
 
 //WMAC definition Frag Control
-#define FRAGCTL_AES         0x0003 // 0000 0011 0000 0000
-#define FRAGCTL_TKIP        0x0002 // 0000 0010 0000 0000
-#define FRAGCTL_LEGACY      0x0001 // 0000 0001 0000 0000
-#define FRAGCTL_NONENCRYPT  0x0000 // 0000 0000 0000 0000
-#define FRAGCTL_ENDFRAG     0x0300 // 0000 0000 0000 0011
-#define FRAGCTL_MIDFRAG     0x0200 // 0000 0000 0000 0010
-#define FRAGCTL_STAFRAG     0x0100 // 0000 0000 0000 0001
-#define FRAGCTL_NONFRAG     0x0000 // 0000 0000 0000 0000
+#define FRAGCTL_AES         0x0003
+#define FRAGCTL_TKIP        0x0002
+#define FRAGCTL_LEGACY      0x0001
+#define FRAGCTL_NONENCRYPT  0x0000
+#define FRAGCTL_ENDFRAG     0x0300
+#define FRAGCTL_MIDFRAG     0x0200
+#define FRAGCTL_STAFRAG     0x0100
+#define FRAGCTL_NONFRAG     0x0000
 
 #else
 
-#define FIFOCTL_AUTO_FB_1   0x1000 // 0001 0000 0000 0000
-#define FIFOCTL_AUTO_FB_0   0x0800 // 0000 1000 0000 0000
-#define FIFOCTL_GRPACK      0x0400 // 0000 0100 0000 0000
-#define FIFOCTL_11GA        0x0300 // 0000 0011 0000 0000
-#define FIFOCTL_11GB        0x0200 // 0000 0010 0000 0000
-#define FIFOCTL_11B         0x0100 // 0000 0001 0000 0000
-#define FIFOCTL_11A         0x0000 // 0000 0000 0000 0000
-#define FIFOCTL_RTS         0x0080 // 0000 0000 1000 0000
-#define FIFOCTL_ISDMA0      0x0040 // 0000 0000 0100 0000
-#define FIFOCTL_GENINT      0x0020 // 0000 0000 0010 0000
-#define FIFOCTL_TMOEN       0x0010 // 0000 0000 0001 0000
-#define FIFOCTL_LRETRY      0x0008 // 0000 0000 0000 1000
-#define FIFOCTL_CRCDIS      0x0004 // 0000 0000 0000 0100
-#define FIFOCTL_NEEDACK     0x0002 // 0000 0000 0000 0010
-#define FIFOCTL_LHEAD       0x0001 // 0000 0000 0000 0001
+#define FIFOCTL_AUTO_FB_1   0x1000
+#define FIFOCTL_AUTO_FB_0   0x0800
+#define FIFOCTL_GRPACK      0x0400
+#define FIFOCTL_11GA        0x0300
+#define FIFOCTL_11GB        0x0200
+#define FIFOCTL_11B         0x0100
+#define FIFOCTL_11A         0x0000
+#define FIFOCTL_RTS         0x0080
+#define FIFOCTL_ISDMA0      0x0040
+#define FIFOCTL_GENINT      0x0020
+#define FIFOCTL_TMOEN       0x0010
+#define FIFOCTL_LRETRY      0x0008
+#define FIFOCTL_CRCDIS      0x0004
+#define FIFOCTL_NEEDACK     0x0002
+#define FIFOCTL_LHEAD       0x0001
 
 //WMAC definition Frag Control
-#define FRAGCTL_AES         0x0300 // 0000 0011 0000 0000
-#define FRAGCTL_TKIP        0x0200 // 0000 0010 0000 0000
-#define FRAGCTL_LEGACY      0x0100 // 0000 0001 0000 0000
-#define FRAGCTL_NONENCRYPT  0x0000 // 0000 0000 0000 0000
-#define FRAGCTL_ENDFRAG     0x0003 // 0000 0000 0000 0011
-#define FRAGCTL_MIDFRAG     0x0002 // 0000 0000 0000 0010
-#define FRAGCTL_STAFRAG     0x0001 // 0000 0000 0000 0001
-#define FRAGCTL_NONFRAG     0x0000 // 0000 0000 0000 0000
+#define FRAGCTL_AES         0x0300
+#define FRAGCTL_TKIP        0x0200
+#define FRAGCTL_LEGACY      0x0100
+#define FRAGCTL_NONENCRYPT  0x0000
+#define FRAGCTL_ENDFRAG     0x0003
+#define FRAGCTL_MIDFRAG     0x0002
+#define FRAGCTL_STAFRAG     0x0001
+#define FRAGCTL_NONFRAG     0x0000
 
-#endif // #ifdef __BIG_ENDIAN
+#endif
 
 #define TYPE_TXDMA0     0
 #define TYPE_AC0DMA     1
@@ -201,8 +199,6 @@
 #define TD_FLAGS_PRIV_SKB                0x02       // check if called from private skb(hostap)
 #define TD_FLAGS_PS_RETRY                0x04       // check if PS STA frame re-transmit
 
-/*---------------------  Export Types  ------------------------------*/
-
 // ref_sk_buff is used for mapping the skb structure between pre-built driver-obj & running kernel.
 // Since different kernel version (2.4x) may change skb structure, i.e. pre-built driver-obj
 // may link to older skb that leads error.
@@ -590,12 +586,5 @@ typedef struct tagSKeyEntry {
 	u32 dwKey4[4];
 } __attribute__ ((__packed__))
 SKeyEntry;
-/*---------------------  Export Macros ------------------------------*/
-
-/*---------------------  Export Classes  ----------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
 
 #endif // __DESC_H__
-- 
1.7.9.5

