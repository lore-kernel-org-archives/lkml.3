Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751195AbaI3Wso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 18:48:44 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:56583 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaI3Wsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 18:48:43 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: paulmcquad@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, sasha.levin@oracle.com,
        kirill.shutemov@linux.intel.com, mgorman@suse.de, riel@redhat.com,
        hannes@cmpxchg.org, viro@zeniv.linux.org.uk, akpm@linux-foundation.org
Subject: [PATCH] mm: filemap Remove trailing whitespace
Date: Tue, 30 Sep 2014 23:48:29 +0100
Message-Id: <1412117309-20721-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove 2 trailing whitespace errors

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 mm/filemap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 90effcd..30ffd32 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1744,7 +1744,7 @@ EXPORT_SYMBOL(generic_file_read_iter);
 static int page_cache_read(struct file *file, pgoff_t offset)
 {
 	struct address_space *mapping = file->f_mapping;
-	struct page *page; 
+	struct page *page;
 	int ret;
 
 	do {
@@ -1761,7 +1761,7 @@ static int page_cache_read(struct file *file, pgoff_t offset)
 		page_cache_release(page);
 
 	} while (ret == AOP_TRUNCATED_PAGE);
-		
+
 	return ret;
 }
 
-- 
1.9.1

