Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbaGEEcO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 00:32:14 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:44318 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaGEEcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 00:32:13 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: cmetcalf@tilera.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tile: Add underscores to defintions
Date: Sat,  5 Jul 2014 00:32:08 -0400
Message-Id: <1404534728-7345-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In file drv_xgbe_impl.h I fixed the definitions for Size Small,
Size Large, Size Jumbo to have underscores before and after to
follow kernel coding style for internel defentions.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 arch/tile/include/hv/drv_xgbe_impl.h | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/arch/tile/include/hv/drv_xgbe_impl.h b/arch/tile/include/hv/drv_xgbe_impl.h
index 3a73b2b..51959da 100644
--- a/arch/tile/include/hv/drv_xgbe_impl.h
+++ b/arch/tile/include/hv/drv_xgbe_impl.h
@@ -40,18 +40,9 @@
 /** Total available words in the eDMA command FIFO. */
 #define EDMA_WDS_TOTAL      128
 
-
-/*
- * FIXME: These definitions are internal and should have underscores!
- * NOTE: The actual numeric values here are intentional and allow us to
- * optimize the concept "if small ... else if large ... else ...", by
- * checking for the low bit being set, and then for non-zero.
- * These are used as array indices, so they must have the values (0, 1, 2)
- * in some order.
- */
-#define SIZE_SMALL (1)       /**< Small packet queue. */
-#define SIZE_LARGE (2)       /**< Large packet queue. */
-#define SIZE_JUMBO (0)       /**< Jumbo packet queue. */
+#define __SIZE_SMALL__ (1)       /**< Small packet queue. */
+#define __SIZE_LARGE__ (2)       /**< Large packet queue. */
+#define __SIZE_JUMBO__ (0)       /**< Jumbo packet queue. */
 
 /** The number of "SIZE_xxx" values. */
 #define NETIO_NUM_SIZES 3
-- 
1.9.1

