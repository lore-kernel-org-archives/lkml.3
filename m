Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbaIDFoF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 01:44:05 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:35407 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaIDFoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 01:44:03 -0400
From: Juston Li <juston.h.li@gmail.com>
To: oleg.drokin@intel.com
Cc: andreas.dilger@intel.com, gregkh@linuxfoundation.org,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Juston Li <juston.h.li@gmail.com>
Subject: [PATCH] staging: lustre: lmv: lmv_internal.h: fix checkpatch.pl spacing errors
Date: Wed,  3 Sep 2014 22:42:24 -0700
Message-Id: <1409809344-13610-1-git-send-email-juston.h.li@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lmv_internal.h:96: ERROR: space prohibited after that open parenthesis '('
lmv_internal.h:96: ERROR: space required before the open parenthesis '('
lmv_internal.h:147: WARNING: space prohibited between function name and open parenthesis '('

Signed-off-by: Juston Li <juston.h.li@gmail.com>
---
 drivers/staging/lustre/lustre/lmv/lmv_internal.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/lmv/lmv_internal.h b/drivers/staging/lustre/lustre/lmv/lmv_internal.h
index 80e6604..b911e76 100644
--- a/drivers/staging/lustre/lustre/lmv/lmv_internal.h
+++ b/drivers/staging/lustre/lustre/lmv/lmv_internal.h
@@ -93,7 +93,7 @@ static inline struct lmv_stripe_md *lmv_get_mea(struct ptlrpc_request *req)
 
 	if (mea->mea_count == 0)
 		return NULL;
-	if( mea->mea_magic != MEA_MAGIC_LAST_CHAR &&
+	if (mea->mea_magic != MEA_MAGIC_LAST_CHAR &&
 		mea->mea_magic != MEA_MAGIC_ALL_CHARS &&
 		mea->mea_magic != MEA_MAGIC_HASH_SEGMENT)
 		return NULL;
@@ -144,7 +144,7 @@ struct lmv_tgt_desc
 *lmv_locate_mds(struct lmv_obd *lmv, struct md_op_data *op_data,
 		struct lu_fid *fid);
 /* lproc_lmv.c */
-#if defined (CONFIG_PROC_FS)
+#if defined(CONFIG_PROC_FS)
 void lprocfs_lmv_init_vars(struct lprocfs_static_vars *lvars);
 #else
 static inline void lprocfs_lmv_init_vars(struct lprocfs_static_vars *lvars)
-- 
2.1.0

