Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194AbaDQTj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 15:39:28 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:32965 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751110AbaDQTjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 15:39:21 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApEUAGYtUFNbsmyI/2dsb2JhbABZgwaCTKhPmVYCAoElF3SCUxMcIxiBAiQTiAABzAGNfmSEPwEDjmiKBQGKaodjgzM7gSw
Date: Thu, 17 Apr 2014 21:41:16 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] block/blk-throttle.c: add static to
 blk_throtl_dispatch_work_fn
Message-Id: <20140417214116.f558fe95d1e313e7035494f1@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_throtl_dispatch_work_fn is only used in blk-throttle.c

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 block/blk-throttle.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 033745c..680a0cc 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1258,7 +1258,7 @@ out_unlock:
  * of throtl_data->service_queue.  Those bio's are ready and issued by this
  * function.
  */
-void blk_throtl_dispatch_work_fn(struct work_struct *work)
+static void blk_throtl_dispatch_work_fn(struct work_struct *work)
 {
 	struct throtl_data *td = container_of(work, struct throtl_data,
 					      dispatch_work);
-- 
1.8.4.5

