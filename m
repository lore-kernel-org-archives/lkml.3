Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab3J3Auw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 20:50:52 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:65136 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab3J3Auu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 20:50:50 -0400
X-IronPort-AV: E=Sophos;i="4.93,597,1378857600"; 
   d="scan'208";a="66081873"
From: Zoltan Kiss <zoltan.kiss@citrix.com>
To: <ian.campbell@citrix.com>, <wei.liu2@citrix.com>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>
Subject: [PATCH net-next RFC 4/5] xen-netback: Fix indentations
Date: Wed, 30 Oct 2013 00:50:19 +0000
Message-ID: <1383094220-14775-5-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383094220-14775-1-git-send-email-zoltan.kiss@citrix.com>
References: <1383094220-14775-1-git-send-email-zoltan.kiss@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've left intentionally these indentations in this way, to improve readability of previous patches.

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
---
 drivers/net/xen-netback/netback.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index c91dd36..204fa46 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -882,8 +882,8 @@ static struct gnttab_map_grant_ref *xenvif_get_requests(struct xenvif *vif,
 
 	for (shinfo->nr_frags = start; shinfo->nr_frags < nr_slots;
 	     shinfo->nr_frags++, txp++, gop++) {
-				index = pending_index(vif->pending_cons++);
-				pending_idx = vif->pending_ring[index];
+		index = pending_index(vif->pending_cons++);
+		pending_idx = vif->pending_ring[index];
 		xenvif_tx_create_gop(vif, pending_idx, txp, gop);
 		frag_set_pending_idx(&frags[shinfo->nr_frags], pending_idx);
 	}
@@ -929,7 +929,7 @@ static int xenvif_tx_check_gop(struct xenvif *vif,
 		tx_info = &vif->pending_tx_info[pending_idx];
 
 		/* Check error status: if okay then remember grant handle. */
-			newerr = (++gop)->status;
+		newerr = (++gop)->status;
 
 		if (likely(!newerr)) {
 			if (vif->grant_tx_handle[pending_idx] !=
@@ -1717,10 +1717,10 @@ static void xenvif_idx_release(struct xenvif *vif, u16 pending_idx,
 	struct pending_tx_info *pending_tx_info;
 	pending_ring_idx_t index;
 
-		pending_tx_info = &vif->pending_tx_info[pending_idx];
-		make_tx_response(vif, &pending_tx_info->req, status);
-		index = pending_index(vif->pending_prod++);
-		vif->pending_ring[index] = pending_idx;
+	pending_tx_info = &vif->pending_tx_info[pending_idx];
+	make_tx_response(vif, &pending_tx_info->req, status);
+	index = pending_index(vif->pending_prod++);
+	vif->pending_ring[index] = pending_idx;
 }
 
 void xenvif_idx_unmap(struct xenvif *vif, u16 pending_idx)
