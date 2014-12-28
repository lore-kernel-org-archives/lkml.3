Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbaL1Gey (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 01:34:54 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:58697 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaL1Gex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 01:34:53 -0500
From: Alexander Kuleshov <kuleshovmail@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: [PATCH] block: Fix a typo in comment
Date: Sun, 28 Dec 2014 12:34:40 +0600
Message-Id: <1419748480-6297-1-git-send-email-kuleshovmail@gmail.com>
X-Mailer: git-send-email 2.2.1.202.g98acd41.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
---
 block/blk-merge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 89b97b5..5d6a2bc 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -446,7 +446,7 @@ void blk_rq_set_mixed_merge(struct request *rq)
 	/*
 	 * @rq will no longer represent mixable attributes for all the
 	 * contained bios.  It will just track those of the first one.
-	 * Distributes the attributs to each bio.
+	 * Distributes the attributes to each bio.
 	 */
 	for (bio = rq->bio; bio; bio = bio->bi_next) {
 		WARN_ON_ONCE((bio->bi_rw & REQ_FAILFAST_MASK) &&
-- 
2.2.1.202.g98acd41.dirty

