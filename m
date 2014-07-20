Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbaGTO3D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 10:29:03 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:62322 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753091AbaGTO27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 10:28:59 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIKAA/Ry1NXQ0aj/2dsb2JhbABZgw6BKa4jAQEBAQEFAW6dSAGBBBd2hAQBBScvIxBROR4ZiEYBsDOQcReFe4lQBxaEMAWbJZQvg0Y7Lw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>,
        Jay Cliburn <jcliburn@gmail.com>, Chris Snook <chris.snook@gmail.com>,
        netdev@vger.kernel.org
Subject: [PATCH 28/30] atlx: remove unnecessary break after return
Date: Sun, 20 Jul 2014 16:27:53 +0200
Message-Id: <1405866475-24754-9-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405866475-24754-1-git-send-email-fabf@skynet.be>
References: <1405866475-24754-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/ethernet/atheros/atlx/atl1.c | 1 -
 drivers/net/ethernet/atheros/atlx/atl2.c | 3 ---
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atlx/atl1.c b/drivers/net/ethernet/atheros/atlx/atl1.c
index b460db7..1546d55 100644
--- a/drivers/net/ethernet/atheros/atlx/atl1.c
+++ b/drivers/net/ethernet/atheros/atlx/atl1.c
@@ -910,7 +910,6 @@ static s32 atl1_get_speed_and_duplex(struct atl1_hw *hw, u16 *speed, u16 *duplex
 		if (netif_msg_hw(adapter))
 			dev_dbg(&pdev->dev, "error getting speed\n");
 		return ATLX_ERR_PHY_SPEED;
-		break;
 	}
 	if (phy_data & MII_ATLX_PSSR_DPLX)
 		*duplex = FULL_DUPLEX;
diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/ethernet/atheros/atlx/atl2.c
index 6746bd7..c194bc6 100644
--- a/drivers/net/ethernet/atheros/atlx/atl2.c
+++ b/drivers/net/ethernet/atheros/atlx/atl2.c
@@ -2493,7 +2493,6 @@ static s32 atl2_get_speed_and_duplex(struct atl2_hw *hw, u16 *speed,
 		break;
 	default:
 		return ATLX_ERR_PHY_SPEED;
-		break;
 	}
 
 	if (phy_data & MII_ATLX_PSSR_DPLX)
@@ -2933,11 +2932,9 @@ static int atl2_validate_option(int *value, struct atl2_option *opt)
 		case OPTION_ENABLED:
 			printk(KERN_INFO "%s Enabled\n", opt->name);
 			return 0;
-			break;
 		case OPTION_DISABLED:
 			printk(KERN_INFO "%s Disabled\n", opt->name);
 			return 0;
-			break;
 		}
 		break;
 	case range_option:
-- 
1.9.1

