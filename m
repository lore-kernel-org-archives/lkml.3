Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756AbaGSTlv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 15:41:51 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:59989 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbaGSTlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 15:41:49 -0400
From: Riccardo Lucchese <riccardo.lucchese@gmail.com>
To: gregkh@linuxfoundation.org
Cc: oleg.drokin@intel.com, josh@joshtriplett.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Riccardo Lucchese <riccardo.lucchese@gmail.com>
Subject: [PATCH 3/3] staging: lustre/lustre/lov: Add a space before open braces '{' in lov_request.c
Date: Sat, 19 Jul 2014 21:41:41 +0200
Message-Id: <1405798901-15936-1-git-send-email-riccardo.lucchese@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405798498-15754-1-git-send-email-riccardo.lucchese@gmail.com>
References: <1405798498-15754-1-git-send-email-riccardo.lucchese@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following checkpatch.pl issue in lov_request.c:
ERROR: space required before the open brace '{'

Signed-off-by: Riccardo Lucchese <riccardo.lucchese@gmail.com>
---
 drivers/staging/lustre/lustre/lov/lov_request.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/lov/lov_request.c b/drivers/staging/lustre/lustre/lov/lov_request.c
index d9344c7..57ee94d 100644
--- a/drivers/staging/lustre/lustre/lov/lov_request.c
+++ b/drivers/staging/lustre/lustre/lov/lov_request.c
@@ -477,7 +477,7 @@ int lov_prep_match_set(struct obd_export *exp, struct obd_info *oinfo,
 		GOTO(out_set, rc = -ENOMEM);
 	lockh->cookie = set->set_lockh->llh_handle.h_cookie;
 
-	for (i = 0; i < lsm->lsm_stripe_count; i++){
+	for (i = 0; i < lsm->lsm_stripe_count; i++) {
 		struct lov_oinfo *loi;
 		struct lov_request *req;
 		obd_off start, end;
@@ -565,7 +565,7 @@ int lov_prep_cancel_set(struct obd_export *exp, struct obd_info *oinfo,
 	}
 	lockh->cookie = set->set_lockh->llh_handle.h_cookie;
 
-	for (i = 0; i < lsm->lsm_stripe_count; i++){
+	for (i = 0; i < lsm->lsm_stripe_count; i++) {
 		struct lov_request *req;
 		struct lustre_handle *lov_lockhp;
 		struct lov_oinfo *loi = lsm->lsm_oinfo[i];
@@ -733,7 +733,7 @@ int lov_prep_brw_set(struct obd_export *exp, struct obd_info *oinfo,
 
 	/* alloc and initialize lov request */
 	shift = 0;
-	for (i = 0; i < oinfo->oi_md->lsm_stripe_count; i++){
+	for (i = 0; i < oinfo->oi_md->lsm_stripe_count; i++) {
 		struct lov_oinfo *loi = NULL;
 		struct lov_request *req;
 
-- 
1.9.1

