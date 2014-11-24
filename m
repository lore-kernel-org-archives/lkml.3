Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbaKXRYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 12:24:35 -0500
Received: from mout.web.de ([212.227.17.12]:52051 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbaKXRYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 12:24:34 -0500
Message-ID: <547369C6.2000004@users.sourceforge.net>
Date: Mon, 24 Nov 2014 18:24:22 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Changman Lee <cm224.lee@samsung.com>, Jaegeuk Kim <jaegeuk@kernel.org>
CC: kernel-janitors@vger.kernel.org, trivial@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/6] f2fs: Fix typos for the word "destroy" in jump labels
References: <54736422.90409@users.sourceforge.net>
In-Reply-To: <54736422.90409@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:p091fbHoDYWzbfnhnrjFbZAVfKH42/gGG1tdpVULw6baw2hnzp0
 GA20F2ntK7IjQNA84IRkDXx1C2CdPhYYJ3lGQlpV13AUjuLeFeL6Tvu1Ptu9CbRZPz7p2Vi
 jKN9Xhrju5MitixY3TxIskgBtWne1G8vtTJXgjLN8REfdhYYueomp/H2/T/aJAD+gJWnO3n
 fKyUYQgY0R6+wKQfGGpxw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 24 Nov 2014 15:52:00 +0100

Two jump labels were adjusted in the implementation of the
create_node_manager_caches() function because these identifiers
contained typos.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 fs/f2fs/node.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 4537819..74f44fe 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -2057,17 +2057,17 @@ int __init create_node_manager_caches(void)
 	free_nid_slab = f2fs_kmem_cache_create("free_nid",
 			sizeof(struct free_nid));
 	if (!free_nid_slab)
-		goto destory_nat_entry;
+		goto destroy_nat_entry;
 
 	nat_entry_set_slab = f2fs_kmem_cache_create("nat_entry_set",
 			sizeof(struct nat_entry_set));
 	if (!nat_entry_set_slab)
-		goto destory_free_nid;
+		goto destroy_free_nid;
 	return 0;
 
-destory_free_nid:
+destroy_free_nid:
 	kmem_cache_destroy(free_nid_slab);
-destory_nat_entry:
+destroy_nat_entry:
 	kmem_cache_destroy(nat_entry_slab);
 fail:
 	return -ENOMEM;
-- 
2.1.3

