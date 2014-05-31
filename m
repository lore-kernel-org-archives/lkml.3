Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbaEaLGe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 07:06:34 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:63994 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418AbaEaLGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 07:06:32 -0400
Date: Sat, 31 May 2014 13:06:28 +0200
From: Robin Schroer <sulamiification@gmail.com>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org
Subject: [PATCH] driver/netfilter/nfnetlink: removed unused variable
Message-ID: <20140531110628.GA30443@shodan.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes the unused struct net *net = sock_net(skb->sk);

Signed-off-by: Robin Schroer <sulamiification@gmail.com>
---
 net/netfilter/nfnetlink.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index c138b8f..5cc9db2 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -226,7 +226,6 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 				u_int16_t subsys_id)
 {
 	struct sk_buff *nskb, *oskb = skb;
-	struct net *net = sock_net(skb->sk);
 	const struct nfnetlink_subsystem *ss;
 	const struct nfnl_callback *nc;
 	bool success = true, done = false;
-- 
1.9.3


-- 

Robin Schroer

