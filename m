Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbaJ2TmH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 15:42:07 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:53635 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250AbaJ2TmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 15:42:02 -0400
From: Anton Saraev <antonysaraev@gmail.com>
To: gregkh@linuxfoundation.org
Cc: antonysaraev@gmail.com, oleg.drokin@intel.com, andreas.dilger@intel.com,
        heenasirwani@gmail.com, bergwolf@gmail.com, amir.shehata@intel.com,
        gdonald@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 02/02] staging:lustre:lnet:selftest: remove unused function
Date: Wed, 29 Oct 2014 23:41:50 +0400
Message-Id: <aa87ee68015e44e7d2e3a3c0d21623b4f08263b8.1414609881.git.antonysaraev@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <cover.1414609881.git.antonysaraev@gmail.com>
References: <cover.1414609881.git.antonysaraev@gmail.com>
In-Reply-To: <cover.1414609881.git.antonysaraev@gmail.com>
References: <cover.1414609881.git.antonysaraev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function lnet_selftest_structure_assertion is never used and can
be removed.

Signed-off-by: Anton Saraev <antonysaraev@gmail.com>
---
 drivers/staging/lustre/lnet/selftest/module.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/staging/lustre/lnet/selftest/module.c b/drivers/staging/lustre/lnet/selftest/module.c
index b2dd891..92520c2 100644
--- a/drivers/staging/lustre/lnet/selftest/module.c
+++ b/drivers/staging/lustre/lnet/selftest/module.c
@@ -90,17 +90,6 @@ lnet_selftest_fini(void)
 	return;
 }
 
-void
-lnet_selftest_structure_assertion(void)
-{
-	CLASSERT(sizeof(srpc_msg_t) == 160);
-	CLASSERT(sizeof(srpc_test_reqst_t) == 70);
-	CLASSERT(offsetof(srpc_msg_t, msg_body.tes_reqst.tsr_concur) == 72);
-	CLASSERT(offsetof(srpc_msg_t, msg_body.tes_reqst.tsr_ndest) == 78);
-	CLASSERT(sizeof(srpc_stat_reply_t) == 136);
-	CLASSERT(sizeof(srpc_stat_reqst_t) == 28);
-}
-
 static int
 lnet_selftest_init(void)
 {
-- 
1.9.1

