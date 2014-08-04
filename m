Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaHDNWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 09:22:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799AbaHDNWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 09:22:23 -0400
Date: Mon, 4 Aug 2014 15:22:40 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH] bridge: remove a useless comment
Message-ID: <1407158554-17384-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 6cbdceeb1cb12c7d620161925a8c3e81daadb2e4
    bridge: Dump vlan information from a bridge port
introduced a comment in an attempt to explain the
code logic. The comment is unfinished so it confuses more
than it explains, remove it.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 net/bridge/br_netlink.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 26edb51..cb5fcf6 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -208,7 +208,6 @@ int br_getlink(struct sk_buff *skb, u32 pid, u32 seq,
 	int err = 0;
 	struct net_bridge_port *port = br_port_get_rtnl(dev);
 
-	/* not a bridge port and  */
 	if (!port && !(filter_mask & RTEXT_FILTER_BRVLAN))
 		goto out;
 
-- 
MST
