Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871AbaHORZd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 13:25:33 -0400
Received: from kanga.kvack.org ([205.233.56.17]:34861 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbaHORZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 13:25:32 -0400
Date: Fri, 15 Aug 2014 13:25:31 -0400
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] aio: fix some comments
Message-ID: <2be4e7deec2d4398a0eb2165cc04086ebfc831d2.1408122224.git.bcrl@kvack.org>
References: <cover.1408122224.git.bcrl@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1408122224.git.bcrl@kvack.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function comments of aio_run_iocb and aio_read_events are out of date, so
fix them here.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
---
 fs/aio.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 6fc6b98..d6d9520 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1020,7 +1020,7 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 }
 EXPORT_SYMBOL(aio_complete);
 
-/* aio_read_events
+/* aio_read_events_ring
  *	Pull an event off of the ioctx's event ring.  Returns the number of
  *	events fetched
  */
@@ -1272,9 +1272,8 @@ static ssize_t aio_setup_single_vector(struct kiocb *kiocb,
 }
 
 /*
- * aio_setup_iocb:
- *	Performs the initial checks and aio retry method
- *	setup for the kiocb at the time of io submission.
+ * aio_run_iocb:
+ *	Performs the initial checks and io submission.
  */
 static ssize_t aio_run_iocb(struct kiocb *req, unsigned opcode,
 			    char __user *buf, bool compat)
-- 
1.8.2.1


-- 
"Thought is the essence of where you are now."
