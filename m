Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643AbaKDBFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 20:05:06 -0500
Received: from ozlabs.org ([103.22.144.67]:49944 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbaKDBFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 20:05:03 -0500
Date: Tue, 4 Nov 2014 12:05:01 +1100
From: Anton Blanchard <anton@samba.org>
To: jack@suse.cz
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] quota: Add log level to printk
Message-ID: <20141104120501.0318cc7d@kryten>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: b/fs/quota/dquot.c
===================================================================
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2743,7 +2743,7 @@ static int __init dquot_init(void)
 	for (i = 0; i < nr_hash; i++)
 		INIT_HLIST_HEAD(dquot_hash + i);
 
-	printk("Dquot-cache hash table entries: %ld (order %ld, %ld bytes)\n",
+	pr_info("Dquot-cache hash table entries: %ld (order %ld, %ld bytes)\n",
 			nr_hash, order, (PAGE_SIZE << order));
 
 	register_shrinker(&dqcache_shrinker);
