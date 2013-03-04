Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932851Ab3CDWcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 17:32:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:44010 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932654Ab3CDWcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 17:32:19 -0500
Message-ID: <51352116.5030702@infradead.org>
Date: Mon, 04 Mar 2013 14:32:54 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] idr: fix new kernel-doc warnings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix new kernel-doc warnings in idr:

Warning(include/linux/idr.h:113): No description found for parameter 'idr'
Warning(include/linux/idr.h:113): Excess function parameter 'idp' description in 'idr_find'
Warning(lib/idr.c:232): Excess function parameter 'id' description in 'sub_alloc'
Warning(lib/idr.c:232): Excess function parameter 'id' description in 'sub_alloc'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc:	Tejun Heo <tj@kernel.org>
---
 include/linux/idr.h |    2 +-
 lib/idr.c           |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

--- lnx-39-rc1.orig/include/linux/idr.h
+++ lnx-39-rc1/include/linux/idr.h
@@ -99,7 +99,7 @@ static inline void idr_preload_end(void)
 
 /**
  * idr_find - return pointer for given id
- * @idp: idr handle
+ * @idr: idr handle
  * @id: lookup key
  *
  * Return the pointer given the id it has been registered with.  A %NULL
--- lnx-39-rc1.orig/lib/idr.c
+++ lnx-39-rc1/lib/idr.c
@@ -214,7 +214,6 @@ EXPORT_SYMBOL(idr_pre_get);
  * sub_alloc - try to allocate an id without growing the tree depth
  * @idp: idr handle
  * @starting_id: id to start search at
- * @id: pointer to the allocated handle
  * @pa: idr_layer[MAX_IDR_LEVEL] used as backtrack buffer
  * @gfp_mask: allocation mask for idr_layer_alloc()
  * @layer_idr: optional idr passed to idr_layer_alloc()
