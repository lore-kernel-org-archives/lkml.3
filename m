Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbbAOQcK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 11:32:10 -0500
Received: from mail14.tpgi.com.au ([203.12.160.182]:35170 "EHLO
	mail14.tpgi.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350AbbAOQcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 11:32:07 -0500
X-TPG-Antivirus: Passed
X-TPG-Abuse: host=14-201-201-57.static.tpgi.com.au; ip=14.201.201.57; date=Fri, 16 Jan 2015 03:31:33 +1100; auth=qn3nQWOo9XiOgLX3+3LzYIb4Pj8GBfUecjOflfKdwAc=
From: Emrys Bayliss <emrys@paradise.net.nz>
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org,
        emrys@paradise.net.nz, tvboxspy@gmail.com, gclement@baobob.org,
        guido@vanguardiasur.com.ar
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] Staging: vt6655: comment after statement formatting
Date: Fri, 16 Jan 2015 03:29:23 +1100
Message-Id: <1421339367-23521-4-git-send-email-emrys@paradise.net.nz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421339367-23521-1-git-send-email-emrys@paradise.net.nz>
References: <1421339367-23521-1-git-send-email-emrys@paradise.net.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the formatting of the comments in mac.h more
consistent.

* Where a comment follows a statement, it is separated by a single
  space.

Signed-off-by: Emrys Bayliss <emrys@paradise.net.nz>
---
 drivers/staging/vt6655/mac.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/vt6655/mac.h b/drivers/staging/vt6655/mac.h
index 359e3f2..f29fe30 100644
--- a/drivers/staging/vt6655/mac.h
+++ b/drivers/staging/vt6655/mac.h
@@ -336,12 +336,12 @@
 //
 #define HOSTCR_TXONST       0x80
 #define HOSTCR_RXONST       0x40
-#define HOSTCR_ADHOC        0x20        // Network Type 1 = Ad-hoc
-#define HOSTCR_AP           0x10        // Port Type 1 = AP
-#define HOSTCR_TXON         0x08        //0000 1000
-#define HOSTCR_RXON         0x04        //0000 0100
-#define HOSTCR_MACEN        0x02        //0000 0010
-#define HOSTCR_SOFTRST      0x01        //0000 0001
+#define HOSTCR_ADHOC        0x20 // Network Type 1 = Ad-hoc
+#define HOSTCR_AP           0x10 // Port Type 1 = AP
+#define HOSTCR_TXON         0x08 //0000 1000
+#define HOSTCR_RXON         0x04 //0000 0100
+#define HOSTCR_MACEN        0x02 //0000 0010
+#define HOSTCR_SOFTRST      0x01 //0000 0001
 
 //
 // Bits in the MACCR register
@@ -371,7 +371,7 @@
 // Bits in the TCR register
 //
 #define TCR_SYNCDCFOPT      0x02
-#define TCR_AUTOBCNTX       0x01        // Beacon automatically transmit enable
+#define TCR_AUTOBCNTX       0x01 // Beacon automatically transmit enable
 
 //
 // Bits in the IMR register
@@ -381,7 +381,7 @@
 #define IMR_RADARDETECT     0x10000000
 #define IMR_MEASUREEND      0x08000000
 #define IMR_SOFTTIMER1      0x00200000
-#define IMR_RXDMA1          0x00001000      //0000 0000 0001 0000 0000 0000
+#define IMR_RXDMA1          0x00001000 //0000 0000 0001 0000 0000 0000
 #define IMR_RXNOBUF         0x00000800
 #define IMR_MIBNEARFULL     0x00000400
 #define IMR_SOFTINT         0x00000200
@@ -404,9 +404,9 @@
 #define ISR_RADARDETECT     0x10000000
 #define ISR_MEASUREEND      0x08000000
 #define ISR_SOFTTIMER1      0x00200000
-#define ISR_RXDMA1          0x00001000      //0000 0000 0001 0000 0000 0000
-#define ISR_RXNOBUF         0x00000800      //0000 0000 0000 1000 0000 0000
-#define ISR_MIBNEARFULL     0x00000400      //0000 0000 0000 0100 0000 0000
+#define ISR_RXDMA1          0x00001000 //0000 0000 0001 0000 0000 0000
+#define ISR_RXNOBUF         0x00000800 //0000 0000 0000 1000 0000 0000
+#define ISR_MIBNEARFULL     0x00000400 //0000 0000 0000 0100 0000 0000
 #define ISR_SOFTINT         0x00000200
 #define ISR_FETALERR        0x00000100
 #define ISR_WATCHDOG        0x00000080
@@ -603,7 +603,7 @@
 #define W_MAX_TIMEOUT       0xFFF0U
 
 // wait time within loop
-#define CB_DELAY_LOOP_WAIT  10          // 10ms
+#define CB_DELAY_LOOP_WAIT  10 // 10ms
 
 //
 // revision id
-- 
2.2.1

