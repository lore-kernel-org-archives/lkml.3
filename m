Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaGTOSe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 10:18:34 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:42171 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752623AbaGTOSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 10:18:33 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIKALLOy1NXQ0aj/2dsb2JhbABZgw6BKa4jAQEBAQEFAW6dSAGBBBd2hAQBBScvIxBROR4ZiEYBsDGQcBeFe4hsZAcWhDAFmyWLYYhOg0Y7L4ED
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>,
        netdev@vger.kernel.org
Subject: [PATCH 02/30] eth_v10: remove unnecessary break after return
Date: Sun, 20 Jul 2014 16:16:10 +0200
Message-Id: <1405865801-18806-3-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405865801-18806-1-git-send-email-fabf@skynet.be>
References: <1405865801-18806-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/cris/eth_v10.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/cris/eth_v10.c b/drivers/net/cris/eth_v10.c
index 29e272c..64c016a 100644
--- a/drivers/net/cris/eth_v10.c
+++ b/drivers/net/cris/eth_v10.c
@@ -1496,7 +1496,6 @@ e100_set_config(struct net_device *dev, struct ifmap *map)
 		case IF_PORT_AUI:
 			spin_unlock(&np->lock);
 			return -EOPNOTSUPP;
-			break;
 		default:
 			printk(KERN_ERR "%s: Invalid media selected", dev->name);
 			spin_unlock(&np->lock);
-- 
1.9.1

