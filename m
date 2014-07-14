Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206AbaGNQfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:35:43 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:28504 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756215AbaGNQfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:35:33 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiwRAIUGxFNXQxRI/2dsb2JhbABZgw6tRAUBAQEBAQEFAQVpm3+BFhd1hDEvI4EaN4hGAcg2F4V7iGxkHYQtBZsOlB6DRjuBMQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH 10/16] netfilter: remove unnecessary break after return
Date: Mon, 14 Jul 2014 18:36:33 +0200
Message-Id: <1405355799-7691-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/ipv6/netfilter/ip6t_ipv6header.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv6/netfilter/ip6t_ipv6header.c b/net/ipv6/netfilter/ip6t_ipv6header.c
index 54bd979..8b14744 100644
--- a/net/ipv6/netfilter/ip6t_ipv6header.c
+++ b/net/ipv6/netfilter/ip6t_ipv6header.c
@@ -94,7 +94,6 @@ ipv6header_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 			break;
 		default:
 			return false;
-			break;
 		}
 
 		nexthdr = hp->nexthdr;
-- 
1.8.4.5

