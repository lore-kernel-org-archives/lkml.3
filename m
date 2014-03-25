Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbaCYTfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 15:35:31 -0400
Received: from smtprelay0139.hostedemail.com ([216.40.44.139]:60124 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754802AbaCYTf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 15:35:28 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1539:1568:1711:1714:1730:1747:1777:1792:2198:2199:2393:2559:2562:3138:3139:3140:3141:3142:3865:3866:3867:3871:4321:4605:5007:6261:10004:10026:10848:11026:11473:11658:11914:12296:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: team12_1276c70b95660
X-Filterd-Recvd-Size: 1334
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Subject: [PATCH 5/5] slab: Convert last uses of __FUNCTION__ to __func__
Date: Tue, 25 Mar 2014 12:35:07 -0700
Message-Id: <41f5cfd7a40408b2aad9a7d8cbb2162c4d4688d4.1395775901.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1395775901.git.joe@perches.com>
References: <cover.1395775901.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just about all of these have been converted to __func__,
so convert the last uses.

Signed-off-by: Joe Perches <joe@perches.com>
---
 mm/slab.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slab.h b/mm/slab.h
index 3045316..0d13b70 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -249,7 +249,7 @@ static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
 		return cachep;
 
 	pr_err("%s: Wrong slab cache. %s but object is from %s\n",
-		__FUNCTION__, cachep->name, s->name);
+	       __func__, cachep->name, s->name);
 	WARN_ON_ONCE(1);
 	return s;
 }
-- 
1.8.1.2.459.gbcd45b4.dirty

