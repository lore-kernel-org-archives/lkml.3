Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbaLGT3N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 14:29:13 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:3211 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753474AbaLGT0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 14:26:52 -0500
X-IronPort-AV: E=Sophos;i="5.07,534,1413237600"; 
   d="scan'208";a="111932940"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux@rasmusvillemoes.dk, joe@perches.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/20] chelsio: fix misspelling of current function in string
Date: Sun,  7 Dec 2014 20:20:56 +0100
Message-Id: <1417980062-25151-15-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace a misspelled function name by %s and then __func__.

This was done using Coccinelle, including the use of Levenshtein distance,
as proposed by Rasmus Villemoes.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
The semantic patch is difficult to summarize, but is available in the cover
letter of this patch series.

 drivers/net/ethernet/chelsio/cxgb/sge.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb/sge.c b/drivers/net/ethernet/chelsio/cxgb/sge.c
index 4c58793..86222a1 100644
--- a/drivers/net/ethernet/chelsio/cxgb/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb/sge.c
@@ -301,7 +301,7 @@ unsigned int t1_sched_update_parms(struct sge *sge, unsigned int port,
 	struct sched_port *p = &s->p[port];
 	unsigned int max_avail_segs;
 
-	pr_debug("t1_sched_update_params mtu=%d speed=%d\n", mtu, speed);
+	pr_debug("%s mtu=%d speed=%d\n", __func__, mtu, speed);
 	if (speed)
 		p->speed = speed;
 	if (mtu)

