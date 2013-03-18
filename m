Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab3CRXVD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 19:21:03 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:48462 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab3CRXVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 19:21:00 -0400
Message-ID: <1363648858.1774.17.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH 2/3] rbtree_test: add __init/__exit annotations
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Mon, 18 Mar 2013 16:20:58 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 lib/rbtree_test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/rbtree_test.c b/lib/rbtree_test.c
index 66ca26d..0fea14e 100644
--- a/lib/rbtree_test.c
+++ b/lib/rbtree_test.c
@@ -151,7 +151,7 @@ static void check_augmented(int nr_nodes)
 	}
 }
 
-static int rbtree_test_init(void)
+static int __init rbtree_test_init(void)
 {
 	int i, j;
 	cycles_t time1, time2, time;
@@ -224,7 +224,7 @@ static int rbtree_test_init(void)
 	return -EAGAIN; /* Fail will directly unload the module */
 }
 
-static void rbtree_test_exit(void)
+static void __exit rbtree_test_exit(void)
 {
 	pr_info("test exit\n");
 }
-- 
1.7.11.7




