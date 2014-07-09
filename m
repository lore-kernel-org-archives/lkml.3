Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbaGIMIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:08:07 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:52407 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276AbaGIMIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:08:02 -0400
From: sanjeev sharma <sanjeevsharmaengg@gmail.com>
To: gregkh@linuxfoundation.org
Cc: rmfrfs@gmail.com, peter.senna@gmail.com, teobaluta@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        sanjeev sharma <sanjeev_sharma@mentor.com>,
        Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
Subject: [PATCH v3 1/4] staging: rtl8192u: Remove useless return statements.
Date: Wed,  9 Jul 2014 17:49:39 +0530
Message-Id: <1404908382-7043-2-git-send-email-sanjeevsharmaengg@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1404908382-7043-1-git-send-email-sanjeevsharmaengg@gmail.com>
References: <20140708100142.GR25934@mwanda>
 <1404908382-7043-1-git-send-email-sanjeevsharmaengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: sanjeev sharma <sanjeev_sharma@mentor.com>

This patch will remove unneeded return statements in
code.

Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
---
 drivers/staging/rtl8192u/r819xU_phy.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/staging/rtl8192u/r819xU_phy.c b/drivers/staging/rtl8192u/r819xU_phy.c
index 02554c9..0bcdd4e 100644
--- a/drivers/staging/rtl8192u/r819xU_phy.c
+++ b/drivers/staging/rtl8192u/r819xU_phy.c
@@ -101,7 +101,6 @@ void rtl8192_setBBreg(struct net_device *dev, u32 reg_addr, u32 bitmask,
 	} else {
 		write_nic_dword(dev, reg_addr, data);
 	}
-	return;
 }
 
 /******************************************************************************
@@ -281,7 +280,6 @@ static void rtl8192_phy_RFSerialWrite(struct net_device *dev,
 					 priv->RfReg0Value[eRFPath] << 16);
 		}
 	}
-	return;
 }
 
 /******************************************************************************
@@ -332,7 +330,6 @@ void rtl8192_phy_SetRFReg(struct net_device *dev, RF90_RADIO_PATH_E eRFPath,
 			rtl8192_phy_RFSerialWrite(dev, eRFPath, reg_addr, data);
 		}
 	}
-	return;
 }
 
 /******************************************************************************
@@ -513,7 +510,6 @@ void rtl8192_phy_configmac(struct net_device *dev)
 		rtl8192_setBBreg(dev, pdwArray[i], pdwArray[i+1],
 				 pdwArray[i+2]);
 	}
-	return;
 }
 
 /******************************************************************************
@@ -559,7 +555,6 @@ void rtl8192_phyConfigBB(struct net_device *dev, u8 ConfigType)
 				 rtl819XAGCTAB_Array[i+1]);
 		}
 	}
-	return;
 }
 
 /******************************************************************************
@@ -846,7 +841,6 @@ static void rtl8192_BB_Config_ParaFile(struct net_device *dev)
 	priv->bCckHighPower = (u8)rtl8192_QueryBBReg(dev,
 						     rFPGA0_XA_HSSIParameter2,
 						     0x200);
-	return;
 }
 
 /******************************************************************************
@@ -864,7 +858,6 @@ void rtl8192_BBConfig(struct net_device *dev)
 	 * implemented, so use file first.
 	 * FIXME: should implement it for hardcode? */
 	rtl8192_BB_Config_ParaFile(dev);
-	return;
 }
 
 
@@ -912,8 +905,6 @@ void rtl8192_phy_getTxPower(struct net_device *dev)
 
 	/* Read SIFS (save the value read fome MACPHY_REG.txt) */
 	read_nic_word(dev, SIFS, &priv->SifsTime);
-
-	return;
 }
 
 /******************************************************************************
@@ -942,7 +933,6 @@ void rtl8192_phy_setTxPower(struct net_device *dev, u8 channel)
 			 __func__);
 		break;
 	}
-	return;
 }
 
 /******************************************************************************
@@ -963,7 +953,6 @@ void rtl8192_phy_RFConfig(struct net_device *dev)
 			RT_TRACE(COMP_ERR, "error chip id\n");
 			break;
 	}
-	return;
 }
 
 /******************************************************************************
@@ -974,7 +963,6 @@ void rtl8192_phy_RFConfig(struct net_device *dev)
  ******************************************************************************/
 void rtl8192_phy_updateInitGain(struct net_device *dev)
 {
-	return;
 }
 
 /******************************************************************************
@@ -1094,7 +1082,6 @@ static void rtl8192_SetTxPowerLevel(struct net_device *dev, u8 channel)
 		RT_TRACE(COMP_ERR, "unknown rf chip ID in %s()\n", __func__);
 		break;
 	}
-	return;
 }
 
 /******************************************************************************
-- 
1.7.11.7

