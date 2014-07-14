Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbaGNQb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:31:26 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:31261 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755962AbaGNQbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:31:17 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtgNACUFxFNXQxRI/2dsb2JhbABZgw6tSQEBAQEBAQUBbpt/AYEVF3WEBAEFJy8jEFE5HhmIRgHIMReFe4lQBxaELQWbDpQeg0Y7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>,
        netdev@vger.kernel.org
Subject: [PATCH 01/16] packet: remove unnecessary break after return
Date: Mon, 14 Jul 2014 18:30:51 +0200
Message-Id: <1405355467-7350-2-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1405355467-7350-1-git-send-email-fabf@skynet.be>
References: <1405355467-7350-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/packet/af_packet.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index b85c67c..614ca91 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3071,10 +3071,8 @@ static int packet_dev_mc(struct net_device *dev, struct packet_mclist *i,
 		break;
 	case PACKET_MR_PROMISC:
 		return dev_set_promiscuity(dev, what);
-		break;
 	case PACKET_MR_ALLMULTI:
 		return dev_set_allmulti(dev, what);
-		break;
 	case PACKET_MR_UNICAST:
 		if (i->alen != dev->addr_len)
 			return -EINVAL;
-- 
1.8.4.5

