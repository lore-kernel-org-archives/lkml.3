Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbaIXJF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:05:56 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:33788 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbaIXIzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:55:54 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@linuxfoundation.org
Cc: joe@perches.com, davem@davemloft.net, angus@agibson.me,
        tklauser@distanz.ch, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 2/4] staging: et131x: Cat some lines less than 80 columns
Date: Wed, 24 Sep 2014 09:54:40 +0100
Message-Id: <1411548882-10639-2-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411548882-10639-1-git-send-email-mark.einon@gmail.com>
References: <1411506437.29268.13.camel@joe-AO725>
 <1411548882-10639-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some split lines are less than 80 chars if rejoined, so rejoin them.

Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index b976c75..f5459ec 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -3389,7 +3389,8 @@ static void et131x_adjust_link(struct net_device *netdev)
 			et131x_mii_read(adapter, PHY_MPHY_CONTROL_REG,
 					&register18);
 			et131x_mii_write(adapter, phydev->addr,
-					 PHY_MPHY_CONTROL_REG, register18 | 0x4);
+					 PHY_MPHY_CONTROL_REG,
+					 register18 | 0x4);
 			et131x_mii_write(adapter, phydev->addr, PHY_INDEX_REG,
 					 register18 | 0x8402);
 			et131x_mii_write(adapter, phydev->addr, PHY_DATA_REG,
@@ -3422,7 +3423,8 @@ static void et131x_adjust_link(struct net_device *netdev)
 			et131x_mii_read(adapter, PHY_MPHY_CONTROL_REG,
 					&register18);
 			et131x_mii_write(adapter, phydev->addr,
-					 PHY_MPHY_CONTROL_REG, register18 | 0x4);
+					 PHY_MPHY_CONTROL_REG,
+					 register18 | 0x4);
 			et131x_mii_write(adapter, phydev->addr,
 					 PHY_INDEX_REG, register18 | 0x8402);
 			et131x_mii_write(adapter, phydev->addr,
@@ -3746,8 +3748,7 @@ static irqreturn_t et131x_isr(int irq, void *dev_id)
 		 */
 		/* TRAP();*/
 
-		dev_warn(&adapter->pdev->dev,
-			 "RxDMA_ERR interrupt, error %x\n",
+		dev_warn(&adapter->pdev->dev, "RxDMA_ERR interrupt, error %x\n",
 			 readl(&iomem->txmac.tx_test));
 	}
 
@@ -3773,8 +3774,7 @@ static irqreturn_t et131x_isr(int irq, void *dev_id)
 		 * occur. In a nutshell, the whole Tx path will have to be reset
 		 * and re-configured afterwards.
 		 */
-		dev_warn(&adapter->pdev->dev,
-			 "TXMAC interrupt, error 0x%08x\n",
+		dev_warn(&adapter->pdev->dev, "TXMAC interrupt, error 0x%08x\n",
 			 err);
 
 		/* If we are debugging, we want to see this error, otherwise we
-- 
1.7.10.4

