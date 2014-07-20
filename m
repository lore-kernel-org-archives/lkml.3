Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649AbaGTO2u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 10:28:50 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:62322 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753158AbaGTO2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 10:28:48 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIKAA/Ry1NXQ0aj/2dsb2JhbABZgw6BKa4jAQEBAQEFAW6dSAGBBBd2hAQBBVYjEFE5HhmIRgGwM5BxF4V7iGxkBxaEMAWbJZQvg0Y7L4ED
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>,
        Daniele Venzano <venza@brownhat.org>, netdev@vger.kernel.org
Subject: [PATCH 24/30] sis900: remove unnecessary break after return
Date: Sun, 20 Jul 2014 16:27:49 +0200
Message-Id: <1405866475-24754-5-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405866475-24754-1-git-send-email-fabf@skynet.be>
References: <1405866475-24754-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/ethernet/sis/sis900.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/sis/sis900.c b/drivers/net/ethernet/sis/sis900.c
index 6072f09..7bea17c 100644
--- a/drivers/net/ethernet/sis/sis900.c
+++ b/drivers/net/ethernet/sis/sis900.c
@@ -2258,7 +2258,6 @@ static int sis900_set_config(struct net_device *dev, struct ifmap *map)
 		case IF_PORT_100BASEFX: /* 100BaseFx */
                 	/* These Modes are not supported (are they?)*/
 			return -EOPNOTSUPP;
-			break;
 
 		default:
 			return -EINVAL;
-- 
1.9.1

