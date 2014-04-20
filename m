Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751153AbaDTXDi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 19:03:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60875 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbaDTXDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 19:03:36 -0400
Message-ID: <53545243.9000005@infradead.org>
Date: Sun, 20 Apr 2014 16:03:31 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, axboe <axboe@kernel.dk>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] fs: fix new kernel-doc warnings in fs/bio.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix new kernel-doc warnings in fs/bio.c:

Warning(fs/bio.c:316): No description found for parameter 'bio'
Warning(fs/bio.c:316): No description found for parameter 'parent'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 fs/bio.c |    2 ++
 1 file changed, 2 insertions(+)

--- lnx-315-rc2.orig/fs/bio.c
+++ lnx-315-rc2/fs/bio.c
@@ -305,6 +305,8 @@ static void bio_chain_endio(struct bio *
 
 /**
  * bio_chain - chain bio completions
+ * @bio: the target bio
+ * @parent: the @bio's parent bio
  *
  * The caller won't have a bi_end_io called when @bio completes - instead,
  * @parent's bi_end_io won't be called until both @parent and @bio have
