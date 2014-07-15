Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbaGOVYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:24:43 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34125 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671AbaGOVXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:23:50 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org, tvboxspy@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Cc: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH V5 2/4] staging: vt6556: Cleanup coding style: comments
Date: Tue, 15 Jul 2014 23:23:25 +0200
Message-Id: <1405459407-9311-2-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405459407-9311-1-git-send-email-peter.senna@gmail.com>
References: <1405459407-9311-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleanup coding style issues on comments.

Tested by compilation only.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
Changes from V4:
 - Splitted [PATCH V4 1/6] in 4 smaller patches

 drivers/staging/vt6656/baseband.c | 15 ++++++++-------
 drivers/staging/vt6656/card.c     |  4 ++--
 drivers/staging/vt6656/channel.c  |  5 +++--
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index c1675d5..7adc8db 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -26,9 +26,10 @@
  * Date: Jun. 5, 2002
  *
  * Functions:
- *      vnt_get_frame_time        - Calculate data frame transmitting time
- *      vnt_get_phy_field   - Calculate PhyLength, PhyService and Phy Signal parameter for baseband Tx
- *      BBbVT3184Init          - VIA VT3184 baseband chip init code
+ *	vnt_get_frame_time	- Calculate data frame transmitting time
+ *	vnt_get_phy_field	- Calculate PhyLength, PhyService and Phy
+ *				  Signal parameter for baseband Tx
+ *	BBbVT3184Init		- VIA VT3184 baseband chip init code
  *
  * Revision History:
  *
@@ -86,7 +87,7 @@ static u8 vnt_vt3184_al2230[] = {
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  /* 0xff */
 };
 
-//{{RobertYu:20060515, new BB setting for VT3226D0
+/* {{RobertYu:20060515, new BB setting for VT3226D0 */
 static u8 vnt_vt3184_vt3226d0[] = {
 	0x31, 0x00, 0x00, 0x00, 0x00, 0x80, 0x00, 0x00,
 	0x70, 0x45, 0x2a, 0x76, 0x00, 0x00, 0x80, 0x00, /* 0x0f */
@@ -191,9 +192,9 @@ unsigned int vnt_get_frame_time(u8 preamble_type, u8 pkt_type,
  *      tx_rate           - Tx Rate
  *  Out:
  *	struct vnt_phy_field *phy
- * 			- pointer to Phy Length field
- *			- pointer to Phy Service field
- * 			- pointer to Phy Signal field
+ *		- pointer to Phy Length field
+ *		- pointer to Phy Service field
+ *		- pointer to Phy Signal field
  *
  * Return Value: none
  *
diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index ea06b63..6a6e614 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -55,8 +55,8 @@
 #include "key.h"
 #include "usbpipe.h"
 
-//const u16 cwRXBCNTSFOff[MAX_RATE] =
-//{17, 34, 96, 192, 34, 23, 17, 11, 8, 5, 4, 3};
+/* const u16 cwRXBCNTSFOff[MAX_RATE] =
+   {17, 34, 96, 192, 34, 23, 17, 11, 8, 5, 4, 3}; */
 
 static const u16 cwRXBCNTSFOff[MAX_RATE] =
 {192, 96, 34, 17, 34, 23, 17, 11, 8, 5, 4, 3};
diff --git a/drivers/staging/vt6656/channel.c b/drivers/staging/vt6656/channel.c
index fb1838e..4a53f1a 100644
--- a/drivers/staging/vt6656/channel.c
+++ b/drivers/staging/vt6656/channel.c
@@ -28,8 +28,9 @@
  *
  *
  * Revision History:
- *      01-18-2005      RobertYu:  remove the for loop searching in ChannelValid,
- *                                 change ChannelRuleTab to lookup-type, reorder table items.
+ *	01-18-2005	RobertYu:	remove the for loop searching in
+ *					ChannelValid, change ChannelRuleTab
+ *					to lookup-type, reorder table items.
  *
  *
  */
-- 
1.9.3

