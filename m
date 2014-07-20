Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbaGTO3o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 10:29:44 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:62322 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753669AbaGTO2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 10:28:54 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIKAA/Ry1NXQ0aj/2dsb2JhbABZgw6BKa4jAQEBAQEFAW6dSAGBBBd2hAQBBVYjEFE5HhmIRgGwM5BxF4V7iGxkBxaEMAWbJZQvg0Y7L4ED
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>,
        Jay Cliburn <jcliburn@gmail.com>, Chris Snook <chris.snook@gmail.com>,
        netdev@vger.kernel.org
Subject: [PATCH 27/30] atl1e: remove unnecessary break after return
Date: Sun, 20 Jul 2014 16:27:52 +0200
Message-Id: <1405866475-24754-8-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405866475-24754-1-git-send-email-fabf@skynet.be>
References: <1405866475-24754-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/ethernet/atheros/atl1e/atl1e_hw.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_hw.c b/drivers/net/ethernet/atheros/atl1e/atl1e_hw.c
index 923063d..113565d 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_hw.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_hw.c
@@ -618,7 +618,6 @@ int atl1e_get_speed_and_duplex(struct atl1e_hw *hw, u16 *speed, u16 *duplex)
 		break;
 	default:
 		return AT_ERR_PHY_SPEED;
-		break;
 	}
 
 	if (phy_data & MII_AT001_PSSR_DPLX)
-- 
1.9.1

