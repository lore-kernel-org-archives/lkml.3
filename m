Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797AbaHFRQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 13:16:43 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:62109 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932905AbaHFROM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 13:14:12 -0400
From: Srikrishan Malik <srikrishanmalik@gmail.com>
To: greg@kroah.com, andreas.dilger@intel.com, oleg.drokin@intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Srikrishan Malik <srikrishanmalik@gmail.com>
Subject: [PATCH 06/12] staging: lustre: replace c99 style comments with C89
Date: Wed,  6 Aug 2014 22:42:56 +0530
Message-Id: <1407345182-709-6-git-send-email-srikrishanmalik@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407345182-709-1-git-send-email-srikrishanmalik@gmail.com>
References: <1407345182-709-1-git-send-email-srikrishanmalik@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following checkpatch error:

ERROR: do not use C99 // comments

Signed-off-by: Srikrishan Malik <srikrishanmalik@gmail.com>
---
 drivers/staging/lustre/lustre/mdc/mdc_lib.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/mdc/mdc_lib.c b/drivers/staging/lustre/lustre/mdc/mdc_lib.c
index 35ce2fdf696c..7f9b6eb51860 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_lib.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_lib.c
@@ -416,9 +416,9 @@ void mdc_link_pack(struct ptlrpc_request *req, struct md_op_data *op_data)
 	LASSERT(rec != NULL);
 
 	rec->lk_opcode   = REINT_LINK;
-	rec->lk_fsuid    = op_data->op_fsuid;//current->fsuid;
-	rec->lk_fsgid    = op_data->op_fsgid;//current->fsgid;
-	rec->lk_cap      = op_data->op_cap;//current->cap_effective;
+	rec->lk_fsuid    = op_data->op_fsuid; /* current->fsuid; */
+	rec->lk_fsgid    = op_data->op_fsgid; /*current->fsgid; */
+	rec->lk_cap      = op_data->op_cap;   /*current->cap_effective; */
 	rec->lk_suppgid1 = op_data->op_suppgids[0];
 	rec->lk_suppgid2 = op_data->op_suppgids[1];
 	rec->lk_fid1     = op_data->op_fid1;
-- 
1.9.3

