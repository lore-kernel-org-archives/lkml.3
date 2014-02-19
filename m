Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbaBSMWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 07:22:53 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:52791 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaBSMWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 07:22:51 -0500
Date: Wed, 19 Feb 2014 20:22:22 +0800
From: Shaohua Li <shli@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk
Subject: [patch]blk-mq: remove obsolete comments
Message-ID: <20140219122222.GB17818@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We now have blk_mq_stop/start_queues API, delete the obsolete comments.

Signed-off-by: Shaohua Li<shli@fusionio.com>
---
 block/blk-mq.c |    5 -----
 1 file changed, 5 deletions(-)

Index: linux/block/blk-mq.c
===================================================================
--- linux.orig/block/blk-mq.c	2014-02-17 16:14:57.111662047 +0800
+++ linux/block/blk-mq.c	2014-02-19 16:22:58.114750112 +0800
@@ -598,11 +598,6 @@ static void __blk_mq_run_hw_queue(struct
 			queued++;
 			continue;
 		case BLK_MQ_RQ_QUEUE_BUSY:
-			/*
-			 * FIXME: we should have a mechanism to stop the queue
-			 * like blk_stop_queue, otherwise we will waste cpu
-			 * time
-			 */
 			list_add(&rq->queuelist, &rq_list);
 			blk_mq_requeue_request(rq);
 			break;
