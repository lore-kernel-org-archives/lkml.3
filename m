Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbaGIMIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:08:19 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:33791 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276AbaGIMIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:08:15 -0400
From: sanjeev sharma <sanjeevsharmaengg@gmail.com>
To: gregkh@linuxfoundation.org
Cc: rmfrfs@gmail.com, peter.senna@gmail.com, teobaluta@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        sanjeev sharma <sanjeev_sharma@mentor.com>,
        Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
Subject: [PATCH v3 4/4] staging: rtl8192u: Fixed too long lines
Date: Wed,  9 Jul 2014 17:49:42 +0530
Message-Id: <1404908382-7043-5-git-send-email-sanjeevsharmaengg@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1404908382-7043-1-git-send-email-sanjeevsharmaengg@gmail.com>
References: <20140708100142.GR25934@mwanda>
 <1404908382-7043-1-git-send-email-sanjeevsharmaengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: sanjeev sharma <sanjeev_sharma@mentor.com>

This patch will fix too long lines warning
reported by checkpatch.pl.

Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
---
 drivers/staging/rtl8192u/r819xU_phy.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8192u/r819xU_phy.c b/drivers/staging/rtl8192u/r819xU_phy.c
index 3155616..1ea3a4e 100644
--- a/drivers/staging/rtl8192u/r819xU_phy.c
+++ b/drivers/staging/rtl8192u/r819xU_phy.c
@@ -1236,7 +1236,8 @@ static u8 rtl8192_phy_SetSwChnlCmdArray(SwChnlCmd *CmdTable, u32 CmdTableIdx,
 		return false;
 	}
 	if (CmdTableIdx >= CmdTableSz) {
-		RT_TRACE(COMP_ERR, "%s(): Access invalid index, please check size of the table, CmdTableIdx:%d, CmdTableSz:%d\n",
+		RT_TRACE(COMP_ERR,
+			 "%s():invalid index,CmdTableIdx:%d, CmdTableSz:%d\n",
 			 __func__, CmdTableIdx, CmdTableSz);
 		return false;
 	}
@@ -1697,7 +1698,8 @@ void InitialGain819xUsb(struct net_device *dev,	u8 Operation)
 	priv->InitialGainOperateType = Operation;
 
 	if (priv->up)
-		queue_delayed_work(priv->priv_wq, &priv->initialgain_operate_wq, 0);
+		queue_delayed_work(priv->priv_wq,
+				   &priv->initialgain_operate_wq, 0);
 }
 
 void InitialGainOperateWorkItemCallBack(struct work_struct *work)
@@ -1786,7 +1788,9 @@ void InitialGainOperateWorkItemCallBack(struct work_struct *work)
 		RT_TRACE(COMP_SCAN, "Scan BBInitialGainRestore 0xa0a is %x\n",
 			 priv->initgain_backup.cca);
 
-		rtl8192_phy_setTxPower(dev, priv->ieee80211->current_network.channel);
+		rtl8192_phy_setTxPower(dev,
+					priv->ieee80211->current_network.channel
+				       );
 
 		if (dm_digtable.dig_algorithm == DIG_ALGO_BY_FALSE_ALARM)
 			/* FW DIG ON */
-- 
1.7.11.7

