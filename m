Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759377Ab3EWUvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 16:51:48 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:54988 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758330Ab3EWUvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 16:51:47 -0400
Date: Thu, 23 May 2013 13:51:43 -0700
From: Lisa Nguyen <lisa@xenapiadmin.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] staging/silicom/bypasslib: Reformat comments
Message-ID: <8f0a1b9dd2524047034345709cb11102ca44eded.1369342182.git.lisa@xenapiadmin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resolved the C99 comment style issue by reformatting existing comments 
to meet kernel coding standards in bp_ioctl.h

Signed-off-by: Lisa Nguyen <lisa@xenapiadmin.com>
---
 drivers/staging/silicom/bypasslib/bp_ioctl.h | 64 ++++++++++++++--------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/silicom/bypasslib/bp_ioctl.h b/drivers/staging/silicom/bypasslib/bp_ioctl.h
index 040c6fa..2d1ef53 100644
--- a/drivers/staging/silicom/bypasslib/bp_ioctl.h
+++ b/drivers/staging/silicom/bypasslib/bp_ioctl.h
@@ -14,41 +14,41 @@
 #ifndef BP_IOCTL_H
 #define BP_IOCTL_H
 
-#define BP_CAP                   0x01	//BIT_0
-#define BP_STATUS_CAP            0x02	//BIT_1
-#define BP_STATUS_CHANGE_CAP     0x04	//BIT_2
-#define SW_CTL_CAP               0x08	//BIT_3
-#define BP_DIS_CAP               0x10	//BIT_4
-#define BP_DIS_STATUS_CAP        0x20	//BIT_5
-#define STD_NIC_CAP              0x40	//BIT_6
-#define BP_PWOFF_ON_CAP          0x80	//BIT_7
-#define BP_PWOFF_OFF_CAP         0x0100	//BIT_8
-#define BP_PWOFF_CTL_CAP         0x0200	//BIT_9
-#define BP_PWUP_ON_CAP           0x0400	//BIT_10
-#define BP_PWUP_OFF_CAP          0x0800	//BIT_11
-#define BP_PWUP_CTL_CAP          0x1000	//BIT_12
-#define WD_CTL_CAP               0x2000	//BIT_13
-#define WD_STATUS_CAP            0x4000	//BIT_14
-#define WD_TIMEOUT_CAP           0x8000	//BIT_15
-#define TX_CTL_CAP               0x10000	//BIT_16
-#define TX_STATUS_CAP            0x20000	//BIT_17
-#define TAP_CAP                  0x40000	//BIT_18
-#define TAP_STATUS_CAP           0x80000	//BIT_19
-#define TAP_STATUS_CHANGE_CAP    0x100000	//BIT_20
-#define TAP_DIS_CAP              0x200000	//BIT_21
-#define TAP_DIS_STATUS_CAP       0x400000	//BIT_22
-#define TAP_PWUP_ON_CAP          0x800000	//BIT_23
-#define TAP_PWUP_OFF_CAP         0x1000000	//BIT 24
-#define TAP_PWUP_CTL_CAP         0x2000000	//BIT 25
-#define NIC_CAP_NEG              0x4000000	//BIT 26
-#define TPL_CAP                  0x8000000	//BIT 27
-#define DISC_CAP                 0x10000000	//BIT 28
-#define DISC_DIS_CAP             0x20000000	//BIT 29
-#define DISC_PWUP_CTL_CAP        0x40000000	//BIT 30
+#define BP_CAP                   0x01	/* BIT_0 */
+#define BP_STATUS_CAP            0x02	/* BIT_1 */
+#define BP_STATUS_CHANGE_CAP     0x04	/* BIT_2 */
+#define SW_CTL_CAP               0x08	/* BIT_3 */
+#define BP_DIS_CAP               0x10	/* BIT_4 */
+#define BP_DIS_STATUS_CAP        0x20	/* BIT_5 */
+#define STD_NIC_CAP              0x40	/* BIT_6 */
+#define BP_PWOFF_ON_CAP          0x80	/* BIT_7 */
+#define BP_PWOFF_OFF_CAP         0x0100	/* BIT_8 */
+#define BP_PWOFF_CTL_CAP         0x0200	/* BIT_9 */
+#define BP_PWUP_ON_CAP           0x0400	/* BIT_10 */
+#define BP_PWUP_OFF_CAP          0x0800	/* BIT_11 */
+#define BP_PWUP_CTL_CAP          0x1000	/* BIT_12 */
+#define WD_CTL_CAP               0x2000	/* BIT_13 */
+#define WD_STATUS_CAP            0x4000	/* BIT_14 */
+#define WD_TIMEOUT_CAP           0x8000	/* BIT_15 */
+#define TX_CTL_CAP               0x10000	/* BIT_16 */
+#define TX_STATUS_CAP            0x20000	/* BIT_17 */
+#define TAP_CAP                  0x40000	/* BIT_18 */
+#define TAP_STATUS_CAP           0x80000	/* BIT_19 */
+#define TAP_STATUS_CHANGE_CAP    0x100000	/* BIT_20 */
+#define TAP_DIS_CAP              0x200000	/* BIT_21 */
+#define TAP_DIS_STATUS_CAP       0x400000	/* BIT_22 */
+#define TAP_PWUP_ON_CAP          0x800000	/* BIT_23 */
+#define TAP_PWUP_OFF_CAP         0x1000000	/* BIT 24 */
+#define TAP_PWUP_CTL_CAP         0x2000000	/* BIT 25 */
+#define NIC_CAP_NEG              0x4000000	/* BIT 26 */
+#define TPL_CAP                  0x8000000	/* BIT 27 */
+#define DISC_CAP                 0x10000000	/* BIT 28 */
+#define DISC_DIS_CAP             0x20000000	/* BIT 29 */
+#define DISC_PWUP_CTL_CAP        0x40000000	/* BIT 30 */
 
 #define WD_MIN_TIME_MASK(val)      (val & 0xf)
 #define WD_STEP_COUNT_MASK(val)    ((val & 0xf) << 5)
-#define WDT_STEP_TIME              0x10	//BIT_4
+#define WDT_STEP_TIME              0x10	/* BIT_4 */
 
 #define WD_MIN_TIME_GET(desc)   (desc & 0xf)
 #define WD_STEP_COUNT_GET(desc) (desc>>5) & 0xf
-- 
1.8.1.2

