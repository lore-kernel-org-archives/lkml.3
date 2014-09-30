Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbaI3VvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:51:15 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:49747 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbaI3VvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:51:12 -0400
Message-ID: <542B25CC.80509@gmail.com>
Date: Tue, 30 Sep 2014 22:51:08 +0100
From: Paul McQuade <paulmcquad@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Paul McQuade <paulmcquad@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Sasha Levin <sasha.levin@oracle.com>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm: filemap Remove trailing whitespace
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9c3926a50ec96a69e36266a9191fa680249b4e06 Mon Sep 17 00:00:00 2001
From: Paul McQuade <paulmcquad@gmail.com>
Date: Tue, 30 Sep 2014 22:43:08 +0100
Subject: [PATCH] mm: filemap Remove trailing whitespace

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
-    struct page *page;
+    struct page *page;
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

