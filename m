Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbaGIFwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 01:52:45 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:44803 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaGIFwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 01:52:42 -0400
From: sanjeev sharma <sanjeevsharmaengg@gmail.com>
To: gregkh@linuxfoundation.org
Cc: rmfrfs@gmail.com, peter.senna@gmail.com, teobaluta@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        sanjeev sharma <sanjeev_sharma@mentor.com>,
        Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
Subject: [PATCH v2 2/4] staging: rtl8192u: Removed unnecessary whitespace & tab warning  in r819xU_phy.c
Date: Wed,  9 Jul 2014 11:34:18 +0530
Message-Id: <1404885860-19468-3-git-send-email-sanjeevsharmaengg@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1404885860-19468-1-git-send-email-sanjeevsharmaengg@gmail.com>
References: <20140708100142.GR25934@mwanda>
 <1404885860-19468-1-git-send-email-sanjeevsharmaengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: sanjeev sharma <sanjeev_sharma@mentor.com>

This is a patch to the r819xU_phy.c file that remove unnecessary  whitespace and tabs reported by checkpatch.pl script.

Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
---
 drivers/staging/rtl8192u/r819xU_phy.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/rtl8192u/r819xU_phy.c b/drivers/staging/rtl8192u/r819xU_phy.c
index 0bcdd4e..0fcb673 100644
--- a/drivers/staging/rtl8192u/r819xU_phy.c
+++ b/drivers/staging/rtl8192u/r819xU_phy.c
@@ -106,10 +106,10 @@ void rtl8192_setBBreg(struct net_device *dev, u32 reg_addr, u32 bitmask,
 /******************************************************************************
  * function:  This function reads specific bits from BB register
  * input:     net_device	*dev
- *            u32	 	reg_addr   //target addr to be readback
- *            u32	 	bitmask    //taget bit pos to be readback
- * output:    none
- * return:    u32	 	data       //the readback register value
+ * u32		reg_addr   //target addr to be readback
+ * u32		bitmask    //taget bit pos to be readback
+ * output:	none
+ * return:	u32		data       //the readback register value
  * notice:
  ******************************************************************************/
 u32 rtl8192_QueryBBReg(struct net_device *dev, u32 reg_addr, u32 bitmask)
@@ -478,9 +478,9 @@ static void phy_FwRFSerialWrite(struct net_device *dev,
 /******************************************************************************
  * function:  This function reads BB parameters from header file we generate,
  *            and do register read/write
- * input:     net_device 	*dev
- * output:    none
- * return:    none
+ * input:	net_device	*dev
+ * output:	none
+ * return:	none
  * notice:    BB parameters may change all the time, so please make
  *            sure it has been synced with the newest.
  *****************************************************************************/
@@ -900,7 +900,7 @@ void rtl8192_phy_getTxPower(struct net_device *dev)
 	read_nic_byte(dev, rOFDM0_RxDetector3, &priv->framesync);
 	read_nic_byte(dev, rOFDM0_RxDetector2, &tmp);
 	priv->framesyncC34 = tmp;
-	RT_TRACE(COMP_INIT, "Default framesync (0x%x) = 0x%x \n",
+	RT_TRACE(COMP_INIT, "Default framesync (0x%x) = 0x%x\n",
 		rOFDM0_RxDetector3, priv->framesync);
 
 	/* Read SIFS (save the value read fome MACPHY_REG.txt) */
@@ -1463,6 +1463,7 @@ void rtl8192_SwChnl_WorkItem(struct net_device *dev)
 u8 rtl8192_phy_SwChnl(struct net_device *dev, u8 channel)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
+
 	RT_TRACE(COMP_CH, "%s(), SwChnlInProgress: %d\n", __func__,
 		 priv->SwChnlInProgress);
 	if (!priv->up)
@@ -1745,13 +1746,13 @@ void InitialGainOperateWorkItemCallBack(struct work_struct *work)
 		RT_TRACE(COMP_SCAN, "Scan InitialGainBackup 0xa0a is %x\n",
 			 priv->initgain_backup.cca);
 
-		RT_TRACE(COMP_SCAN, "Write scan initial gain = 0x%x \n",
+		RT_TRACE(COMP_SCAN, "Write scan initial gain = 0x%x\n",
 			 initial_gain);
 		write_nic_byte(dev, rOFDM0_XAAGCCore1, initial_gain);
 		write_nic_byte(dev, rOFDM0_XBAGCCore1, initial_gain);
 		write_nic_byte(dev, rOFDM0_XCAGCCore1, initial_gain);
 		write_nic_byte(dev, rOFDM0_XDAGCCore1, initial_gain);
-		RT_TRACE(COMP_SCAN, "Write scan 0xa0a = 0x%x \n",
+		RT_TRACE(COMP_SCAN, "Write scan 0xa0a = 0x%x\n",
 			 POWER_DETECTION_TH);
 		write_nic_byte(dev, 0xa0a, POWER_DETECTION_TH);
 		break;
@@ -1792,7 +1793,7 @@ void InitialGainOperateWorkItemCallBack(struct work_struct *work)
 			rtl8192_setBBreg(dev, UFWP, bMaskByte1, 0x1);
 		break;
 	default:
-		RT_TRACE(COMP_SCAN, "Unknown IG Operation. \n");
+		RT_TRACE(COMP_SCAN, "Unknown IG Operation.\n");
 		break;
 	}
 }
-- 
1.7.11.7

