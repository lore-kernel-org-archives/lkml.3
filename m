Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbaHKS2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 14:28:36 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:41744 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282AbaHKS2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 14:28:34 -0400
From: Srikrishan Malik <srikrishanmalik@gmail.com>
To: greg@kroah.com, andreas.dilger@intel.com, oleg.drokin@intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Srikrishan Malik <srikrishanmalik@gmail.com>
Subject: [PATCH v2 03/13] staging: lustre: move open brace to next line after functions
Date: Mon, 11 Aug 2014 23:57:29 +0530
Message-Id: <1407781659-728-3-git-send-email-srikrishanmalik@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407781659-728-1-git-send-email-srikrishanmalik@gmail.com>
References: <1407781659-728-1-git-send-email-srikrishanmalik@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following checkpatch error:

ERROR: open brace '{' following function declarations go on the next line

Signed-off-by: Srikrishan Malik <srikrishanmalik@gmail.com>
---
 drivers/staging/lustre/lustre/mdc/mdc_lib.c     | 3 ++-
 drivers/staging/lustre/lustre/mdc/mdc_request.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/mdc/mdc_lib.c b/drivers/staging/lustre/lustre/mdc/mdc_lib.c
index 60217ba440aa..daaa7422c03f 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_lib.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_lib.c
@@ -256,7 +256,8 @@ void mdc_open_pack(struct ptlrpc_request *req, struct md_op_data *op_data,
 	set_mrc_cr_flags(rec, cr_flags);
 }
 
-static inline __u64 attr_pack(unsigned int ia_valid) {
+static inline __u64 attr_pack(unsigned int ia_valid)
+{
 	__u64 sa_valid = 0;
 
 	if (ia_valid & ATTR_MODE)
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
index 0b517e550477..0bcf624620ce 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -2384,7 +2384,8 @@ int mdc_fid_alloc(struct obd_export *exp, struct lu_fid *fid,
 	return seq_client_alloc_fid(NULL, seq, fid);
 }
 
-struct obd_uuid *mdc_get_uuid(struct obd_export *exp) {
+struct obd_uuid *mdc_get_uuid(struct obd_export *exp)
+{
 	struct client_obd *cli = &exp->exp_obd->u.cli;
 	return &cli->cl_target_uuid;
 }
-- 
1.9.3

