Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab3C2Uqs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 16:46:48 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:14767 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756963Ab3C2Uqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 16:46:38 -0400
Message-ID: <1364589997.13783.3.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH v2 2/2] rbtree_test: add __init/__exit annotations
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Fri, 29 Mar 2013 13:46:37 -0700
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
index 9951503..122f02f 100644
--- a/lib/rbtree_test.c
+++ b/lib/rbtree_test.c
@@ -149,7 +149,7 @@ static void check_augmented(int nr_nodes)
 	}
 }
 
-static int rbtree_test_init(void)
+static int __init rbtree_test_init(void)
 {
 	int i, j;
 	cycles_t time1, time2, time;
@@ -222,7 +222,7 @@ static int rbtree_test_init(void)
 	return -EAGAIN; /* Fail will directly unload the module */
 }
 
-static void rbtree_test_exit(void)
+static void __exit rbtree_test_exit(void)
 {
 	printk(KERN_ALERT "test exit\n");
 }
-- 
1.7.11.7




