Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbaGIFws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 01:52:48 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:56025 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595AbaGIFwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 01:52:45 -0400
From: sanjeev sharma <sanjeevsharmaengg@gmail.com>
To: gregkh@linuxfoundation.org
Cc: rmfrfs@gmail.com, peter.senna@gmail.com, teobaluta@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        sanjeev sharma <sanjeev_sharma@mentor.com>,
        Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
Subject: [PATCH v2 3/4] staging: rtl8192u: Fixed switch and case indentation error in r819xU_phy.c
Date: Wed,  9 Jul 2014 11:34:19 +0530
Message-Id: <1404885860-19468-4-git-send-email-sanjeevsharmaengg@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1404885860-19468-1-git-send-email-sanjeevsharmaengg@gmail.com>
References: <20140708100142.GR25934@mwanda>
 <1404885860-19468-1-git-send-email-sanjeevsharmaengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: sanjeev sharma <sanjeev_sharma@mentor.com>

This is a patch to the r819xU_phy.c file that will fix switch and case indentation Error reported by checkpatch script.

Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
---
 drivers/staging/rtl8192u/r819xU_phy.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8192u/r819xU_phy.c b/drivers/staging/rtl8192u/r819xU_phy.c
index 0fcb673..3155616 100644
--- a/drivers/staging/rtl8192u/r819xU_phy.c
+++ b/drivers/staging/rtl8192u/r819xU_phy.c
@@ -946,12 +946,12 @@ void rtl8192_phy_RFConfig(struct net_device *dev)
 	struct r8192_priv *priv = ieee80211_priv(dev);
 
 	switch (priv->rf_chip) {
-		case RF_8256:
-			PHY_RF8256_Config(dev);
-			break;
-		default:
-			RT_TRACE(COMP_ERR, "error chip id\n");
-			break;
+	case RF_8256:
+		PHY_RF8256_Config(dev);
+		break;
+	default:
+		RT_TRACE(COMP_ERR, "error chip id\n");
+		break;
 	}
 }
 
-- 
1.7.11.7

