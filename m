Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665AbaH2Uus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 16:50:48 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:43649 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaH2Uur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 16:50:47 -0400
From: Andrew Plummer <plummer574@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Andrew Plummer <plummer574@gmail.com>
Subject: [PATCH] Staging: bcm: LeakyBucket: format kernel-docs
Date: Fri, 29 Aug 2014 21:50:16 +0100
Message-Id: <1409345416-16408-1-git-send-email-plummer574@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove insignificant spaces before tabs in comments.

Signed-off-by: Andrew Plummer <plummer574@gmail.com>
---
 drivers/staging/bcm/LeakyBucket.c | 81 ++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/bcm/LeakyBucket.c b/drivers/staging/bcm/LeakyBucket.c
index 8c4030d..d6b55f9 100644
--- a/drivers/staging/bcm/LeakyBucket.c
+++ b/drivers/staging/bcm/LeakyBucket.c
@@ -1,20 +1,16 @@
 /**********************************************************************
-* 			LEAKYBUCKET.C
+*			LEAKYBUCKET.C
 *	This file contains the routines related to Leaky Bucket Algorithm.
 ***********************************************************************/
 #include "headers.h"
 
-/*********************************************************************
-* Function    - UpdateTokenCount()
-*
-* Description - This function calculates the token count for each
-*				channel and updates the same in Adapter strucuture.
-*
-* Parameters  - Adapter: Pointer to the Adapter structure.
-*
-* Returns     - None
-**********************************************************************/
-
+/**
+ * UpdateTokenCount() - Calculates the token count for each channel
+ * and updates the same in Adapter structure
+ * @Adapter:	Pointer to the Adapter structure.
+ *
+ * Return: None
+ */
 static VOID UpdateTokenCount(register struct bcm_mini_adapter *Adapter)
 {
 	ULONG liCurrentTime;
@@ -59,20 +55,16 @@ static VOID UpdateTokenCount(register struct bcm_mini_adapter *Adapter)
 }
 
 
-/*********************************************************************
-* Function    - IsPacketAllowedForFlow()
-*
-* Description - This function checks whether the given packet from the
-*				specified queue can be allowed for transmission by
-*				checking the token count.
-*
-* Parameters  - Adapter	      :	Pointer to the Adpater structure.
-* 			  - iQIndex	      :	The queue Identifier.
-* 			  - ulPacketLength:	Number of bytes to be transmitted.
-*
-* Returns     - The number of bytes allowed for transmission.
-*
-***********************************************************************/
+/**
+ * IsPacketAllowedForFlow() - This function checks whether the given
+ * packet from the specified queue can be allowed for transmission by
+ * checking the token count.
+ * @Adapter:		Pointer to the Adpater structure.
+ * @iQIndex:		The queue Identifier.
+ * @ulPacketLength:	Number of bytes to be transmitted.
+ *
+ * Returns: The number of bytes allowed for transmission.
+ */
 static ULONG GetSFTokenCount(struct bcm_mini_adapter *Adapter, struct bcm_packet_info *psSF)
 {
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TOKEN_COUNTS, DBG_LVL_ALL,
@@ -256,18 +248,14 @@ static void send_control_packet(struct bcm_mini_adapter *ad,
 	}
 }
 
-/************************************************************************
-* Function    - CheckAndSendPacketFromIndex()
-*
-* Description - This function dequeues the data/control packet from the
-*				specified queue for transmission.
-*
-* Parameters  - Adapter : Pointer to the driver control structure.
-* 			  - iQIndex : The queue Identifier.
-*
-* Returns     - None.
-*
-****************************************************************************/
+/**
+ * CheckAndSendPacketFromIndex() - This function dequeues the
+ * data/control packet from the specified queue for transmission.
+ * @Adapter:	Pointer to the driver control structure.
+ * @iQIndex:	The queue Identifier.
+ *
+ * Returns: None.
+ */
 static VOID CheckAndSendPacketFromIndex(struct bcm_mini_adapter *Adapter,
 					struct bcm_packet_info *psSF)
 {
@@ -284,16 +272,13 @@ static VOID CheckAndSendPacketFromIndex(struct bcm_mini_adapter *Adapter,
 }
 
 
-/*******************************************************************
-* Function    - transmit_packets()
-*
-* Description - This function transmits the packets from different
-*				queues, if free descriptors are available on target.
-*
-* Parameters  - Adapter:  Pointer to the Adapter structure.
-*
-* Returns     - None.
-********************************************************************/
+/**
+ * transmit_packets() - This function transmits the packets from
+ * different queues, if free descriptors are available on target.
+ * @Adapter:	Pointer to the Adapter structure.
+ *
+ * Returns: None.
+ */
 VOID transmit_packets(struct bcm_mini_adapter *Adapter)
 {
 	UINT uiPrevTotalCount = 0;
-- 
1.9.1

