Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271AbaFSQCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 12:02:22 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:45127 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758082AbaFSQCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 12:02:18 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: andreas.dilger@intel.com, oleg.drokin@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, hpdd-discuss@ml01.01.org,
        Anil Belur <askb23@gmail.com>
Subject: [PATCH 3/3] staging: lustre: ldlm: ldlm_lib.c removed unecessary space after function name
Date: Fri, 20 Jun 2014 02:01:48 +1000
Message-Id: <1403193708-22407-3-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1403193708-22407-1-git-send-email-askb23@gmail.com>
References: <1403193708-22407-1-git-send-email-askb23@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anil Belur <askb23@gmail.com>

- this fixes "WARNING: space prohibited between function name and open
  parenthesis '("

Signed-off-by: Anil Belur <askb23@gmail.com>
---
 drivers/staging/lustre/lustre/ldlm/ldlm_lib.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c
index 5d69af5..d8ad808 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c
@@ -510,7 +510,7 @@ int client_connect_import(const struct lu_env *env,
 
 	rc = ptlrpc_connect_import(imp);
 	if (rc != 0) {
-		LASSERT (imp->imp_state == LUSTRE_IMP_DISCON);
+		LASSERT(imp->imp_state == LUSTRE_IMP_DISCON);
 		GOTO(out_ldlm, rc);
 	}
 	LASSERT(*exp != NULL && (*exp)->exp_connection);
@@ -668,25 +668,25 @@ void target_send_reply(struct ptlrpc_request *req, int rc, int fail_id)
 	rs = req->rq_reply_state;
 	if (rs == NULL || !rs->rs_difficult) {
 		/* no notifiers */
-		target_send_reply_msg (req, rc, fail_id);
+		target_send_reply_msg(req, rc, fail_id);
 		return;
 	}
 
 	/* must be an export if locks saved */
-	LASSERT (req->rq_export != NULL);
+	LASSERT(req->rq_export != NULL);
 	/* req/reply consistent */
 	LASSERT(rs->rs_svcpt == svcpt);
 
 	/* "fresh" reply */
-	LASSERT (!rs->rs_scheduled);
-	LASSERT (!rs->rs_scheduled_ever);
-	LASSERT (!rs->rs_handled);
-	LASSERT (!rs->rs_on_net);
-	LASSERT (rs->rs_export == NULL);
-	LASSERT (list_empty(&rs->rs_obd_list));
-	LASSERT (list_empty(&rs->rs_exp_list));
-
-	exp = class_export_get (req->rq_export);
+	LASSERT(!rs->rs_scheduled);
+	LASSERT(!rs->rs_scheduled_ever);
+	LASSERT(!rs->rs_handled);
+	LASSERT(!rs->rs_on_net);
+	LASSERT(rs->rs_export == NULL);
+	LASSERT(list_empty(&rs->rs_obd_list));
+	LASSERT(list_empty(&rs->rs_exp_list));
+
+	exp = class_export_get(req->rq_export);
 
 	/* disable reply scheduling while I'm setting up */
 	rs->rs_scheduled = 1;
-- 
1.9.0

