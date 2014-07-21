Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbaGUKTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 06:19:18 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:48195 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaGUKTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 06:19:17 -0400
From: Riccardo Lucchese <riccardo.lucchese@gmail.com>
To: gregkh@linuxfoundation.org
Cc: dan.carpenter@oracle.com, oleg.drokin@intel.com, josh@joshtriplett.org,
        dmitry.eremin@intel.com, john.hammond@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr, joe@perches.com,
        Riccardo Lucchese <riccardo.lucchese@gmail.com>
Subject: [PATCH v3 3/3] staging: lustre: lov: Add a space before open braces '{' in lov_request.c
Date: Mon, 21 Jul 2014 12:19:05 +0200
Message-Id: <1405937945-16701-1-git-send-email-riccardo.lucchese@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405937757-16504-1-git-send-email-riccardo.lucchese@gmail.com>
References: <1405937757-16504-1-git-send-email-riccardo.lucchese@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following checkpatch.pl issue in lov_request.c:
ERROR: space required before the open brace '{'

Signed-off-by: Riccardo Lucchese <riccardo.lucchese@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
No changes in v3.

Changes in v2:
 - Changed the subject line to follow the same convention used by
   previous commits to the same file.
 - Added Acked-by - Julia.

 drivers/staging/lustre/lustre/lov/lov_request.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/lov/lov_request.c b/drivers/staging/lustre/lustre/lov/lov_request.c
index 887b4b0..e4bb02a 100644
--- a/drivers/staging/lustre/lustre/lov/lov_request.c
+++ b/drivers/staging/lustre/lustre/lov/lov_request.c
@@ -478,7 +478,7 @@ int lov_prep_match_set(struct obd_export *exp, struct obd_info *oinfo,
 		GOTO(out_set, rc = -ENOMEM);
 	lockh->cookie = set->set_lockh->llh_handle.h_cookie;
 
-	for (i = 0; i < lsm->lsm_stripe_count; i++){
+	for (i = 0; i < lsm->lsm_stripe_count; i++) {
 		struct lov_oinfo *loi;
 		struct lov_request *req;
 		obd_off start, end;
@@ -566,7 +566,7 @@ int lov_prep_cancel_set(struct obd_export *exp, struct obd_info *oinfo,
 	}
 	lockh->cookie = set->set_lockh->llh_handle.h_cookie;
 
-	for (i = 0; i < lsm->lsm_stripe_count; i++){
+	for (i = 0; i < lsm->lsm_stripe_count; i++) {
 		struct lov_request *req;
 		struct lustre_handle *lov_lockhp;
 		struct lov_oinfo *loi = lsm->lsm_oinfo[i];
@@ -734,7 +734,7 @@ int lov_prep_brw_set(struct obd_export *exp, struct obd_info *oinfo,
 
 	/* alloc and initialize lov request */
 	shift = 0;
-	for (i = 0; i < oinfo->oi_md->lsm_stripe_count; i++){
+	for (i = 0; i < oinfo->oi_md->lsm_stripe_count; i++) {
 		struct lov_oinfo *loi = NULL;
 		struct lov_request *req;
 
-- 
1.9.1

