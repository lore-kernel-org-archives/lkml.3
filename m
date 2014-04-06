Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbaDFNEY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 09:04:24 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:59339 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaDFNEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 09:04:22 -0400
Message-ID: <1396789419.3240.9.camel@localhost>
Subject: [PATCH] staging: rtl8192u: Fix indentation problems
From: =?ISO-8859-1?Q?Lo=EFc?= Pellegrino <oort10@gmail.com>
To: gregkh@linuxfoundation.org
Cc: burzalodowa@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Sun, 06 Apr 2014 14:03:39 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style problems (incorrect indentation).

Signed-off-by: Loïc Pellegrino <oort10@gmail.com>
---
 drivers/staging/rtl8192u/r8190_rtl8256.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8190_rtl8256.c b/drivers/staging/rtl8192u/r8190_rtl8256.c
index 40b14a2..08e1bc9 100644
--- a/drivers/staging/rtl8192u/r8190_rtl8256.c
+++ b/drivers/staging/rtl8192u/r8190_rtl8256.c
@@ -32,7 +32,7 @@ void PHY_SetRF8256Bandwidth(struct net_device *dev , HT_CHANNEL_WIDTH Bandwidth)
 	for(eRFPath = 0; eRFPath <RF90_PATH_MAX; eRFPath++)
 	{
 		if (!rtl8192_phy_CheckIsLegalRFPath(dev, eRFPath))
-				continue;
+			continue;
 
 		switch (Bandwidth)
 		{
@@ -125,7 +125,7 @@ void phy_RF8256_Config_ParaFile(struct net_device *dev)
 	for(eRFPath = (RF90_RADIO_PATH_E)RF90_PATH_A; eRFPath <priv->NumTotalRFPath; eRFPath++)
 	{
 		if (!rtl8192_phy_CheckIsLegalRFPath(dev, eRFPath))
-				continue;
+			continue;
 
 		pPhyReg = &priv->PHYRegDef[eRFPath];
 
@@ -249,7 +249,7 @@ void PHY_SetRF8256CCKTxPower(struct net_device *dev, u8 powerlevel)
 		if(priv->CustomerID == RT_CID_819x_Netcore)
 			TxAGC = 0x22;
 		else
-		TxAGC += priv->CckPwEnl;
+			TxAGC += priv->CckPwEnl;
 	}
 
 	if(TxAGC > 0x24)
-- 
1.9.0



