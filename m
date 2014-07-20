Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbaGTO2i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 10:28:38 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:53590 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752960AbaGTO2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 10:28:36 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIKAA/Ry1NXQ0aj/2dsb2JhbABZgw6BKa4jAQEBAQEFAW6dSAGBBBd2hAQBBScvIxBROR4ZiEYBsDOQcReFe4lQBxaEMAWbJZQvg0Y7Lw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>,
        netdev@vger.kernel.org
Subject: [PATCH 21/30] 8390: remove unnecessary break after return
Date: Sun, 20 Jul 2014 16:27:46 +0200
Message-Id: <1405866475-24754-2-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405866475-24754-1-git-send-email-fabf@skynet.be>
References: <1405866475-24754-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/ethernet/8390/mac8390.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/ethernet/8390/mac8390.c b/drivers/net/ethernet/8390/mac8390.c
index 90e825e..65cf60f 100644
--- a/drivers/net/ethernet/8390/mac8390.c
+++ b/drivers/net/ethernet/8390/mac8390.c
@@ -178,10 +178,8 @@ static enum mac8390_type __init mac8390_ident(struct nubus_dev *dev)
 		case NUBUS_DRHW_APPLE_SONIC_LC:
 		case NUBUS_DRHW_SONNET:
 			return MAC8390_NONE;
-			break;
 		default:
 			return MAC8390_APPLE;
-			break;
 		}
 		break;
 
@@ -189,13 +187,10 @@ static enum mac8390_type __init mac8390_ident(struct nubus_dev *dev)
 		switch (dev->dr_hw) {
 		case NUBUS_DRHW_ASANTE_LC:
 			return MAC8390_NONE;
-			break;
 		case NUBUS_DRHW_CABLETRON:
 			return MAC8390_CABLETRON;
-			break;
 		default:
 			return MAC8390_APPLE;
-			break;
 		}
 		break;
 
@@ -220,10 +215,8 @@ static enum mac8390_type __init mac8390_ident(struct nubus_dev *dev)
 		switch (dev->dr_hw) {
 		case NUBUS_DRHW_INTERLAN:
 			return MAC8390_INTERLAN;
-			break;
 		default:
 			return MAC8390_KINETICS;
-			break;
 		}
 		break;
 
@@ -563,7 +556,6 @@ static int __init mac8390_initdev(struct net_device *dev,
 		case ACCESS_UNKNOWN:
 			pr_err("Don't know how to access card memory!\n");
 			return -ENODEV;
-			break;
 
 		case ACCESS_16:
 			/* 16 bit card, register map is reversed */
-- 
1.9.1

