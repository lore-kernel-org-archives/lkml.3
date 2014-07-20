Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbaGTO3L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 10:29:11 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:62322 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753748AbaGTO3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 10:29:02 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIKAA/Ry1NXQ0aj/2dsb2JhbABZgw6BKa4jAQEBAQEFAW6dSAGBBBd2hAQBBScvIxBROR4ZiEYBsDOQcReFe4lQBxaEMAEEmyWUL4NGOy8
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>,
        Jay Cliburn <jcliburn@gmail.com>, Chris Snook <chris.snook@gmail.com>,
        netdev@vger.kernel.org
Subject: [PATCH 29/30] atl1c: remove unnecessary break after return
Date: Sun, 20 Jul 2014 16:27:54 +0200
Message-Id: <1405866475-24754-10-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405866475-24754-1-git-send-email-fabf@skynet.be>
References: <1405866475-24754-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_hw.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_hw.c b/drivers/net/ethernet/atheros/atl1c/atl1c_hw.c
index 1cda49a..52fdfe2 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_hw.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_hw.c
@@ -639,7 +639,6 @@ int atl1c_phy_init(struct atl1c_hw *hw)
 			dev_err(&pdev->dev, "Wrong Media type %d\n",
 				hw->media_type);
 		return -1;
-		break;
 	}
 
 	ret_val = atl1c_write_phy_reg(hw, MII_BMCR, mii_bmcr_data);
@@ -682,7 +681,6 @@ int atl1c_get_speed_and_duplex(struct atl1c_hw *hw, u16 *speed, u16 *duplex)
 		break;
 	default:
 		return -1;
-		break;
 	}
 
 	if (phy_data & GIGA_PSSR_DPLX)
-- 
1.9.1

