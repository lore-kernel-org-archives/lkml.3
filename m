Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbaIHWJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 18:09:31 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:54428 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750AbaIHWJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 18:09:30 -0400
Message-ID: <540E2918.5070406@gmail.com>
Date: Tue, 09 Sep 2014 00:09:28 +0200
From: Hugues <morisset.hugues@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] staging: lustre: fix coding style issues
References: <540E27FB.2070206@gmail.com> <540E287D.5090101@gmail.com> <540E28AD.2060607@gmail.com>
In-Reply-To: <540E28AD.2060607@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------090201050605020108080302"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090201050605020108080302
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 09/09/2014 12:07 AM, Hugues wrote:
> Fix coding style issues:
> * Remove extra space in function's pointers
> 

Sorry, I forgot the attachment.

--------------090201050605020108080302
Content-Type: text/x-patch;
 name="0003-staging-lustre-fix-coding-style-issues.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0003-staging-lustre-fix-coding-style-issues.patch"

>From d4ec8f9a9452102f0b044758bf407782665baa68 Mon Sep 17 00:00:00 2001
From: Hugues Morisset <morisset.hugues@gmail.com>
Date: Mon, 8 Sep 2014 21:39:27 +0200
Subject: [PATCH 3/4] staging: lustre: fix coding style issues

Signed-off-by: Hugues Morisset <morisset.hugues@gmail.com>
---
 drivers/staging/lustre/lustre/include/obd.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/obd.h b/drivers/staging/lustre/lustre/include/obd.h
index 5f1d8c7..409eae6 100644
--- a/drivers/staging/lustre/lustre/include/obd.h
+++ b/drivers/staging/lustre/lustre/include/obd.h
@@ -1141,7 +1141,7 @@ struct obd_ops {
 				struct ptlrpc_request_set *set);
 	int (*o_attach)(struct obd_device *dev, u32 len, void *data);
 	int (*o_detach)(struct obd_device *dev);
-	int (*o_setup) (struct obd_device *dev, struct lustre_cfg *cfg);
+	int (*o_setup)(struct obd_device *dev, struct lustre_cfg *cfg);
 	int (*o_precleanup)(struct obd_device *dev,
 			    enum obd_cleanup_stage cleanup_stage);
 	int (*o_cleanup)(struct obd_device *dev);
@@ -1276,7 +1276,7 @@ struct obd_ops {
 			enum obd_notify_event ev, void *data);
 
 	int (*o_health_check)(const struct lu_env *env, struct obd_device *);
-	struct obd_uuid *(*o_get_uuid) (struct obd_export *exp);
+	struct obd_uuid *(*o_get_uuid)(struct obd_export *exp);
 
 	/* quota methods */
 	int (*o_quotacheck)(struct obd_device *, struct obd_export *,
@@ -1448,9 +1448,9 @@ struct lsm_operations {
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
 
@@ -1481,6 +1481,7 @@ static inline struct lustre_capa *oinfo_capa(struct obd_info *oinfo)
 static inline struct md_open_data *obd_mod_alloc(void)
 {
 	struct md_open_data *mod;
+
 	OBD_ALLOC_PTR(mod);
 	if (mod == NULL)
 		return NULL;
-- 
2.1.0


--------------090201050605020108080302--
