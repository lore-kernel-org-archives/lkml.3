Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934546AbaFSS0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 14:26:06 -0400
Received: from mx1.HRZ.Uni-Dortmund.DE ([129.217.128.51]:34820 "EHLO
	unimail.uni-dortmund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933454AbaFSS0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 14:26:04 -0400
X-Greylist: delayed 409 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jun 2014 14:26:03 EDT
From: Benedict Boerger <benedict.boerger@cs.tu-dortmund.de>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        Benedict Boerger <benedict.boerger@cs.tu-dortmund.de>
Subject: [PATCH] staging: sep: Fix checkpatch.pl warnings 
Date: Thu, 19 Jun 2014 20:18:51 +0200
Message-Id: <1403201931-6816-1-git-send-email-benedict.boerger@cs.tu-dortmund.de>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl warnings:
Missing blank line after Declarations

Signed-off-by: Benedict Boerger <benedict.boerger@cs.tu-dortmund.de>
---
 drivers/staging/sep/sep_crypto.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/staging/sep/sep_crypto.c b/drivers/staging/sep/sep_crypto.c
index 415f8ec..4153228 100644
--- a/drivers/staging/sep/sep_crypto.c
+++ b/drivers/staging/sep/sep_crypto.c
@@ -244,6 +244,7 @@ static void sep_copy_sg(
 	u32 count = 0;
 	struct scatterlist *sg_src_tmp = sg_src;
 	struct scatterlist *sg_dst_tmp = sg_dst;
+
 	in_offset = 0;
 	out_offset = 0;
 
@@ -1721,6 +1722,7 @@ static u32 hash_init_post_op(struct sep_device *sep)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(sep->current_hash_req);
 	struct this_task_ctx *ta_ctx = ahash_request_ctx(sep->current_hash_req);
 	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+
 	dev_dbg(&ta_ctx->sep_used->pdev->dev,
 		"hash init post op\n");
 
@@ -1756,6 +1758,7 @@ static u32 hash_update_post_op(struct sep_device *sep)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(sep->current_hash_req);
 	struct this_task_ctx *ta_ctx = ahash_request_ctx(sep->current_hash_req);
 	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
+
 	dev_dbg(&ta_ctx->sep_used->pdev->dev,
 		"hash update post op\n");
 
@@ -1828,6 +1831,7 @@ static u32 hash_final_post_op(struct sep_device *sep)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(sep->current_hash_req);
 	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
 	struct this_task_ctx *ta_ctx = ahash_request_ctx(sep->current_hash_req);
+
 	dev_dbg(&ta_ctx->sep_used->pdev->dev,
 		"hash final post op\n");
 
@@ -1876,6 +1880,7 @@ static u32 hash_digest_post_op(struct sep_device *sep)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(sep->current_hash_req);
 	struct sep_system_ctx *sctx = crypto_ahash_ctx(tfm);
 	struct this_task_ctx *ta_ctx = ahash_request_ctx(sep->current_hash_req);
+
 	dev_dbg(&ta_ctx->sep_used->pdev->dev,
 		"hash digest post op\n");
 
@@ -2696,6 +2701,7 @@ static int sep_sha1_final(struct ahash_request *req)
 	int error;
 	int error1;
 	struct this_task_ctx *ta_ctx = ahash_request_ctx(req);
+
 	pr_debug("sep - doing sha1 final\n");
 
 	ta_ctx->sep_used = sep_dev;
@@ -2727,6 +2733,7 @@ static int sep_sha1_digest(struct ahash_request *req)
 	int error;
 	int error1;
 	struct this_task_ctx *ta_ctx = ahash_request_ctx(req);
+
 	pr_debug("sep - doing sha1 digest\n");
 
 	/* Clear out task context */
@@ -2761,6 +2768,7 @@ static int sep_sha1_finup(struct ahash_request *req)
 	int error;
 	int error1;
 	struct this_task_ctx *ta_ctx = ahash_request_ctx(req);
+
 	pr_debug("sep - doing sha1 finup\n");
 
 	ta_ctx->sep_used = sep_dev;
@@ -2792,6 +2800,7 @@ static int sep_md5_init(struct ahash_request *req)
 	int error;
 	int error1;
 	struct this_task_ctx *ta_ctx = ahash_request_ctx(req);
+
 	pr_debug("sep - doing md5 init\n");
 
 	/* Clear out task context */
@@ -2826,6 +2835,7 @@ static int sep_md5_update(struct ahash_request *req)
 	int error;
 	int error1;
 	struct this_task_ctx *ta_ctx = ahash_request_ctx(req);
+
 	pr_debug("sep - doing md5 update\n");
 
 	ta_ctx->sep_used = sep_dev;
@@ -2857,6 +2867,7 @@ static int sep_md5_final(struct ahash_request *req)
 	int error;
 	int error1;
 	struct this_task_ctx *ta_ctx = ahash_request_ctx(req);
+
 	pr_debug("sep - doing md5 final\n");
 
 	ta_ctx->sep_used = sep_dev;
@@ -2955,6 +2966,7 @@ static int sep_sha224_init(struct ahash_request *req)
 	int error;
 	int error1;
 	struct this_task_ctx *ta_ctx = ahash_request_ctx(req);
+
 	pr_debug("sep - doing sha224 init\n");
 
 	/* Clear out task context */
@@ -2989,6 +3001,7 @@ static int sep_sha224_update(struct ahash_request *req)
 	int error;
 	int error1;
 	struct this_task_ctx *ta_ctx = ahash_request_ctx(req);
+
 	pr_debug("sep - doing sha224 update\n");
 
 	ta_ctx->sep_used = sep_dev;
@@ -3020,6 +3033,7 @@ static int sep_sha224_final(struct ahash_request *req)
 	int error;
 	int error1;
 	struct this_task_ctx *ta_ctx = ahash_request_ctx(req);
+
 	pr_debug("sep - doing sha224 final\n");
 
 	ta_ctx->sep_used = sep_dev;
@@ -3118,6 +3132,7 @@ static int sep_sha256_init(struct ahash_request *req)
 	int error;
 	int error1;
 	struct this_task_ctx *ta_ctx = ahash_request_ctx(req);
+
 	pr_debug("sep - doing sha256 init\n");
 
 	/* Clear out task context */
@@ -3152,6 +3167,7 @@ static int sep_sha256_update(struct ahash_request *req)
 	int error;
 	int error1;
 	struct this_task_ctx *ta_ctx = ahash_request_ctx(req);
+
 	pr_debug("sep - doing sha256 update\n");
 
 	ta_ctx->sep_used = sep_dev;
@@ -3183,6 +3199,7 @@ static int sep_sha256_final(struct ahash_request *req)
 	int error;
 	int error1;
 	struct this_task_ctx *ta_ctx = ahash_request_ctx(req);
+
 	pr_debug("sep - doing sha256 final\n");
 
 	ta_ctx->sep_used = sep_dev;
-- 
1.9.1

