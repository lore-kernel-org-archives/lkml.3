Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbaDDOpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:45:39 -0400
Received: from smtp.citrix.com ([66.165.176.89]:46373 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393AbaDDOpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:45:31 -0400
X-IronPort-AV: E=Sophos;i="4.97,795,1389744000"; 
   d="scan'208";a="118034987"
From: Zoltan Kiss <zoltan.kiss@citrix.com>
To: <ian.campbell@citrix.com>, <wei.liu2@citrix.com>,
        <xen-devel@lists.xenproject.org>
CC: <trivial@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Zoltan Kiss <zoltan.kiss@citrix.com>
Subject: [PATCH] xen-netback: Trivial format string fix
Date: Fri, 4 Apr 2014 15:45:24 +0100
Message-ID: <1396622724-26090-1-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.2.133]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a "%" after pending_idx instead of ":".

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
---

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 8d3bb4a..51695e2 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -955,7 +955,7 @@ static int xenvif_tx_check_gop(struct xenvif *vif,
 	if (unlikely(err)) {
 		if (net_ratelimit())
 			netdev_dbg(vif->dev,
-				   "Grant copy of header failed! status: %d pending_idx% %u ref: %u\n",
+				   "Grant copy of header failed! status: %d pending_idx: %u ref: %u\n",
 				   (*gopp_copy)->status,
 				   pending_idx,
 				   (*gopp_copy)->source.u.ref);
@@ -984,7 +984,7 @@ check_frags:
 		/* Error on this fragment: respond to client with an error. */
 		if (net_ratelimit())
 			netdev_dbg(vif->dev,
-				   "Grant map of %d. frag failed! status: %d pending_idx% %u ref: %u\n",
+				   "Grant map of %d. frag failed! status: %d pending_idx: %u ref: %u\n",
 				   i,
 				   gop_map->status,
 				   pending_idx,
