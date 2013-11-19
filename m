Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab3KSN0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 08:26:46 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:54147 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab3KSN0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 08:26:43 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Amir Shehata <amir.shehata@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 8/9] staging/lustre/lnet: coding style fix for lstcon_test_add
Date: Tue, 19 Nov 2013 21:23:47 +0800
Message-Id: <1384867428-8395-9-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384867428-8395-1-git-send-email-bergwolf@gmail.com>
References: <1384867428-8395-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amir Shehata <amir.shehata@intel.com>

To make the function a bit easier to read.

This is coding style fix part of original Lustre commit in external tree.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3093
Lustre-change: http://review.whamcloud.com/6092
Signed-off-by: Amir Shehata <amir.shehata@intel.com>
Reviewed-by: Isaac Huang <he.huang@intel.com>
Reviewed-by: Liang Zhen <liang.zhen@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lnet/selftest/console.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/lustre/lnet/selftest/console.c b/drivers/staging/lustre/lnet/selftest/console.c
index a27dfa6..9556bc0 100644
--- a/drivers/staging/lustre/lnet/selftest/console.c
+++ b/drivers/staging/lustre/lnet/selftest/console.c
@@ -1320,18 +1320,18 @@ lstcon_test_add(char *batch_name, int type, int loop,
 	}
 
 	memset(test, 0, offsetof(lstcon_test_t, tes_param[paramlen]));
-	test->tes_hdr.tsb_id    = batch->bat_hdr.tsb_id;
-	test->tes_batch	 = batch;
-	test->tes_type	  = type;
-	test->tes_oneside       = 0; /* TODO */
-	test->tes_loop	  = loop;
+	test->tes_hdr.tsb_id	= batch->bat_hdr.tsb_id;
+	test->tes_batch		= batch;
+	test->tes_type		= type;
+	test->tes_oneside	= 0; /* TODO */
+	test->tes_loop		= loop;
 	test->tes_concur	= concur;
-	test->tes_stop_onerr    = 1; /* TODO */
-	test->tes_span	  = span;
-	test->tes_dist	  = dist;
+	test->tes_stop_onerr	= 1; /* TODO */
+	test->tes_span		= span;
+	test->tes_dist		= dist;
 	test->tes_cliidx	= 0; /* just used for creating RPC */
-	test->tes_src_grp       = src_grp;
-	test->tes_dst_grp       = dst_grp;
+	test->tes_src_grp	= src_grp;
+	test->tes_dst_grp	= dst_grp;
 	INIT_LIST_HEAD(&test->tes_trans_list);
 
 	if (param != NULL) {
-- 
1.7.9.5

