Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbaIIOho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:37:44 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:51484 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbaIIOhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:37:12 -0400
From: Hugues Morisset <morisset.hugues@gmail.com>
X-Google-Original-From: Hugues Morisset <morisset.hugues@gamil.com>
To: oleg.drokin@intel.com, andreas.dilger@intel.com
Cc: gregkh@linuxfoundation.org, HPDD-discuss@ml01.01.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Hugues Morisset <morisset.hugues@gmail.com>
Subject: [PATCH 3/3] staging: lustre: fix coding style of function's pointer
Date: Tue,  9 Sep 2014 16:36:27 +0200
Message-Id: <1410273387-682902-4-git-send-email-morisset.hugues@gamil.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410273387-682902-1-git-send-email-morisset.hugues@gamil.com>
References: <1410273387-682902-1-git-send-email-morisset.hugues@gamil.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugues Morisset <morisset.hugues@gmail.com>

Signed-off-by: Hugues Morisset <morisset.hugues@gmail.com>
---
 drivers/staging/lustre/lustre/include/obd.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/obd.h b/drivers/staging/lustre/lustre/include/obd.h
index 7f2b8cb..318aec9 100644
--- a/drivers/staging/lustre/lustre/include/obd.h
+++ b/drivers/staging/lustre/lustre/include/obd.h
@@ -1138,7 +1138,7 @@ struct obd_ops {
 				struct ptlrpc_request_set *set);
 	int (*o_attach)(struct obd_device *dev, u32 len, void *data);
 	int (*o_detach)(struct obd_device *dev);
-	int (*o_setup) (struct obd_device *dev, struct lustre_cfg *cfg);
+	int (*o_setup)(struct obd_device *dev, struct lustre_cfg *cfg);
 	int (*o_precleanup)(struct obd_device *dev,
 			    enum obd_cleanup_stage cleanup_stage);
 	int (*o_cleanup)(struct obd_device *dev);
@@ -1228,7 +1228,7 @@ struct obd_ops {
 			enum obd_notify_event ev, void *data);
 
 	int (*o_health_check)(const struct lu_env *env, struct obd_device *);
-	struct obd_uuid *(*o_get_uuid) (struct obd_export *exp);
+	struct obd_uuid *(*o_get_uuid)(struct obd_export *exp);
 
 	/* quota methods */
 	int (*o_quotacheck)(struct obd_device *, struct obd_export *,
@@ -1398,9 +1398,9 @@ struct lsm_operations {
 				    u64 *);
 	void (*lsm_stripe_by_offset)(struct lov_stripe_md *, int *, u64 *,
 				     u64 *);
-	int (*lsm_lmm_verify) (struct lov_mds_md *lmm, int lmm_bytes,
+	int (*lsm_lmm_verify)(struct lov_mds_md *lmm, int lmm_bytes,
 			       __u16 *stripe_count);
-	int (*lsm_unpackmd) (struct lov_obd *lov, struct lov_stripe_md *lsm,
+	int (*lsm_unpackmd)(struct lov_obd *lov, struct lov_stripe_md *lsm,
 			     struct lov_mds_md *lmm);
 };
 
-- 
2.1.0

