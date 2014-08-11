Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbaHKSa0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 14:30:26 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:38771 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602AbaHKS3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 14:29:03 -0400
From: Srikrishan Malik <srikrishanmalik@gmail.com>
To: greg@kroah.com, andreas.dilger@intel.com, oleg.drokin@intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Srikrishan Malik <srikrishanmalik@gmail.com>
Subject: [PATCH v2 09/13] staging: lustre: Added space between type name and *
Date: Mon, 11 Aug 2014 23:57:35 +0530
Message-Id: <1407781659-728-9-git-send-email-srikrishanmalik@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407781659-728-1-git-send-email-srikrishanmalik@gmail.com>
References: <1407781659-728-1-git-send-email-srikrishanmalik@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following checkpatch error:

ERROR: "(foo*)" should be "(foo *)"

Signed-off-by: Srikrishan Malik <srikrishanmalik@gmail.com>
---
 drivers/staging/lustre/lustre/mdc/mdc_locks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/mdc/mdc_locks.c b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
index 7f724e3c3f06..c03d77c9c5b8 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_locks.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
@@ -218,7 +218,7 @@ int mdc_find_cbdata(struct obd_export *exp,
 	struct ldlm_res_id res_id;
 	int rc = 0;
 
-	fid_build_reg_res_name((struct lu_fid*)fid, &res_id);
+	fid_build_reg_res_name((struct lu_fid *)fid, &res_id);
 	rc = ldlm_resource_iterate(class_exp2obd(exp)->obd_namespace, &res_id,
 				   it, data);
 	if (rc == LDLM_ITER_STOP)
-- 
1.9.3

