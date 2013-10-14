Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab3JNDWL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 23:22:11 -0400
Received: from smtprelay0048.hostedemail.com ([216.40.44.48]:35178 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755715Ab3JNDWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 23:22:08 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:327:355:379:541:617:960:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:2005:2195:2196:2198:2199:2200:2201:2393:2559:2562:2693:2828:2900:2907:2910:3138:3139:3140:3141:3142:3865:3867:3868:3870:3871:3872:3874:4321:4385:4605:5007:7652:7808:7862:7875:7903:8603:9010:10004:10028:10848:11026:11232:11657:11914:12043:12296:12438:12517:12519:12555:12679,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fear00_869e85c715011
X-Filterd-Recvd-Size: 37591
Message-ID: <1381720923.25528.8.camel@joe-AO722>
Subject: [PATCH staging-next] staging: lustre: Use parenthesis around sizeof
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel <devel@driverdev.osuosl.org>, LKML <linux-kernel@vger.kernel.org>,
        Andreas Dilger <andreas.dilger@intel.com>, Peng Tao <tao.peng@emc.com>,
        hpdd-discuss@ml01.01.org
Date: Sun, 13 Oct 2013 20:22:03 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert sizeof foo to sizeof(foo) to be more kernel style compatible.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/lustre/lustre/fld/fld_cache.c      |  2 +-
 drivers/staging/lustre/lustre/include/cl_object.h  | 12 +++----
 drivers/staging/lustre/lustre/include/lclient.h    |  4 +--
 .../lustre/lustre/include/lustre/lustre_idl.h      | 42 +++++++++++++---------
 drivers/staging/lustre/lustre/include/lustre_fid.h |  2 +-
 drivers/staging/lustre/lustre/include/obd.h        |  2 +-
 .../staging/lustre/lustre/include/obd_support.h    | 18 +++++-----
 drivers/staging/lustre/lustre/lclient/lcommon_cl.c |  2 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c     |  2 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_resource.c |  6 ++--
 .../lustre/lustre/libcfs/linux/linux-debug.c       |  2 +-
 drivers/staging/lustre/lustre/llite/file.c         |  4 +--
 drivers/staging/lustre/lustre/llite/llite_lib.c    |  4 +--
 drivers/staging/lustre/lustre/llite/rw.c           |  2 +-
 drivers/staging/lustre/lustre/lov/lov_dev.c        |  8 ++---
 drivers/staging/lustre/lustre/lov/lov_internal.h   |  2 +-
 drivers/staging/lustre/lustre/lov/lov_io.c         |  4 +--
 drivers/staging/lustre/lustre/lov/lov_lock.c       |  4 +--
 drivers/staging/lustre/lustre/lov/lov_object.c     |  4 +--
 drivers/staging/lustre/lustre/lov/lov_pack.c       |  2 +-
 drivers/staging/lustre/lustre/lov/lov_request.c    |  4 +--
 drivers/staging/lustre/lustre/obdclass/cl_io.c     |  6 ++--
 drivers/staging/lustre/lustre/obdclass/class_obd.c |  2 +-
 drivers/staging/lustre/lustre/obdclass/llog_test.c |  6 ++--
 drivers/staging/lustre/lustre/obdclass/lu_object.c | 13 +++----
 .../staging/lustre/lustre/obdclass/obd_config.c    |  6 ++--
 drivers/staging/lustre/lustre/obdclass/uuid.c      |  4 +--
 .../staging/lustre/lustre/obdecho/echo_client.c    |  2 +-
 drivers/staging/lustre/lustre/osc/osc_lock.c       |  2 +-
 drivers/staging/lustre/lustre/osc/osc_page.c       |  2 +-
 drivers/staging/lustre/lustre/osc/osc_request.c    |  2 +-
 drivers/staging/lustre/lustre/ptlrpc/client.c      |  4 +--
 drivers/staging/lustre/lustre/ptlrpc/import.c      |  2 +-
 drivers/staging/lustre/lustre/ptlrpc/layout.c      |  2 +-
 drivers/staging/lustre/lustre/ptlrpc/service.c     |  8 ++---
 35 files changed, 101 insertions(+), 92 deletions(-)

diff --git a/drivers/staging/lustre/lustre/fld/fld_cache.c b/drivers/staging/lustre/lustre/fld/fld_cache.c
index 25099cb..4531510 100644
--- a/drivers/staging/lustre/lustre/fld/fld_cache.c
+++ b/drivers/staging/lustre/lustre/fld/fld_cache.c
@@ -267,7 +267,7 @@ void fld_cache_punch_hole(struct fld_cache *cache,
 	const seqno_t new_end  = range->lsr_end;
 	struct fld_cache_entry *fldt;
 
-	OBD_ALLOC_GFP(fldt, sizeof *fldt, GFP_ATOMIC);
+	OBD_ALLOC_GFP(fldt, sizeof(*fldt), GFP_ATOMIC);
 	if (!fldt) {
 		OBD_FREE_PTR(f_new);
 		/* overlap is not allowed, so dont mess up list. */
diff --git a/drivers/staging/lustre/lustre/include/cl_object.h b/drivers/staging/lustre/lustre/include/cl_object.h
index edb40af..c485206 100644
--- a/drivers/staging/lustre/lustre/include/cl_object.h
+++ b/drivers/staging/lustre/lustre/include/cl_object.h
@@ -3096,13 +3096,13 @@ struct cl_io *cl_io_top(struct cl_io *io);
 void cl_io_print(const struct lu_env *env, void *cookie,
 		 lu_printer_t printer, const struct cl_io *io);
 
-#define CL_IO_SLICE_CLEAN(foo_io, base)				 \
-do {								    \
-	typeof(foo_io) __foo_io = (foo_io);			     \
+#define CL_IO_SLICE_CLEAN(foo_io, base)					\
+do {									\
+	typeof(foo_io) __foo_io = (foo_io);				\
 									\
-	CLASSERT(offsetof(typeof(*__foo_io), base) == 0);	       \
-	memset(&__foo_io->base + 1, 0,				  \
-	       (sizeof *__foo_io) - sizeof __foo_io->base);	     \
+	CLASSERT(offsetof(typeof(*__foo_io), base) == 0);		\
+	memset(&__foo_io->base + 1, 0,					\
+	       sizeof(*__foo_io) - sizeof(__foo_io->base));		\
 } while (0)
 
 /** @} cl_io */
diff --git a/drivers/staging/lustre/lustre/include/lclient.h b/drivers/staging/lustre/lustre/include/lclient.h
index 9d4011f..27316f7 100644
--- a/drivers/staging/lustre/lustre/include/lclient.h
+++ b/drivers/staging/lustre/lustre/include/lclient.h
@@ -388,8 +388,8 @@ __u16 ll_dirent_type_get(struct lu_dirent *ent);
 __u64 cl_fid_build_ino(const struct lu_fid *fid, int api32);
 __u32 cl_fid_build_gen(const struct lu_fid *fid);
 
-# define CLOBINVRNT(env, clob, expr)				    \
-	((void)sizeof(env), (void)sizeof(clob), (void)sizeof !!(expr))
+# define CLOBINVRNT(env, clob, expr)					\
+	((void)sizeof(env), (void)sizeof(clob), (void)sizeof(!!(expr)))
 
 int cl_init_ea_size(struct obd_export *md_exp, struct obd_export *dt_exp);
 int cl_ocd_update(struct obd_device *host,
diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
index 984235c..5ca18d0 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
@@ -831,9 +831,10 @@ static inline void lu_igif_build(struct lu_fid *fid, __u32 ino, __u32 gen)
 static inline void fid_cpu_to_le(struct lu_fid *dst, const struct lu_fid *src)
 {
 	/* check that all fields are converted */
-	CLASSERT(sizeof *src ==
-		 sizeof fid_seq(src) +
-		 sizeof fid_oid(src) + sizeof fid_ver(src));
+	CLASSERT(sizeof(*src) ==
+		 sizeof(fid_seq(src)) +
+		 sizeof(fid_oid(src)) +
+		 sizeof(fid_ver(src)));
 	dst->f_seq = cpu_to_le64(fid_seq(src));
 	dst->f_oid = cpu_to_le32(fid_oid(src));
 	dst->f_ver = cpu_to_le32(fid_ver(src));
@@ -842,9 +843,10 @@ static inline void fid_cpu_to_le(struct lu_fid *dst, const struct lu_fid *src)
 static inline void fid_le_to_cpu(struct lu_fid *dst, const struct lu_fid *src)
 {
 	/* check that all fields are converted */
-	CLASSERT(sizeof *src ==
-		 sizeof fid_seq(src) +
-		 sizeof fid_oid(src) + sizeof fid_ver(src));
+	CLASSERT(sizeof(*src) ==
+		 sizeof(fid_seq(src)) +
+		 sizeof(fid_oid(src)) +
+		 sizeof(fid_ver(src)));
 	dst->f_seq = le64_to_cpu(fid_seq(src));
 	dst->f_oid = le32_to_cpu(fid_oid(src));
 	dst->f_ver = le32_to_cpu(fid_ver(src));
@@ -853,9 +855,10 @@ static inline void fid_le_to_cpu(struct lu_fid *dst, const struct lu_fid *src)
 static inline void fid_cpu_to_be(struct lu_fid *dst, const struct lu_fid *src)
 {
 	/* check that all fields are converted */
-	CLASSERT(sizeof *src ==
-		 sizeof fid_seq(src) +
-		 sizeof fid_oid(src) + sizeof fid_ver(src));
+	CLASSERT(sizeof(*src) ==
+		 sizeof(fid_seq(src)) +
+		 sizeof(fid_oid(src)) +
+		 sizeof(fid_ver(src)));
 	dst->f_seq = cpu_to_be64(fid_seq(src));
 	dst->f_oid = cpu_to_be32(fid_oid(src));
 	dst->f_ver = cpu_to_be32(fid_ver(src));
@@ -864,9 +867,10 @@ static inline void fid_cpu_to_be(struct lu_fid *dst, const struct lu_fid *src)
 static inline void fid_be_to_cpu(struct lu_fid *dst, const struct lu_fid *src)
 {
 	/* check that all fields are converted */
-	CLASSERT(sizeof *src ==
-		 sizeof fid_seq(src) +
-		 sizeof fid_oid(src) + sizeof fid_ver(src));
+	CLASSERT(sizeof(*src) ==
+		 sizeof(fid_seq(src)) +
+		 sizeof(fid_oid(src)) +
+		 sizeof(fid_ver(src)));
 	dst->f_seq = be64_to_cpu(fid_seq(src));
 	dst->f_oid = be32_to_cpu(fid_oid(src));
 	dst->f_ver = be32_to_cpu(fid_ver(src));
@@ -891,9 +895,11 @@ extern void lustre_swab_lu_seq_range(struct lu_seq_range *range);
 static inline int lu_fid_eq(const struct lu_fid *f0, const struct lu_fid *f1)
 {
 	/* Check that there is no alignment padding. */
-	CLASSERT(sizeof *f0 ==
-		 sizeof f0->f_seq + sizeof f0->f_oid + sizeof f0->f_ver);
-	return memcmp(f0, f1, sizeof *f0) == 0;
+	CLASSERT(sizeof(*f0) ==
+		 sizeof(f0->f_seq) +
+		 sizeof(f0->f_oid) +
+		 sizeof(f0->f_ver));
+	return memcmp(f0, f1, sizeof(*f0)) == 0;
 }
 
 #define __diff_normalize(val0, val1)			    \
@@ -1638,8 +1644,10 @@ static inline void lmm_oi_cpu_to_le(struct ost_id *dst_oi,
 
 /* extern void lustre_swab_lov_mds_md(struct lov_mds_md *llm); */
 
-#define MAX_MD_SIZE (sizeof(struct lov_mds_md) + 4 * sizeof(struct lov_ost_data))
-#define MIN_MD_SIZE (sizeof(struct lov_mds_md) + 1 * sizeof(struct lov_ost_data))
+#define MAX_MD_SIZE							\
+	(sizeof(struct lov_mds_md) + 4 * sizeof(struct lov_ost_data))
+#define MIN_MD_SIZE							\
+	(sizeof(struct lov_mds_md) + 1 * sizeof(struct lov_ost_data))
 
 #define XATTR_NAME_ACL_ACCESS   "system.posix_acl_access"
 #define XATTR_NAME_ACL_DEFAULT  "system.posix_acl_default"
diff --git a/drivers/staging/lustre/lustre/include/lustre_fid.h b/drivers/staging/lustre/lustre/include/lustre_fid.h
index d9d5814..ff11953 100644
--- a/drivers/staging/lustre/lustre/include/lustre_fid.h
+++ b/drivers/staging/lustre/lustre/include/lustre_fid.h
@@ -590,7 +590,7 @@ fid_build_pdo_res_name(const struct lu_fid *fid, unsigned int hash,
 static inline void ostid_build_res_name(struct ost_id *oi,
 					struct ldlm_res_id *name)
 {
-	memset(name, 0, sizeof *name);
+	memset(name, 0, sizeof(*name));
 	if (fid_seq_is_mdt0(ostid_seq(oi))) {
 		name->name[LUSTRE_RES_ID_SEQ_OFF] = ostid_id(oi);
 		name->name[LUSTRE_RES_ID_VER_OID_OFF] = ostid_seq(oi);
diff --git a/drivers/staging/lustre/lustre/include/obd.h b/drivers/staging/lustre/lustre/include/obd.h
index a612255..4fd4af9 100644
--- a/drivers/staging/lustre/lustre/include/obd.h
+++ b/drivers/staging/lustre/lustre/include/obd.h
@@ -177,7 +177,7 @@ static inline int lov_stripe_md_cmp(struct lov_stripe_md *m1,
 	 * ->lsm_wire contains padding, but it should be zeroed out during
 	 * allocation.
 	 */
-	return memcmp(&m1->lsm_wire, &m2->lsm_wire, sizeof m1->lsm_wire);
+	return memcmp(&m1->lsm_wire, &m2->lsm_wire, sizeof(m1->lsm_wire));
 }
 
 static inline int lov_lum_lsm_cmp(struct lov_user_md *lum,
diff --git a/drivers/staging/lustre/lustre/include/obd_support.h b/drivers/staging/lustre/lustre/include/obd_support.h
index 03e6133..9697e7f 100644
--- a/drivers/staging/lustre/lustre/include/obd_support.h
+++ b/drivers/staging/lustre/lustre/include/obd_support.h
@@ -633,8 +633,8 @@ do {									      \
 
 #define OBD_ALLOC(ptr, size) OBD_ALLOC_GFP(ptr, size, __GFP_IO)
 #define OBD_ALLOC_WAIT(ptr, size) OBD_ALLOC_GFP(ptr, size, GFP_IOFS)
-#define OBD_ALLOC_PTR(ptr) OBD_ALLOC(ptr, sizeof *(ptr))
-#define OBD_ALLOC_PTR_WAIT(ptr) OBD_ALLOC_WAIT(ptr, sizeof *(ptr))
+#define OBD_ALLOC_PTR(ptr) OBD_ALLOC(ptr, sizeof(*(ptr)))
+#define OBD_ALLOC_PTR_WAIT(ptr) OBD_ALLOC_WAIT(ptr, sizeof(*(ptr)))
 
 #define OBD_CPT_ALLOC_GFP(ptr, cptab, cpt, size, gfp_mask)		      \
 	__OBD_MALLOC_VERBOSE(ptr, cptab, cpt, size, gfp_mask)
@@ -643,7 +643,7 @@ do {									      \
 	OBD_CPT_ALLOC_GFP(ptr, cptab, cpt, size, __GFP_IO)
 
 #define OBD_CPT_ALLOC_PTR(ptr, cptab, cpt)				      \
-	OBD_CPT_ALLOC(ptr, cptab, cpt, sizeof *(ptr))
+	OBD_CPT_ALLOC(ptr, cptab, cpt, sizeof(*(ptr)))
 
 # define __OBD_VMALLOC_VEROBSE(ptr, cptab, cpt, size)			      \
 do {									      \
@@ -773,7 +773,7 @@ do {									      \
 #define OBD_SLAB_CPT_ALLOC_GFP(ptr, slab, cptab, cpt, size, flags)	      \
 	__OBD_SLAB_ALLOC_VERBOSE(ptr, slab, cptab, cpt, size, flags)
 
-#define OBD_FREE_PTR(ptr) OBD_FREE(ptr, sizeof *(ptr))
+#define OBD_FREE_PTR(ptr) OBD_FREE(ptr, sizeof(*(ptr)))
 
 #define OBD_SLAB_FREE(ptr, slab, size)					\
 do {									  \
@@ -789,19 +789,19 @@ do {									  \
 	OBD_SLAB_CPT_ALLOC_GFP(ptr, slab, cptab, cpt, size, __GFP_IO)
 
 #define OBD_SLAB_ALLOC_PTR(ptr, slab)					      \
-	OBD_SLAB_ALLOC(ptr, slab, sizeof *(ptr))
+	OBD_SLAB_ALLOC(ptr, slab, sizeof(*(ptr)))
 
 #define OBD_SLAB_CPT_ALLOC_PTR(ptr, slab, cptab, cpt)			      \
-	OBD_SLAB_CPT_ALLOC(ptr, slab, cptab, cpt, sizeof *(ptr))
+	OBD_SLAB_CPT_ALLOC(ptr, slab, cptab, cpt, sizeof(*(ptr)))
 
 #define OBD_SLAB_ALLOC_PTR_GFP(ptr, slab, flags)			      \
-	OBD_SLAB_ALLOC_GFP(ptr, slab, sizeof *(ptr), flags)
+	OBD_SLAB_ALLOC_GFP(ptr, slab, sizeof(*(ptr)), flags)
 
 #define OBD_SLAB_CPT_ALLOC_PTR_GFP(ptr, slab, cptab, cpt, flags)		      \
-	OBD_SLAB_CPT_ALLOC_GFP(ptr, slab, cptab, cpt, sizeof *(ptr), flags)
+	OBD_SLAB_CPT_ALLOC_GFP(ptr, slab, cptab, cpt, sizeof(*(ptr)), flags)
 
 #define OBD_SLAB_FREE_PTR(ptr, slab)					      \
-	OBD_SLAB_FREE((ptr), (slab), sizeof *(ptr))
+	OBD_SLAB_FREE((ptr), (slab), sizeof(*(ptr)))
 
 #define KEY_IS(str) \
 	(keylen >= (sizeof(str)-1) && memcmp(key, str, (sizeof(str)-1)) == 0)
diff --git a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
index 8ff38c6..e60c04d 100644
--- a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
+++ b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
@@ -701,7 +701,7 @@ int ccc_io_one_lock_index(const struct lu_env *env, struct cl_io *io,
 
 	CDEBUG(D_VFSTRACE, "lock: %d [%lu, %lu]\n", mode, start, end);
 
-	memset(&cio->cui_link, 0, sizeof cio->cui_link);
+	memset(&cio->cui_link, 0, sizeof(cio->cui_link));
 
 	if (cio->cui_fd && (cio->cui_fd->fd_flags & LL_FILE_GROUP_LOCKED)) {
 		descr->cld_mode = CLM_GROUP;
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
index 6133b3f..027617f 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
@@ -529,7 +529,7 @@ int ldlm_lock_change_resource(struct ldlm_namespace *ns, struct ldlm_lock *lock,
 		lock_res_nested(oldres, LRT_NEW);
 	}
 	LASSERT(memcmp(new_resid, &oldres->lr_name,
-		       sizeof oldres->lr_name) != 0);
+		       sizeof(oldres->lr_name)) != 0);
 	lock->l_resource = newres;
 	unlock_res(oldres);
 	unlock_res_and_lock(lock);
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c b/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
index 208751a..8d3dd6d 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
@@ -1115,7 +1115,7 @@ ldlm_resource_get(struct ldlm_namespace *ns, struct ldlm_resource *parent,
 		lu_ref_fini(&res->lr_reference);
 		/* We have taken lr_lvb_mutex. Drop it. */
 		mutex_unlock(&res->lr_lvb_mutex);
-		OBD_SLAB_FREE(res, ldlm_resource_slab, sizeof *res);
+		OBD_SLAB_FREE(res, ldlm_resource_slab, sizeof(*res));
 
 		res = hlist_entry(hnode, struct ldlm_resource, lr_hash);
 		/* Synchronize with regard to resource creation. */
@@ -1226,7 +1226,7 @@ int ldlm_resource_putref(struct ldlm_resource *res)
 		cfs_hash_bd_unlock(ns->ns_rs_hash, &bd, 1);
 		if (ns->ns_lvbo && ns->ns_lvbo->lvbo_free)
 			ns->ns_lvbo->lvbo_free(res);
-		OBD_SLAB_FREE(res, ldlm_resource_slab, sizeof *res);
+		OBD_SLAB_FREE(res, ldlm_resource_slab, sizeof(*res));
 		return 1;
 	}
 	return 0;
@@ -1256,7 +1256,7 @@ int ldlm_resource_putref_locked(struct ldlm_resource *res)
 		 */
 		if (ns->ns_lvbo && ns->ns_lvbo->lvbo_free)
 			ns->ns_lvbo->lvbo_free(res);
-		OBD_SLAB_FREE(res, ldlm_resource_slab, sizeof *res);
+		OBD_SLAB_FREE(res, ldlm_resource_slab, sizeof(*res));
 
 		cfs_hash_bd_lock(ns->ns_rs_hash, &bd, 1);
 		return 1;
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c
index ab1e731..cc565b1 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c
@@ -137,7 +137,7 @@ void libcfs_run_lbug_upcall(struct libcfs_debug_msg_data *msgdata)
 	char *argv[6];
 	char buf[32];
 
-	snprintf (buf, sizeof buf, "%d", msgdata->msg_line);
+	snprintf(buf, sizeof(buf), "%d", msgdata->msg_line);
 
 	argv[1] = "LBUG";
 	argv[2] = (char *)msgdata->msg_file;
diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 8c4b4fa..fb85a58 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -3011,7 +3011,7 @@ static int ll_layout_lock_set(struct lustre_handle *lockh, ldlm_mode_t mode,
 
 	/* set layout to file. Unlikely this will fail as old layout was
 	 * surely eliminated */
-	memset(&conf, 0, sizeof conf);
+	memset(&conf, 0, sizeof(conf));
 	conf.coc_opc = OBJECT_CONF_SET;
 	conf.coc_inode = inode;
 	conf.coc_lock = lock;
@@ -3034,7 +3034,7 @@ out:
 			ll_get_fsname(inode->i_sb, NULL, 0),
 			inode, PFID(&lli->lli_fid));
 
-		memset(&conf, 0, sizeof conf);
+		memset(&conf, 0, sizeof(conf));
 		conf.coc_opc = OBJECT_CONF_WAIT;
 		conf.coc_inode = inode;
 		rc = ll_layout_conf(inode, &conf);
diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index b868c2b..fd584ff 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -1973,10 +1973,10 @@ void ll_umount_begin(struct super_block *sb)
 	OBD_ALLOC_PTR(ioc_data);
 	if (ioc_data) {
 		obd_iocontrol(IOC_OSC_SET_ACTIVE, sbi->ll_md_exp,
-			      sizeof *ioc_data, ioc_data, NULL);
+			      sizeof(*ioc_data), ioc_data, NULL);
 
 		obd_iocontrol(IOC_OSC_SET_ACTIVE, sbi->ll_dt_exp,
-			      sizeof *ioc_data, ioc_data, NULL);
+			      sizeof(*ioc_data), ioc_data, NULL);
 
 		OBD_FREE_PTR(ioc_data);
 	}
diff --git a/drivers/staging/lustre/lustre/llite/rw.c b/drivers/staging/lustre/lustre/llite/rw.c
index ae0dc44..e9ba38a 100644
--- a/drivers/staging/lustre/lustre/llite/rw.c
+++ b/drivers/staging/lustre/lustre/llite/rw.c
@@ -717,7 +717,7 @@ int ll_readahead(const struct lu_env *env, struct cl_io *io,
 	lli = ll_i2info(inode);
 	clob = lli->lli_clob;
 
-	memset(ria, 0, sizeof *ria);
+	memset(ria, 0, sizeof(*ria));
 
 	cl_object_attr_lock(clob);
 	ret = cl_object_attr_get(env, clob, attr);
diff --git a/drivers/staging/lustre/lustre/lov/lov_dev.c b/drivers/staging/lustre/lustre/lov/lov_dev.c
index a4006ef..099cebb 100644
--- a/drivers/staging/lustre/lustre/lov/lov_dev.c
+++ b/drivers/staging/lustre/lustre/lov/lov_dev.c
@@ -286,7 +286,7 @@ static void lov_emerg_free(struct lov_device_emerg **emrg, int nr)
 			OBD_FREE_PTR(em);
 		}
 	}
-	OBD_FREE(emrg, nr * sizeof emrg[0]);
+	OBD_FREE(emrg, nr * sizeof(emrg[0]));
 }
 
 static struct lu_device *lov_device_free(const struct lu_env *env,
@@ -297,7 +297,7 @@ static struct lu_device *lov_device_free(const struct lu_env *env,
 
 	cl_device_fini(lu2cl_dev(d));
 	if (ld->ld_target != NULL)
-		OBD_FREE(ld->ld_target, nr * sizeof ld->ld_target[0]);
+		OBD_FREE(ld->ld_target, nr * sizeof(ld->ld_target[0]));
 	if (ld->ld_emrg != NULL)
 		lov_emerg_free(ld->ld_emrg, nr);
 	OBD_FREE_PTR(ld);
@@ -321,7 +321,7 @@ static struct lov_device_emerg **lov_emerg_alloc(int nr)
 	int i;
 	int result;
 
-	OBD_ALLOC(emerg, nr * sizeof emerg[0]);
+	OBD_ALLOC(emerg, nr * sizeof(emerg[0]));
 	if (emerg == NULL)
 		return ERR_PTR(-ENOMEM);
 	for (result = i = 0; i < nr && result == 0; i++) {
@@ -361,7 +361,7 @@ static int lov_expand_targets(const struct lu_env *env, struct lov_device *dev)
 	if (sub_size < tgt_size) {
 		struct lovsub_device    **newd;
 		struct lov_device_emerg **emerg;
-		const size_t	      sz   = sizeof newd[0];
+		const size_t	      sz   = sizeof(newd[0]);
 
 		emerg = lov_emerg_alloc(tgt_size);
 		if (IS_ERR(emerg))
diff --git a/drivers/staging/lustre/lustre/lov/lov_internal.h b/drivers/staging/lustre/lustre/lov/lov_internal.h
index 16770d1..9870d36 100644
--- a/drivers/staging/lustre/lustre/lov/lov_internal.h
+++ b/drivers/staging/lustre/lustre/lov/lov_internal.h
@@ -124,7 +124,7 @@ static inline void lov_llh_put(struct lov_lock_handles *llh)
 		if (atomic_read(&llh->llh_refcount))
 			return;
 
-		OBD_FREE_RCU(llh, sizeof *llh +
+		OBD_FREE_RCU(llh, sizeof(*llh) +
 			     sizeof(*llh->llh_handles) * llh->llh_stripe_count,
 			     &llh->llh_handle);
 	}
diff --git a/drivers/staging/lustre/lustre/lov/lov_io.c b/drivers/staging/lustre/lustre/lov/lov_io.c
index b611aa4..5be0e2c 100644
--- a/drivers/staging/lustre/lustre/lov/lov_io.c
+++ b/drivers/staging/lustre/lustre/lov/lov_io.c
@@ -282,7 +282,7 @@ static int lov_io_subio_init(const struct lu_env *env, struct lov_io *lio,
 	 * when writing a page. -jay
 	 */
 	OBD_ALLOC_LARGE(lio->lis_subs,
-			lsm->lsm_stripe_count * sizeof lio->lis_subs[0]);
+			lsm->lsm_stripe_count * sizeof(lio->lis_subs[0]));
 	if (lio->lis_subs != NULL) {
 		lio->lis_nr_subios = lio->lis_stripe_count;
 		lio->lis_single_subio_index = -1;
@@ -356,7 +356,7 @@ static void lov_io_fini(const struct lu_env *env, const struct cl_io_slice *ios)
 		for (i = 0; i < lio->lis_nr_subios; i++)
 			lov_io_sub_fini(env, lio, &lio->lis_subs[i]);
 		OBD_FREE_LARGE(lio->lis_subs,
-			 lio->lis_nr_subios * sizeof lio->lis_subs[0]);
+			 lio->lis_nr_subios * sizeof(lio->lis_subs[0]));
 		lio->lis_nr_subios = 0;
 	}
 
diff --git a/drivers/staging/lustre/lustre/lov/lov_lock.c b/drivers/staging/lustre/lustre/lov/lov_lock.c
index ec297e8..7682aeb 100644
--- a/drivers/staging/lustre/lustre/lov/lov_lock.c
+++ b/drivers/staging/lustre/lustre/lov/lov_lock.c
@@ -313,7 +313,7 @@ static int lov_lock_sub_init(const struct lu_env *env,
 			nr++;
 	}
 	LASSERT(nr > 0);
-	OBD_ALLOC_LARGE(lck->lls_sub, nr * sizeof lck->lls_sub[0]);
+	OBD_ALLOC_LARGE(lck->lls_sub, nr * sizeof(lck->lls_sub[0]));
 	if (lck->lls_sub == NULL)
 		return -ENOMEM;
 
@@ -474,7 +474,7 @@ static void lov_lock_fini(const struct lu_env *env,
 			 */
 			LASSERT(lck->lls_sub[i].sub_lock == NULL);
 		OBD_FREE_LARGE(lck->lls_sub,
-			       lck->lls_nr * sizeof lck->lls_sub[0]);
+			       lck->lls_nr * sizeof(lck->lls_sub[0]));
 	}
 	OBD_SLAB_FREE_PTR(lck, lov_lock_kmem);
 }
diff --git a/drivers/staging/lustre/lustre/lov/lov_object.c b/drivers/staging/lustre/lustre/lov/lov_object.c
index 84e55ce..cf2fa8a 100644
--- a/drivers/staging/lustre/lustre/lov/lov_object.c
+++ b/drivers/staging/lustre/lustre/lov/lov_object.c
@@ -214,7 +214,7 @@ static int lov_init_raid0(const struct lu_env *env,
 	r0->lo_nr  = lsm->lsm_stripe_count;
 	LASSERT(r0->lo_nr <= lov_targets_nr(dev));
 
-	OBD_ALLOC_LARGE(r0->lo_sub, r0->lo_nr * sizeof r0->lo_sub[0]);
+	OBD_ALLOC_LARGE(r0->lo_sub, r0->lo_nr * sizeof(r0->lo_sub[0]));
 	if (r0->lo_sub != NULL) {
 		result = 0;
 		subconf->coc_inode = conf->coc_inode;
@@ -368,7 +368,7 @@ static void lov_fini_raid0(const struct lu_env *env, struct lov_object *lov,
 	struct lov_layout_raid0 *r0 = &state->raid0;
 
 	if (r0->lo_sub != NULL) {
-		OBD_FREE_LARGE(r0->lo_sub, r0->lo_nr * sizeof r0->lo_sub[0]);
+		OBD_FREE_LARGE(r0->lo_sub, r0->lo_nr * sizeof(r0->lo_sub[0]));
 		r0->lo_sub = NULL;
 	}
 
diff --git a/drivers/staging/lustre/lustre/lov/lov_pack.c b/drivers/staging/lustre/lustre/lov/lov_pack.c
index 55ec267..2f80833 100644
--- a/drivers/staging/lustre/lustre/lov/lov_pack.c
+++ b/drivers/staging/lustre/lustre/lov/lov_pack.c
@@ -630,7 +630,7 @@ int lov_getstripe(struct obd_export *exp, struct lov_stripe_md *lsm,
 	/* FIXME: Bug 1185 - copy fields properly when structs change */
 	/* struct lov_user_md_v3 and struct lov_mds_md_v3 must be the same */
 	CLASSERT(sizeof(lum) == sizeof(struct lov_mds_md_v3));
-	CLASSERT(sizeof lum.lmm_objects[0] == sizeof lmmk->lmm_objects[0]);
+	CLASSERT(sizeof(lum.lmm_objects[0]) == sizeof(lmmk->lmm_objects[0]));
 
 	if ((cpu_to_le32(LOV_MAGIC) != LOV_MAGIC) &&
 	    ((lmmk->lmm_magic == cpu_to_le32(LOV_MAGIC_V1)) ||
diff --git a/drivers/staging/lustre/lustre/lov/lov_request.c b/drivers/staging/lustre/lustre/lov/lov_request.c
index 61e6d0b4..f80e626 100644
--- a/drivers/staging/lustre/lustre/lov/lov_request.c
+++ b/drivers/staging/lustre/lustre/lov/lov_request.c
@@ -245,7 +245,7 @@ int lov_update_enqueue_set(struct lov_request *req, __u32 mode, int rc)
 	osc_update_enqueue(lov_lockhp, loi, oi->oi_flags,
 			   &req->rq_oi.oi_md->lsm_oinfo[0]->loi_lvb, mode, rc);
 	if (rc == ELDLM_LOCK_ABORTED && (oi->oi_flags & LDLM_FL_HAS_INTENT))
-		memset(lov_lockhp, 0, sizeof *lov_lockhp);
+		memset(lov_lockhp, 0, sizeof(*lov_lockhp));
 	rc = lov_update_enqueue_lov(set->set_exp, lov_lockhp, loi, oi->oi_flags,
 				    req->rq_idx, &oi->oi_md->lsm_oi, rc);
 	lov_stripe_unlock(oi->oi_md);
@@ -343,7 +343,7 @@ static struct lov_lock_handles *lov_llh_new(struct lov_stripe_md *lsm)
 {
 	struct lov_lock_handles *llh;
 
-	OBD_ALLOC(llh, sizeof *llh +
+	OBD_ALLOC(llh, sizeof(*llh) +
 		  sizeof(*llh->llh_handles) * lsm->lsm_stripe_count);
 	if (llh == NULL)
 		return NULL;
diff --git a/drivers/staging/lustre/lustre/obdclass/cl_io.c b/drivers/staging/lustre/lustre/obdclass/cl_io.c
index 4269793..e048500 100644
--- a/drivers/staging/lustre/lustre/obdclass/cl_io.c
+++ b/drivers/staging/lustre/lustre/obdclass/cl_io.c
@@ -1387,7 +1387,7 @@ static void cl_req_free(const struct lu_env *env, struct cl_req *req)
 				cl_object_put(env, obj);
 			}
 		}
-		OBD_FREE(req->crq_o, req->crq_nrobjs * sizeof req->crq_o[0]);
+		OBD_FREE(req->crq_o, req->crq_nrobjs * sizeof(req->crq_o[0]));
 	}
 	OBD_FREE_PTR(req);
 }
@@ -1452,7 +1452,7 @@ struct cl_req *cl_req_alloc(const struct lu_env *env, struct cl_page *page,
 	if (req != NULL) {
 		int result;
 
-		OBD_ALLOC(req->crq_o, nr_objects * sizeof req->crq_o[0]);
+		OBD_ALLOC(req->crq_o, nr_objects * sizeof(req->crq_o[0]));
 		if (req->crq_o != NULL) {
 			req->crq_nrobjs = nr_objects;
 			req->crq_type = crt;
@@ -1642,7 +1642,7 @@ int cl_sync_io_wait(const struct lu_env *env, struct cl_io *io,
 		cpu_relax();
 	}
 
-	POISON(anchor, 0x5a, sizeof *anchor);
+	POISON(anchor, 0x5a, sizeof(*anchor));
 	return rc;
 }
 EXPORT_SYMBOL(cl_sync_io_wait);
diff --git a/drivers/staging/lustre/lustre/obdclass/class_obd.c b/drivers/staging/lustre/lustre/obdclass/class_obd.c
index b1024a6..4afd962 100644
--- a/drivers/staging/lustre/lustre/obdclass/class_obd.c
+++ b/drivers/staging/lustre/lustre/obdclass/class_obd.c
@@ -178,7 +178,7 @@ EXPORT_SYMBOL(obd_alloc_fail);
 static inline void obd_data2conn(struct lustre_handle *conn,
 				 struct obd_ioctl_data *data)
 {
-	memset(conn, 0, sizeof *conn);
+	memset(conn, 0, sizeof(*conn));
 	conn->cookie = data->ioc_cookie;
 }
 
diff --git a/drivers/staging/lustre/lustre/obdclass/llog_test.c b/drivers/staging/lustre/lustre/obdclass/llog_test.c
index d9e6d12..178f89e 100644
--- a/drivers/staging/lustre/lustre/obdclass/llog_test.c
+++ b/drivers/staging/lustre/lustre/obdclass/llog_test.c
@@ -242,7 +242,7 @@ static int llog_test_3(const struct lu_env *env, struct obd_device *obd,
 
 		hdr.lrh_len = 8;
 		hdr.lrh_type = OBD_CFG_REC;
-		memset(buf, 0, sizeof buf);
+		memset(buf, 0, sizeof(buf));
 		rc = llog_write(env, llh, &hdr, NULL, 0, buf, -1);
 		if (rc < 0) {
 			CERROR("3b: write 10 records failed at #%d: %d\n",
@@ -277,8 +277,8 @@ static int llog_test_3(const struct lu_env *env, struct obd_device *obd,
 		char			buf_even[24];
 		char			buf_odd[32];
 
-		memset(buf_odd, 0, sizeof buf_odd);
-		memset(buf_even, 0, sizeof buf_even);
+		memset(buf_odd, 0, sizeof(buf_odd));
+		memset(buf_even, 0, sizeof(buf_even));
 		if ((i % 2) == 0) {
 			hdr.lrh_len = 24;
 			hdr.lrh_type = OBD_CFG_REC;
diff --git a/drivers/staging/lustre/lustre/obdclass/lu_object.c b/drivers/staging/lustre/lustre/obdclass/lu_object.c
index 3a3d5bc..e8f2607 100644
--- a/drivers/staging/lustre/lustre/obdclass/lu_object.c
+++ b/drivers/staging/lustre/lustre/obdclass/lu_object.c
@@ -980,7 +980,7 @@ int lu_site_init(struct lu_site *s, struct lu_device *top)
 	int bits;
 	int i;
 
-	memset(s, 0, sizeof *s);
+	memset(s, 0, sizeof(*s));
 	bits = lu_htable_order();
 	snprintf(name, 16, "lu_site_%s", top->ld_type->ldt_name);
 	for (bits = min(max(LU_SITE_BITS_MIN, bits), LU_SITE_BITS_MAX);
@@ -1110,7 +1110,7 @@ int lu_device_init(struct lu_device *d, struct lu_device_type *t)
 {
 	if (t->ldt_device_nr++ == 0 && t->ldt_ops->ldto_start != NULL)
 		t->ldt_ops->ldto_start(t);
-	memset(d, 0, sizeof *d);
+	memset(d, 0, sizeof(*d));
 	atomic_set(&d->ld_ref, 0);
 	d->ld_type = t;
 	lu_ref_init(&d->ld_reference);
@@ -1206,7 +1206,7 @@ EXPORT_SYMBOL(lu_object_add);
  */
 int lu_object_header_init(struct lu_object_header *h)
 {
-	memset(h, 0, sizeof *h);
+	memset(h, 0, sizeof(*h));
 	atomic_set(&h->loh_ref, 1);
 	INIT_HLIST_NODE(&h->loh_hash);
 	INIT_LIST_HEAD(&h->loh_lru);
@@ -1525,7 +1525,7 @@ static void keys_fini(struct lu_context *ctx)
 	for (i = 0; i < ARRAY_SIZE(lu_keys); ++i)
 		key_fini(ctx, i);
 
-	OBD_FREE(ctx->lc_value, ARRAY_SIZE(lu_keys) * sizeof ctx->lc_value[0]);
+	OBD_FREE(ctx->lc_value, ARRAY_SIZE(lu_keys) * sizeof(ctx->lc_value[0]));
 	ctx->lc_value = NULL;
 }
 
@@ -1574,7 +1574,8 @@ static int keys_fill(struct lu_context *ctx)
 
 static int keys_init(struct lu_context *ctx)
 {
-	OBD_ALLOC(ctx->lc_value, ARRAY_SIZE(lu_keys) * sizeof ctx->lc_value[0]);
+	OBD_ALLOC(ctx->lc_value,
+		  ARRAY_SIZE(lu_keys) * sizeof(ctx->lc_value[0]));
 	if (likely(ctx->lc_value != NULL))
 		return keys_fill(ctx);
 
@@ -1588,7 +1589,7 @@ int lu_context_init(struct lu_context *ctx, __u32 tags)
 {
 	int	rc;
 
-	memset(ctx, 0, sizeof *ctx);
+	memset(ctx, 0, sizeof(*ctx));
 	ctx->lc_state = LCS_INITIALIZED;
 	ctx->lc_tags = tags;
 	if (tags & LCT_REMEMBER) {
diff --git a/drivers/staging/lustre/lustre/obdclass/obd_config.c b/drivers/staging/lustre/lustre/obdclass/obd_config.c
index d0a64ff..73e2571 100644
--- a/drivers/staging/lustre/lustre/obdclass/obd_config.c
+++ b/drivers/staging/lustre/lustre/obdclass/obd_config.c
@@ -417,7 +417,7 @@ int class_attach(struct lustre_cfg *lcfg)
 
 	/* do the attach */
 	if (OBP(obd, attach)) {
-		rc = OBP(obd,attach)(obd, sizeof *lcfg, lcfg);
+		rc = OBP(obd, attach)(obd, sizeof(*lcfg), lcfg);
 		if (rc)
 			GOTO(out, rc = -EINVAL);
 	}
@@ -900,7 +900,7 @@ void class_del_profile(const char *prof)
 		OBD_FREE(lprof->lp_dt, strlen(lprof->lp_dt) + 1);
 		if (lprof->lp_md)
 			OBD_FREE(lprof->lp_md, strlen(lprof->lp_md) + 1);
-		OBD_FREE(lprof, sizeof *lprof);
+		OBD_FREE(lprof, sizeof(*lprof));
 	}
 }
 EXPORT_SYMBOL(class_del_profile);
@@ -916,7 +916,7 @@ void class_del_profiles(void)
 		OBD_FREE(lprof->lp_dt, strlen(lprof->lp_dt) + 1);
 		if (lprof->lp_md)
 			OBD_FREE(lprof->lp_md, strlen(lprof->lp_md) + 1);
-		OBD_FREE(lprof, sizeof *lprof);
+		OBD_FREE(lprof, sizeof(*lprof));
 	}
 }
 EXPORT_SYMBOL(class_del_profiles);
diff --git a/drivers/staging/lustre/lustre/obdclass/uuid.c b/drivers/staging/lustre/lustre/obdclass/uuid.c
index af5f27f..e87a199 100644
--- a/drivers/staging/lustre/lustre/obdclass/uuid.c
+++ b/drivers/staging/lustre/lustre/obdclass/uuid.c
@@ -48,7 +48,7 @@ static inline __u32 consume(int nob, __u8 **ptr)
 {
 	__u32 value;
 
-	LASSERT(nob <= sizeof value);
+	LASSERT(nob <= sizeof(value));
 
 	for (value = 0; nob > 0; --nob)
 		value = (value << 8) | *((*ptr)++);
@@ -61,7 +61,7 @@ static void uuid_unpack(class_uuid_t in, __u16 *uu, int nr)
 {
 	__u8 *ptr = in;
 
-	LASSERT(nr * sizeof *uu == sizeof(class_uuid_t));
+	LASSERT(nr * sizeof(*uu) == sizeof(class_uuid_t));
 
 	while (nr-- > 0)
 		CONSUME(uu[nr], &ptr);
diff --git a/drivers/staging/lustre/lustre/obdecho/echo_client.c b/drivers/staging/lustre/lustre/obdecho/echo_client.c
index c8b4344..1fb0ac4 100644
--- a/drivers/staging/lustre/lustre/obdecho/echo_client.c
+++ b/drivers/staging/lustre/lustre/obdecho/echo_client.c
@@ -1089,7 +1089,7 @@ static struct echo_object *cl_echo_object_find(struct echo_device *d,
 		} else {
 			struct lustre_md *md;
 			md = &info->eti_md;
-			memset(md, 0, sizeof *md);
+			memset(md, 0, sizeof(*md));
 			md->lsm = lsm;
 			conf->eoc_cl.u.coc_md = md;
 		}
diff --git a/drivers/staging/lustre/lustre/osc/osc_lock.c b/drivers/staging/lustre/lustre/osc/osc_lock.c
index 5d7bdbf..c90abfb 100644
--- a/drivers/staging/lustre/lustre/osc/osc_lock.c
+++ b/drivers/staging/lustre/lustre/osc/osc_lock.c
@@ -862,7 +862,7 @@ static int osc_ldlm_glimpse_ast(struct ldlm_lock *dlmlock, void *data)
 			cap = &req->rq_pill;
 			req_capsule_extend(cap, &RQF_LDLM_GL_CALLBACK);
 			req_capsule_set_size(cap, &RMF_DLM_LVB, RCL_SERVER,
-					     sizeof *lvb);
+					     sizeof(*lvb));
 			result = req_capsule_server_pack(cap);
 			if (result == 0) {
 				lvb = req_capsule_server_get(cap, &RMF_DLM_LVB);
diff --git a/drivers/staging/lustre/lustre/osc/osc_page.c b/drivers/staging/lustre/lustre/osc/osc_page.c
index d272322..6c20b8e 100644
--- a/drivers/staging/lustre/lustre/osc/osc_page.c
+++ b/drivers/staging/lustre/lustre/osc/osc_page.c
@@ -245,7 +245,7 @@ static int osc_page_cache_add(const struct lu_env *env,
 void osc_index2policy(ldlm_policy_data_t *policy, const struct cl_object *obj,
 		      pgoff_t start, pgoff_t end)
 {
-	memset(policy, 0, sizeof *policy);
+	memset(policy, 0, sizeof(*policy));
 	policy->l_extent.start = cl_offset(obj, start);
 	policy->l_extent.end   = cl_offset(obj, end + 1) - 1;
 }
diff --git a/drivers/staging/lustre/lustre/osc/osc_request.c b/drivers/staging/lustre/lustre/osc/osc_request.c
index ee6707a..cb19778 100644
--- a/drivers/staging/lustre/lustre/osc/osc_request.c
+++ b/drivers/staging/lustre/lustre/osc/osc_request.c
@@ -2554,7 +2554,7 @@ int osc_enqueue_base(struct obd_export *exp, struct ldlm_res_id *res_id,
 		}
 
 		req_capsule_set_size(&req->rq_pill, &RMF_DLM_LVB, RCL_SERVER,
-				     sizeof *lvb);
+				     sizeof(*lvb));
 		ptlrpc_request_set_replen(req);
 	}
 
diff --git a/drivers/staging/lustre/lustre/ptlrpc/client.c b/drivers/staging/lustre/lustre/ptlrpc/client.c
index 810a458..c2ab0c8 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/client.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/client.c
@@ -817,7 +817,7 @@ struct ptlrpc_request_set *ptlrpc_prep_set(void)
 {
 	struct ptlrpc_request_set *set;
 
-	OBD_ALLOC(set, sizeof *set);
+	OBD_ALLOC(set, sizeof(*set));
 	if (!set)
 		return NULL;
 	atomic_set(&set->set_refcount, 1);
@@ -2690,7 +2690,7 @@ int ptlrpc_replay_req(struct ptlrpc_request *req)
 
 	LASSERT (sizeof (*aa) <= sizeof (req->rq_async_args));
 	aa = ptlrpc_req_async_args(req);
-	memset(aa, 0, sizeof *aa);
+	memset(aa, 0, sizeof(*aa));
 
 	/* Prepare request to be resent with ptlrpcd */
 	aa->praa_old_state = req->rq_send_state;
diff --git a/drivers/staging/lustre/lustre/ptlrpc/import.c b/drivers/staging/lustre/lustre/ptlrpc/import.c
index 5ca69ae..7b96a0e 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/import.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/import.c
@@ -682,7 +682,7 @@ int ptlrpc_connect_import(struct obd_import *imp)
 
 	CLASSERT(sizeof (*aa) <= sizeof (request->rq_async_args));
 	aa = ptlrpc_req_async_args(request);
-	memset(aa, 0, sizeof *aa);
+	memset(aa, 0, sizeof(*aa));
 
 	aa->pcaa_peer_committed = committed_before_reconnect;
 	aa->pcaa_initial_connect = initial_connect;
diff --git a/drivers/staging/lustre/lustre/ptlrpc/layout.c b/drivers/staging/lustre/lustre/ptlrpc/layout.c
index 2f55ce2..d0a6e56 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/layout.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/layout.c
@@ -1669,7 +1669,7 @@ void req_capsule_init(struct req_capsule *pill,
 	if (req != NULL && pill == &req->rq_pill && req->rq_pill_init)
 		return;
 
-	memset(pill, 0, sizeof *pill);
+	memset(pill, 0, sizeof(*pill));
 	pill->rc_req = req;
 	pill->rc_loc = location;
 	req_capsule_init_area(pill);
diff --git a/drivers/staging/lustre/lustre/ptlrpc/service.c b/drivers/staging/lustre/lustre/ptlrpc/service.c
index acf75f3..21de868 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/service.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/service.c
@@ -263,7 +263,7 @@ static struct ptlrpc_hr_service		ptlrpc_hr;
  */
 static void rs_batch_init(struct rs_batch *b)
 {
-	memset(b, 0, sizeof *b);
+	memset(b, 0, sizeof(*b));
 	INIT_LIST_HEAD(&b->rsb_replies);
 }
 
@@ -1306,12 +1306,12 @@ static int ptlrpc_at_send_early_reply(struct ptlrpc_request *req)
 	}
 	newdl = cfs_time_current_sec() + at_get(&svcpt->scp_at_estimate);
 
-	OBD_ALLOC(reqcopy, sizeof *reqcopy);
+	OBD_ALLOC(reqcopy, sizeof(*reqcopy));
 	if (reqcopy == NULL)
 		return -ENOMEM;
 	OBD_ALLOC_LARGE(reqmsg, req->rq_reqlen);
 	if (!reqmsg) {
-		OBD_FREE(reqcopy, sizeof *reqcopy);
+		OBD_FREE(reqcopy, sizeof(*reqcopy));
 		return -ENOMEM;
 	}
 
@@ -1370,7 +1370,7 @@ out_put:
 out:
 	sptlrpc_svc_ctx_decref(reqcopy);
 	OBD_FREE_LARGE(reqmsg, req->rq_reqlen);
-	OBD_FREE(reqcopy, sizeof *reqcopy);
+	OBD_FREE(reqcopy, sizeof(*reqcopy));
 	return rc;
 }
 


