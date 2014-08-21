Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967AbaHURlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 13:41:15 -0400
Received: from mail-yh0-f54.google.com ([209.85.213.54]:43883 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbaHURlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 13:41:13 -0400
From: Greg Donald <gdonald@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>, linux-kernel@vger.kernel.org
Cc: Greg Donald <gdonald@gmail.com>
Subject: [PATCH] drivers: staging: lustre: Fix space required before the open parenthesis '(' errors
Date: Thu, 21 Aug 2014 12:40:35 -0500
Message-Id: <1408642835-29563-1-git-send-email-gdonald@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl space required before the open parenthesis '(' errors

Signed-off-by: Greg Donald <gdonald@gmail.com>
---
 drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c    |  2 +-
 drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c |  2 +-
 drivers/staging/lustre/lnet/selftest/framework.c       |  2 +-
 drivers/staging/lustre/lustre/include/linux/lvfs.h     |  2 +-
 drivers/staging/lustre/lustre/include/lprocfs_status.h |  2 +-
 drivers/staging/lustre/lustre/include/lustre_dlm.h     |  2 +-
 drivers/staging/lustre/lustre/include/lustre_export.h  |  4 ++--
 drivers/staging/lustre/lustre/include/lustre_net.h     |  2 +-
 drivers/staging/lustre/lustre/include/obd.h            |  2 +-
 drivers/staging/lustre/lustre/include/obd_class.h      |  8 ++++----
 drivers/staging/lustre/lustre/include/obd_support.h    | 10 +++++-----
 drivers/staging/lustre/lustre/llite/dir.c              |  2 +-
 drivers/staging/lustre/lustre/llite/file.c             |  2 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c        |  2 +-
 drivers/staging/lustre/lustre/llite/llite_mmap.c       |  6 +++---
 drivers/staging/lustre/lustre/llite/lproc_llite.c      | 18 +++++++++---------
 drivers/staging/lustre/lustre/llite/vvp_dev.c          |  2 +-
 drivers/staging/lustre/lustre/llite/vvp_io.c           |  2 +-
 drivers/staging/lustre/lustre/obdclass/cl_io.c         |  2 +-
 drivers/staging/lustre/lustre/obdclass/class_obd.c     |  2 +-
 drivers/staging/lustre/lustre/obdclass/idmap.c         |  2 +-
 .../staging/lustre/lustre/obdclass/lprocfs_status.c    |  8 ++++----
 drivers/staging/lustre/lustre/obdclass/obd_config.c    |  4 ++--
 drivers/staging/lustre/lustre/obdclass/obd_mount.c     |  2 +-
 drivers/staging/lustre/lustre/obdecho/echo_client.c    |  4 ++--
 drivers/staging/lustre/lustre/ptlrpc/sec_config.c      |  2 +-
 26 files changed, 49 insertions(+), 49 deletions(-)

diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
index ab16439..f10650f 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
@@ -1025,7 +1025,7 @@ kiblnd_ctl(lnet_ni_t *ni, unsigned int cmd, void *arg)
 	struct libcfs_ioctl_data *data = arg;
 	int		       rc = -EINVAL;
 
-	switch(cmd) {
+	switch (cmd) {
 	case IOC_LIBCFS_GET_PEER: {
 		lnet_nid_t   nid = 0;
 		int	  count = 0;
diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
index 5214399..6ccbd65 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
@@ -232,7 +232,7 @@ ksocknal_transmit (ksock_conn_t *conn, ksock_tx_t *tx)
 				rc = -EAGAIN;
 
 			/* Check if EAGAIN is due to memory pressure */
-			if(rc == -EAGAIN && ksocknal_lib_memory_pressure(conn))
+			if (rc == -EAGAIN && ksocknal_lib_memory_pressure(conn))
 				rc = -ENOMEM;
 
 			break;
diff --git a/drivers/staging/lustre/lnet/selftest/framework.c b/drivers/staging/lustre/lnet/selftest/framework.c
index 7e83dff..d01689a 100644
--- a/drivers/staging/lustre/lnet/selftest/framework.c
+++ b/drivers/staging/lustre/lnet/selftest/framework.c
@@ -1286,7 +1286,7 @@ sfw_handle_server_rpc(struct srpc_server_rpc *rpc)
 		goto out;
 	}
 
-	switch(sv->sv_id) {
+	switch (sv->sv_id) {
 	default:
 		LBUG ();
 	case SRPC_SERVICE_TEST:
diff --git a/drivers/staging/lustre/lustre/include/linux/lvfs.h b/drivers/staging/lustre/lustre/include/linux/lvfs.h
index dd1be9c..c446375 100644
--- a/drivers/staging/lustre/lustre/include/linux/lvfs.h
+++ b/drivers/staging/lustre/lustre/include/linux/lvfs.h
@@ -87,7 +87,7 @@ struct lvfs_run_ctxt {
 #ifdef OBD_CTXT_DEBUG
 #define OBD_SET_CTXT_MAGIC(ctxt) (ctxt)->magic = OBD_RUN_CTXT_MAGIC
 #else
-#define OBD_SET_CTXT_MAGIC(ctxt) do {} while(0)
+#define OBD_SET_CTXT_MAGIC(ctxt) do {} while (0)
 #endif
 
 
diff --git a/drivers/staging/lustre/lustre/include/lprocfs_status.h b/drivers/staging/lustre/lustre/include/lprocfs_status.h
index 16b3d68..a8b68c1 100644
--- a/drivers/staging/lustre/lustre/include/lprocfs_status.h
+++ b/drivers/staging/lustre/lustre/include/lprocfs_status.h
@@ -673,7 +673,7 @@ extern int lprocfs_seq_release(struct inode *, struct file *);
 	     up_read(&(obd)->u.cli.cl_sem); \
 	     return -ENODEV;		    \
 	}				       \
-} while(0)
+} while (0)
 #define LPROCFS_CLIMP_EXIT(obd)		 \
 	up_read(&(obd)->u.cli.cl_sem);
 
diff --git a/drivers/staging/lustre/lustre/include/lustre_dlm.h b/drivers/staging/lustre/lustre/include/lustre_dlm.h
index 30b1812f..d6e28e5 100644
--- a/drivers/staging/lustre/lustre/include/lustre_dlm.h
+++ b/drivers/staging/lustre/lustre/include/lustre_dlm.h
@@ -1072,7 +1072,7 @@ extern char *ldlm_it2str(int it);
 	    ((libcfs_debug & (mask)) != 0 &&			    \
 	     (libcfs_subsystem_debug & DEBUG_SUBSYSTEM) != 0))	  \
 		_ldlm_lock_debug(lock, msgdata, fmt, ##a);	      \
-} while(0)
+} while (0)
 
 void _ldlm_lock_debug(struct ldlm_lock *lock,
 		      struct libcfs_debug_msg_data *data,
diff --git a/drivers/staging/lustre/lustre/include/lustre_export.h b/drivers/staging/lustre/lustre/include/lustre_export.h
index e5f8e86..9c06a49 100644
--- a/drivers/staging/lustre/lustre/include/lustre_export.h
+++ b/drivers/staging/lustre/lustre/include/lustre_export.h
@@ -125,14 +125,14 @@ struct nid_stat {
 #define nidstat_getref(nidstat)						\
 do {									   \
 	atomic_inc(&(nidstat)->nid_exp_ref_count);			 \
-} while(0)
+} while (0)
 
 #define nidstat_putref(nidstat)						\
 do {									   \
 	atomic_dec(&(nidstat)->nid_exp_ref_count);			 \
 	LASSERTF(atomic_read(&(nidstat)->nid_exp_ref_count) >= 0,	  \
 		 "stat %p nid_exp_ref_count < 0\n", nidstat);		  \
-} while(0)
+} while (0)
 
 enum obd_option {
 	OBD_OPT_FORCE =	 0x0001,
diff --git a/drivers/staging/lustre/lustre/include/lustre_net.h b/drivers/staging/lustre/lustre/include/lustre_net.h
index d6af2ca..6962f3d 100644
--- a/drivers/staging/lustre/lustre/include/lustre_net.h
+++ b/drivers/staging/lustre/lustre/include/lustre_net.h
@@ -1966,7 +1966,7 @@ do {									  \
 	    ((libcfs_debug & (mask)) != 0 &&				  \
 	     (libcfs_subsystem_debug & DEBUG_SUBSYSTEM) != 0))		\
 		_debug_req((req), msgdata, fmt, ##a);			 \
-} while(0)
+} while (0)
 
 /**
  * This is the debug print function you need to use to print request structure
diff --git a/drivers/staging/lustre/lustre/include/obd.h b/drivers/staging/lustre/lustre/include/obd.h
index 808cb0e..0c2a9f1 100644
--- a/drivers/staging/lustre/lustre/include/obd.h
+++ b/drivers/staging/lustre/lustre/include/obd.h
@@ -1456,7 +1456,7 @@ extern const struct lsm_operations lsm_v1_ops;
 extern const struct lsm_operations lsm_v3_ops;
 static inline const struct lsm_operations *lsm_op_find(int magic)
 {
-	switch(magic) {
+	switch (magic) {
 	case LOV_MAGIC_V1:
 	       return &lsm_v1_ops;
 	case LOV_MAGIC_V3:
diff --git a/drivers/staging/lustre/lustre/include/obd_class.h b/drivers/staging/lustre/lustre/include/obd_class.h
index 3597226..b5b23f9 100644
--- a/drivers/staging/lustre/lustre/include/obd_class.h
+++ b/drivers/staging/lustre/lustre/include/obd_class.h
@@ -219,8 +219,8 @@ extern void (*class_export_dump_hook)(struct obd_export *);
 
 #else
 
-#define __class_export_add_lock_ref(exp, lock)	     do {} while(0)
-#define __class_export_del_lock_ref(exp, lock)	     do {} while(0)
+#define __class_export_add_lock_ref(exp, lock)	     do {} while (0)
+#define __class_export_del_lock_ref(exp, lock)	     do {} while (0)
 
 #endif
 
@@ -2124,12 +2124,12 @@ extern struct kmem_cache *obdo_cachep;
 #define OBDO_ALLOC(ptr)						       \
 do {									  \
 	OBD_SLAB_ALLOC_PTR_GFP((ptr), obdo_cachep, GFP_NOFS);             \
-} while(0)
+} while (0)
 
 #define OBDO_FREE(ptr)							\
 do {									  \
 	OBD_SLAB_FREE_PTR((ptr), obdo_cachep);				\
-} while(0)
+} while (0)
 
 
 static inline void obdo2fid(struct obdo *oa, struct lu_fid *fid)
diff --git a/drivers/staging/lustre/lustre/include/obd_support.h b/drivers/staging/lustre/lustre/include/obd_support.h
index 874606a..62c0ecf 100644
--- a/drivers/staging/lustre/lustre/include/obd_support.h
+++ b/drivers/staging/lustre/lustre/include/obd_support.h
@@ -668,7 +668,7 @@ do {									      \
 	} else {							      \
 		OBD_ALLOC_POST(ptr, size, "vmalloced");		       \
 	}								     \
-} while(0)
+} while (0)
 
 # define OBD_VMALLOC(ptr, size)						      \
 	 __OBD_VMALLOC_VEROBSE(ptr, NULL, 0, size)
@@ -730,7 +730,7 @@ do {									  \
 	OBD_FREE_PRE(ptr, size, "kfreed");				    \
 	kfree(ptr);							\
 	POISON_PTR(ptr);						      \
-} while(0)
+} while (0)
 
 
 #define OBD_FREE_RCU(ptr, size, handle)					      \
@@ -742,7 +742,7 @@ do {									      \
 	__h->h_size = (size);						      \
 	call_rcu(&__h->h_rcu, class_handle_free_cb);			      \
 	POISON_PTR(ptr);						      \
-} while(0)
+} while (0)
 
 
 #define OBD_VFREE(ptr, size)				\
@@ -776,7 +776,7 @@ do {									      \
 		    OBD_SLAB_FREE_RTN0(ptr, slab)))) {			\
 		OBD_ALLOC_POST(ptr, size, "slab-alloced");		    \
 	}								     \
-} while(0)
+} while (0)
 
 #define OBD_SLAB_ALLOC_GFP(ptr, slab, size, flags)			      \
 	__OBD_SLAB_ALLOC_VERBOSE(ptr, slab, NULL, 0, size, flags)
@@ -790,7 +790,7 @@ do {									  \
 	OBD_FREE_PRE(ptr, size, "slab-freed");				\
 	kmem_cache_free(slab, ptr);					\
 	POISON_PTR(ptr);						      \
-} while(0)
+} while (0)
 
 #define OBD_SLAB_ALLOC(ptr, slab, size)					      \
 	OBD_SLAB_ALLOC_GFP(ptr, slab, size, GFP_NOFS)
diff --git a/drivers/staging/lustre/lustre/llite/dir.c b/drivers/staging/lustre/lustre/llite/dir.c
index de5892c..701c373 100644
--- a/drivers/staging/lustre/lustre/llite/dir.c
+++ b/drivers/staging/lustre/lustre/llite/dir.c
@@ -1244,7 +1244,7 @@ static long ll_dir_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		return -ENOTTY;
 
 	ll_stats_ops_tally(ll_i2sbi(inode), LPROC_LL_IOCTL, 1);
-	switch(cmd) {
+	switch (cmd) {
 	case FSFILT_IOC_GETFLAGS:
 	case FSFILT_IOC_SETFLAGS:
 		return ll_iocontrol(inode, file, cmd, arg);
diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 6ffbe7cb..06aae70 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -2149,7 +2149,7 @@ ll_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	if (_IOC_TYPE(cmd) == 'T' || _IOC_TYPE(cmd) == 't') /* tty ioctls */
 		return -ENOTTY;
 
-	switch(cmd) {
+	switch (cmd) {
 	case LL_IOC_GETFLAGS:
 		/* Get the current value of the file flags */
 		return put_user(fd->fd_flags, (int *)arg);
diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index ff375d3..82a4f95 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -1885,7 +1885,7 @@ int ll_iocontrol(struct inode *inode, struct file *file,
 	struct ptlrpc_request *req = NULL;
 	int rc, flags = 0;
 
-	switch(cmd) {
+	switch (cmd) {
 	case FSFILT_IOC_GETFLAGS: {
 		struct mdt_body *body;
 		struct md_op_data *op_data;
diff --git a/drivers/staging/lustre/lustre/llite/llite_mmap.c b/drivers/staging/lustre/lustre/llite/llite_mmap.c
index 5916648..fc92820 100644
--- a/drivers/staging/lustre/lustre/llite/llite_mmap.c
+++ b/drivers/staging/lustre/lustre/llite/llite_mmap.c
@@ -71,7 +71,7 @@ struct vm_area_struct *our_vma(struct mm_struct *mm, unsigned long addr,
 	/* mmap_sem must have been held by caller. */
 	LASSERT(!down_write_trylock(&mm->mmap_sem));
 
-	for(vma = find_vma(mm, addr);
+	for (vma = find_vma(mm, addr);
 	    vma != NULL && vma->vm_start < (addr + count); vma = vma->vm_next) {
 		if (vma->vm_ops && vma->vm_ops == &ll_file_vm_ops &&
 		    vma->vm_flags & VM_SHARED) {
@@ -261,7 +261,7 @@ out:
 
 static inline int to_fault_error(int result)
 {
-	switch(result) {
+	switch (result) {
 	case 0:
 		result = VM_FAULT_LOCKED;
 		break;
@@ -399,7 +399,7 @@ static int ll_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 		}
 	} while (retry);
 
-	switch(result) {
+	switch (result) {
 	case 0:
 		LASSERT(PageLocked(vmf->page));
 		result = VM_FAULT_LOCKED;
diff --git a/drivers/staging/lustre/lustre/llite/lproc_llite.c b/drivers/staging/lustre/lustre/llite/lproc_llite.c
index 77f68b5..f493654 100644
--- a/drivers/staging/lustre/lustre/llite/lproc_llite.c
+++ b/drivers/staging/lustre/lustre/llite/lproc_llite.c
@@ -1113,12 +1113,12 @@ static void ll_display_extents_info(struct ll_rw_extents_info *io_extents,
 	write_cum = 0;
 	start = 0;
 
-	for(i = 0; i < LL_HIST_MAX; i++) {
+	for (i = 0; i < LL_HIST_MAX; i++) {
 		read_tot += pp_info->pp_r_hist.oh_buckets[i];
 		write_tot += pp_info->pp_w_hist.oh_buckets[i];
 	}
 
-	for(i = 0; i < LL_HIST_MAX; i++) {
+	for (i = 0; i < LL_HIST_MAX; i++) {
 		r = pp_info->pp_r_hist.oh_buckets[i];
 		w = pp_info->pp_w_hist.oh_buckets[i];
 		read_cum += r;
@@ -1305,15 +1305,15 @@ void ll_rw_stats_tally(struct ll_sb_info *sbi, pid_t pid,
 	int *process_count = &sbi->ll_offset_process_count;
 	struct ll_rw_extents_info *io_extents = &sbi->ll_rw_extents_info;
 
-	if(!sbi->ll_rw_stats_on)
+	if (!sbi->ll_rw_stats_on)
 		return;
 	process = sbi->ll_rw_process_info;
 	offset = sbi->ll_rw_offset_info;
 
 	spin_lock(&sbi->ll_pp_extent_lock);
 	/* Extent statistics */
-	for(i = 0; i < LL_PROCESS_HIST_MAX; i++) {
-		if(io_extents->pp_extents[i].pid == pid) {
+	for (i = 0; i < LL_PROCESS_HIST_MAX; i++) {
+		if (io_extents->pp_extents[i].pid == pid) {
 			cur = i;
 			break;
 		}
@@ -1376,9 +1376,9 @@ void ll_rw_stats_tally(struct ll_sb_info *sbi, pid_t pid,
 				process[i].rw_offset = pos -
 					process[i].rw_last_file_pos;
 			}
-			if(process[i].rw_smallest_extent > count)
+			if (process[i].rw_smallest_extent > count)
 				process[i].rw_smallest_extent = count;
-			if(process[i].rw_largest_extent < count)
+			if (process[i].rw_largest_extent < count)
 				process[i].rw_largest_extent = count;
 			process[i].rw_last_file_pos = pos + count;
 			spin_unlock(&sbi->ll_process_lock);
@@ -1421,7 +1421,7 @@ static int ll_rw_offset_stats_seq_show(struct seq_file *seq, void *v)
 		   "R/W", "PID", "RANGE START", "RANGE END",
 		   "SMALLEST EXTENT", "LARGEST EXTENT", "OFFSET");
 	/* We stored the discontiguous offsets here; print them first */
-	for(i = 0; i < LL_OFFSET_HIST_MAX; i++) {
+	for (i = 0; i < LL_OFFSET_HIST_MAX; i++) {
 		if (offset[i].rw_pid != 0)
 			seq_printf(seq,
 				   "%3c %10d %14Lu %14Lu %17lu %17lu %14Lu",
@@ -1434,7 +1434,7 @@ static int ll_rw_offset_stats_seq_show(struct seq_file *seq, void *v)
 				   offset[i].rw_offset);
 	}
 	/* Then print the current offsets for each process */
-	for(i = 0; i < LL_PROCESS_HIST_MAX; i++) {
+	for (i = 0; i < LL_PROCESS_HIST_MAX; i++) {
 		if (process[i].rw_pid != 0)
 			seq_printf(seq,
 				   "%3c %10d %14Lu %14Lu %17lu %17lu %14Lu",
diff --git a/drivers/staging/lustre/lustre/llite/vvp_dev.c b/drivers/staging/lustre/lustre/llite/vvp_dev.c
index 0f2e79d..61ea934 100644
--- a/drivers/staging/lustre/lustre/llite/vvp_dev.c
+++ b/drivers/staging/lustre/lustre/llite/vvp_dev.c
@@ -394,7 +394,7 @@ static loff_t vvp_pgcache_find(const struct lu_env *env,
 		seq_printf(seq, "%s"#flag, has_flags ? "|" : "");       \
 		has_flags = 1;					  \
 	}							       \
-} while(0)
+} while (0)
 
 static void vvp_pgcache_page_show(const struct lu_env *env,
 				  struct seq_file *seq, struct cl_page *page)
diff --git a/drivers/staging/lustre/lustre/llite/vvp_io.c b/drivers/staging/lustre/lustre/llite/vvp_io.c
index fd24874..e7f7b5a 100644
--- a/drivers/staging/lustre/lustre/llite/vvp_io.c
+++ b/drivers/staging/lustre/lustre/llite/vvp_io.c
@@ -238,7 +238,7 @@ static int vvp_mmap_locks(const struct lu_env *env,
 		addr &= CFS_PAGE_MASK;
 
 		down_read(&mm->mmap_sem);
-		while((vma = our_vma(mm, addr, count)) != NULL) {
+		while ((vma = our_vma(mm, addr, count)) != NULL) {
 			struct inode *inode = vma->vm_file->f_dentry->d_inode;
 			int flags = CEF_MUST;
 
diff --git a/drivers/staging/lustre/lustre/obdclass/cl_io.c b/drivers/staging/lustre/lustre/obdclass/cl_io.c
index c0e0604..f2383a4 100644
--- a/drivers/staging/lustre/lustre/obdclass/cl_io.c
+++ b/drivers/staging/lustre/lustre/obdclass/cl_io.c
@@ -126,7 +126,7 @@ void cl_io_fini(const struct lu_env *env, struct cl_io *io)
 		info->clt_current_io = NULL;
 
 	/* sanity check for layout change */
-	switch(io->ci_type) {
+	switch (io->ci_type) {
 	case CIT_READ:
 	case CIT_WRITE:
 		break;
diff --git a/drivers/staging/lustre/lustre/obdclass/class_obd.c b/drivers/staging/lustre/lustre/obdclass/class_obd.c
index 8b19f3c..0b9fac2 100644
--- a/drivers/staging/lustre/lustre/obdclass/class_obd.c
+++ b/drivers/staging/lustre/lustre/obdclass/class_obd.c
@@ -381,7 +381,7 @@ int class_handle_ioctl(unsigned int cmd, unsigned long arg)
 		GOTO(out, err = -EINVAL);
 	}
 
-	switch(cmd) {
+	switch (cmd) {
 	case OBD_IOC_NO_TRANSNO: {
 		if (!obd->obd_attached) {
 			CERROR("Device %d not attached\n", obd->obd_minor);
diff --git a/drivers/staging/lustre/lustre/obdclass/idmap.c b/drivers/staging/lustre/lustre/obdclass/idmap.c
index 1190885..24eaeb3 100644
--- a/drivers/staging/lustre/lustre/obdclass/idmap.c
+++ b/drivers/staging/lustre/lustre/obdclass/idmap.c
@@ -442,7 +442,7 @@ struct lustre_idmap_table *lustre_idmap_init(void)
 	int i, j;
 
 	OBD_ALLOC_PTR(t);
-	if(unlikely(t == NULL))
+	if (unlikely(t == NULL))
 		return (ERR_PTR(-ENOMEM));
 
 	spin_lock_init(&t->lit_lock);
diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
index 8309d4c..1dbb309 100644
--- a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
+++ b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
@@ -751,7 +751,7 @@ int lprocfs_rd_import(struct seq_file *m, void *data)
 		      ret.lc_sum, header->lc_units);
 
 	k = 0;
-	for(j = 0; j < IMP_AT_MAX_PORTALS; j++) {
+	for (j = 0; j < IMP_AT_MAX_PORTALS; j++) {
 		if (imp->imp_at.iat_portal[j] == 0)
 			break;
 		k = max_t(unsigned int, k,
@@ -883,7 +883,7 @@ int lprocfs_rd_timeouts(struct seq_file *m, void *data)
 		       "network", cur, worst, worstt, DHMS_VARS(&ts));
 	lprocfs_at_hist_helper(m, &imp->imp_at.iat_net_latency);
 
-	for(i = 0; i < IMP_AT_MAX_PORTALS; i++) {
+	for (i = 0; i < IMP_AT_MAX_PORTALS; i++) {
 		if (imp->imp_at.iat_portal[i] == 0)
 			break;
 		cur = at_get(&imp->imp_at.iat_service_estimate[i]);
@@ -1741,7 +1741,7 @@ int lprocfs_exp_cleanup(struct obd_export *exp)
 {
 	struct nid_stat *stat = exp->exp_nid_stats;
 
-	if(!stat || !exp->exp_obd)
+	if (!stat || !exp->exp_obd)
 		return 0;
 
 	nidstat_putref(exp->exp_nid_stats);
@@ -1828,7 +1828,7 @@ int lprocfs_write_frac_u64_helper(const char *buffer, unsigned long count,
 	}
 
 	units = 1;
-	switch(*end) {
+	switch (*end) {
 	case 'p': case 'P':
 		units <<= 10;
 	case 't': case 'T':
diff --git a/drivers/staging/lustre/lustre/obdclass/obd_config.c b/drivers/staging/lustre/lustre/obdclass/obd_config.c
index 0d81d32..3359d33 100644
--- a/drivers/staging/lustre/lustre/obdclass/obd_config.c
+++ b/drivers/staging/lustre/lustre/obdclass/obd_config.c
@@ -1087,7 +1087,7 @@ int class_process_config(struct lustre_cfg *lcfg)
 	CDEBUG(D_IOCTL, "processing cmd: %x\n", lcfg->lcfg_command);
 
 	/* Commands that don't need a device */
-	switch(lcfg->lcfg_command) {
+	switch (lcfg->lcfg_command) {
 	case LCFG_ATTACH: {
 		err = class_attach(lcfg);
 		GOTO(out, err);
@@ -1203,7 +1203,7 @@ int class_process_config(struct lustre_cfg *lcfg)
 		GOTO(out, err = -EINVAL);
 	}
 
-	switch(lcfg->lcfg_command) {
+	switch (lcfg->lcfg_command) {
 	case LCFG_SETUP: {
 		err = class_setup(obd, lcfg);
 		GOTO(out, err);
diff --git a/drivers/staging/lustre/lustre/obdclass/obd_mount.c b/drivers/staging/lustre/lustre/obdclass/obd_mount.c
index d972f71..560a47d 100644
--- a/drivers/staging/lustre/lustre/obdclass/obd_mount.c
+++ b/drivers/staging/lustre/lustre/obdclass/obd_mount.c
@@ -817,7 +817,7 @@ int lustre_check_exclusion(struct super_block *sb, char *svname)
 	CDEBUG(D_MOUNT, "Check exclusion %s (%d) in %d of %s\n", svname,
 	       index, lmd->lmd_exclude_count, lmd->lmd_dev);
 
-	for(i = 0; i < lmd->lmd_exclude_count; i++) {
+	for (i = 0; i < lmd->lmd_exclude_count; i++) {
 		if (index == lmd->lmd_exclude[i]) {
 			CWARN("Excluding %s (on exclusion list)\n", svname);
 			return 1;
diff --git a/drivers/staging/lustre/lustre/obdecho/echo_client.c b/drivers/staging/lustre/lustre/obdecho/echo_client.c
index 2273669..3db5d2b 100644
--- a/drivers/staging/lustre/lustre/obdecho/echo_client.c
+++ b/drivers/staging/lustre/lustre/obdecho/echo_client.c
@@ -903,7 +903,7 @@ static struct lu_device *echo_device_alloc(const struct lu_env *env,
 	ed->ed_next = next;
 	return &cd->cd_lu_dev;
 out:
-	switch(cleanup) {
+	switch (cleanup) {
 	case 4: {
 		int rc2;
 		rc2 = echo_client_cleanup(obd);
@@ -2548,7 +2548,7 @@ static int echo_client_prep_commit(const struct lu_env *env,
 
 	off = offset;
 
-	for(; tot_pages; tot_pages -= npages) {
+	for (; tot_pages; tot_pages -= npages) {
 		int lpages;
 
 		if (tot_pages < npages)
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec_config.c b/drivers/staging/lustre/lustre/ptlrpc/sec_config.c
index 01f8b0d..25bdb9a 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec_config.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec_config.c
@@ -746,7 +746,7 @@ void sptlrpc_conf_log_update_begin(const char *logname)
 
 	conf = sptlrpc_conf_get(fsname, 0);
 	if (conf) {
-		if(conf->sc_local) {
+		if (conf->sc_local) {
 			LASSERT(conf->sc_updated == 0);
 			sptlrpc_conf_free_rsets(conf);
 		}
-- 
1.9.1

