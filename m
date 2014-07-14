Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012AbaGNTR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:17:29 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:34110 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbaGNTQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:16:03 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org, tvboxspy@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Cc: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH V4 2/6] staging: vt6556: Remove double parentheses
Date: Mon, 14 Jul 2014 21:15:29 +0200
Message-Id: <1405365333-17170-2-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405365333-17170-1-git-send-email-peter.senna@gmail.com>
References: <1405365333-17170-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleanup a checkpatch warning by removing double parentheses
from if condition. Additionally it fixes a line over 80 chars.

Tested by compilation only.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
Cahnges from V3:
 - Splitted the patches by change type

 drivers/staging/vt6656/baseband.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 8678b41..040b232 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -452,8 +452,9 @@ int BBbVT3184Init(struct vnt_private *priv)
 		priv->ldBmThreshold[2] = 0;
 		priv->ldBmThreshold[3] = 0;
 		/* Fix VT3226 DFC system timing issue */
-		vnt_mac_reg_bits_on(priv, MAC_REG_SOFTPWRCTL2, SOFTPWRCTL_RFLEOPT);
-	} else if ((priv->byRFType == RF_VT3342A0)) {
+		vnt_mac_reg_bits_on(priv, MAC_REG_SOFTPWRCTL2,
+				    SOFTPWRCTL_RFLEOPT);
+	} else if (priv->byRFType == RF_VT3342A0) {
 		priv->byBBRxConf = vnt_vt3184_vt3226d0[10];
 		length = sizeof(vnt_vt3184_vt3226d0);
 		addr = vnt_vt3184_vt3226d0;
-- 
1.9.3

