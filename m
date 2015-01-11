Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbbAKOFn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 09:05:43 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:47217 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbbAKOFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 09:05:41 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: sched: sch_teql: Remove unused function
Date: Sun, 11 Jan 2015 15:08:46 +0100
Message-Id: <1420985326-18201-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function teql_neigh_release() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 net/sched/sch_teql.c |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/net/sched/sch_teql.c b/net/sched/sch_teql.c
index 6ada423..4899d4a 100644
--- a/net/sched/sch_teql.c
+++ b/net/sched/sch_teql.c
@@ -122,13 +122,6 @@ teql_peek(struct Qdisc *sch)
 	return NULL;
 }
 
-static inline void
-teql_neigh_release(struct neighbour *n)
-{
-	if (n)
-		neigh_release(n);
-}
-
 static void
 teql_reset(struct Qdisc *sch)
 {
-- 
1.7.10.4

