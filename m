Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933688AbaHZBIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 21:08:00 -0400
Received: from mail-yk0-f173.google.com ([209.85.160.173]:43433 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756883AbaHZBH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 21:07:57 -0400
From: Greg Donald <gdonald@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>, linux-kernel@vger.kernel.org
Cc: Greg Donald <gdonald@gmail.com>
Subject: [PATCH] drivers: staging: lustre: Fix space required after that ',' errors
Date: Mon, 25 Aug 2014 20:07:19 -0500
Message-Id: <1409015239-20512-1-git-send-email-gdonald@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl space required after that ',' errors

Signed-off-by: Greg Donald <gdonald@gmail.com>
---
 drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c    |  2 +-
 drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c |  6 +++---
 .../staging/lustre/lnet/klnds/socklnd/socklnd_proto.c  |  6 ++++--
 drivers/staging/lustre/lnet/selftest/console.c         |  2 +-
 drivers/staging/lustre/lustre/include/interval_tree.h  |  2 +-
 drivers/staging/lustre/lustre/include/lclient.h        | 14 ++++++++------
 .../lustre/lustre/include/linux/lustre_compat25.h      | 18 ++++++++++--------
 .../lustre/lustre/include/linux/lustre_fsfilt.h        |  5 +++--
 drivers/staging/lustre/lustre/include/lprocfs_status.h |  5 +++--
 drivers/staging/lustre/lustre/include/lu_object.h      |  4 ++--
 .../staging/lustre/lustre/include/lustre/lustre_idl.h  |  7 ++++---
 .../staging/lustre/lustre/include/lustre/lustre_user.h |  2 +-
 drivers/staging/lustre/lustre/include/lustre_net.h     |  6 ++++--
 drivers/staging/lustre/lustre/include/lustre_ver.h     |  4 +++-
 drivers/staging/lustre/lustre/include/obd.h            |  8 +++++---
 drivers/staging/lustre/lustre/include/obd_class.h      |  5 +++--
 drivers/staging/lustre/lustre/include/obd_support.h    |  4 ++--
 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c         |  3 ++-
 drivers/staging/lustre/lustre/ldlm/ldlm_request.c      |  5 +++--
 drivers/staging/lustre/lustre/libcfs/debug.c           |  6 ++++--
 drivers/staging/lustre/lustre/libcfs/hash.c            |  3 ++-
 drivers/staging/lustre/lustre/libcfs/module.c          |  2 +-
 drivers/staging/lustre/lustre/libcfs/upcall_cache.c    |  2 +-
 drivers/staging/lustre/lustre/llite/dir.c              |  2 +-
 drivers/staging/lustre/lustre/llite/llite_internal.h   |  2 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c        |  5 +++--
 drivers/staging/lustre/lustre/llite/lproc_llite.c      |  2 +-
 drivers/staging/lustre/lustre/llite/namei.c            |  3 ++-
 drivers/staging/lustre/lustre/llite/rw26.c             |  2 +-
 drivers/staging/lustre/lustre/llite/statahead.c        |  5 +++--
 drivers/staging/lustre/lustre/llite/vvp_dev.c          |  2 +-
 drivers/staging/lustre/lustre/llite/vvp_io.c           |  2 +-
 drivers/staging/lustre/lustre/lmv/lmv_obd.c            |  2 +-
 drivers/staging/lustre/lustre/lov/lov_pack.c           |  2 +-
 drivers/staging/lustre/lustre/lov/lov_request.c        |  3 ++-
 drivers/staging/lustre/lustre/obdclass/genops.c        |  3 ++-
 drivers/staging/lustre/lustre/obdclass/llog_cat.c      |  3 ++-
 drivers/staging/lustre/lustre/obdclass/llog_lvfs.c     |  6 ++++--
 .../staging/lustre/lustre/obdclass/lprocfs_status.c    |  8 +++++---
 drivers/staging/lustre/lustre/obdclass/obd_mount.c     |  3 ++-
 drivers/staging/lustre/lustre/osc/lproc_osc.c          |  2 +-
 drivers/staging/lustre/lustre/osc/osc_internal.h       |  2 +-
 drivers/staging/lustre/lustre/osc/osc_request.c        | 10 ++++++----
 drivers/staging/lustre/lustre/ptlrpc/events.c          |  5 +++--
 drivers/staging/lustre/lustre/ptlrpc/import.c          |  5 +++--
 drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c    |  7 ++++---
 drivers/staging/lustre/lustre/ptlrpc/pinger.c          |  3 ++-
 drivers/staging/lustre/lustre/ptlrpc/sec_null.c        |  3 ++-
 drivers/staging/lustre/lustre/ptlrpc/service.c         |  3 ++-
 49 files changed, 128 insertions(+), 88 deletions(-)

diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
index ab16439..e60ca73 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
@@ -1202,7 +1202,7 @@ kiblnd_map_rx_descs(kib_conn_t *conn)
 						   rx->rx_msgaddr));
 		KIBLND_UNMAP_ADDR_SET(rx, rx_msgunmap, rx->rx_msgaddr);
 
-		CDEBUG(D_NET,"rx %d: %p %#llx(%#llx)\n",
+		CDEBUG(D_NET, "rx %d: %p %#llx(%#llx)\n",
 		       i, rx->rx_msg, rx->rx_msgaddr,
 		       lnet_page2phys(pg) + pg_off);
 
diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
index 306d728..35d13e0 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
@@ -2080,7 +2080,7 @@ kiblnd_connreq_done(kib_conn_t *conn, int status)
 
 	active = (conn->ibc_state == IBLND_CONN_ACTIVE_CONNECT);
 
-	CDEBUG(D_NET,"%s: active(%d), version(%x), status(%d)\n",
+	CDEBUG(D_NET, "%s: active(%d), version(%x), status(%d)\n",
 	       libcfs_nid2str(peer->ibp_nid), active,
 	       conn->ibc_version, status);
 
@@ -2848,7 +2848,7 @@ kiblnd_cm_callback(struct rdma_cm_id *cmid, struct rdma_cm_event *event)
 	case RDMA_CM_EVENT_ADDR_RESOLVED:
 		peer = (kib_peer_t *)cmid->context;
 
-		CDEBUG(D_NET,"%s Addr resolved: %d\n",
+		CDEBUG(D_NET, "%s Addr resolved: %d\n",
 		       libcfs_nid2str(peer->ibp_nid), event->status);
 
 		if (event->status != 0) {
@@ -2878,7 +2878,7 @@ kiblnd_cm_callback(struct rdma_cm_id *cmid, struct rdma_cm_event *event)
 
 	case RDMA_CM_EVENT_ROUTE_RESOLVED:
 		peer = (kib_peer_t *)cmid->context;
-		CDEBUG(D_NET,"%s Route resolved: %d\n",
+		CDEBUG(D_NET, "%s Route resolved: %d\n",
 		       libcfs_nid2str(peer->ibp_nid), event->status);
 
 		if (event->status == 0)
diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_proto.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_proto.c
index 050a58d..09e1758 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_proto.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_proto.c
@@ -495,7 +495,8 @@ ksocknal_send_hello_v1 (ksock_conn_t *conn, ksock_hello_msg_t *hello)
 	hdr->msg.hello.type = cpu_to_le32 (hello->kshm_ctype);
 	hdr->msg.hello.incarnation = cpu_to_le64 (hello->kshm_src_incarnation);
 
-	rc = libcfs_sock_write(sock, hdr, sizeof(*hdr),lnet_acceptor_timeout());
+	rc = libcfs_sock_write(sock, hdr, sizeof(*hdr),
+			       lnet_acceptor_timeout());
 
 	if (rc != 0) {
 		CNETERR("Error %d sending HELLO hdr to %pI4h/%d\n",
@@ -568,7 +569,8 @@ ksocknal_send_hello_v2 (ksock_conn_t *conn, ksock_hello_msg_t *hello)
 }
 
 static int
-ksocknal_recv_hello_v1(ksock_conn_t *conn, ksock_hello_msg_t *hello,int timeout)
+ksocknal_recv_hello_v1(ksock_conn_t *conn, ksock_hello_msg_t *hello,
+		       int timeout)
 {
 	struct socket	*sock = conn->ksnc_sock;
 	lnet_hdr_t	  *hdr;
diff --git a/drivers/staging/lustre/lnet/selftest/console.c b/drivers/staging/lustre/lnet/selftest/console.c
index 89e1b4b..68174fd 100644
--- a/drivers/staging/lustre/lnet/selftest/console.c
+++ b/drivers/staging/lustre/lnet/selftest/console.c
@@ -910,7 +910,7 @@ lstcon_batch_list(int index, int len, char *name_up)
 
 	list_for_each_entry(bat, &console_session.ses_bat_list, bat_link) {
 		if (index-- == 0) {
-			return copy_to_user(name_up,bat->bat_name, len) ?
+			return copy_to_user(name_up, bat->bat_name, len) ?
 			       -EFAULT: 0;
 		}
 	}
diff --git a/drivers/staging/lustre/lustre/include/interval_tree.h b/drivers/staging/lustre/lustre/include/interval_tree.h
index 1815783..bf9027d 100644
--- a/drivers/staging/lustre/lustre/include/interval_tree.h
+++ b/drivers/staging/lustre/lustre/include/interval_tree.h
@@ -112,7 +112,7 @@ enum interval_iter interval_search(struct interval_node *root,
 enum interval_iter interval_iterate(struct interval_node *root,
 				    interval_callback_t func, void *data);
 enum interval_iter interval_iterate_reverse(struct interval_node *root,
-				    interval_callback_t func,void *data);
+				    interval_callback_t func, void *data);
 
 void interval_expand(struct interval_node *root,
 		     struct interval_node_extent *ext,
diff --git a/drivers/staging/lustre/lustre/include/lclient.h b/drivers/staging/lustre/lustre/include/lclient.h
index fa45c94..b3b841f 100644
--- a/drivers/staging/lustre/lustre/include/lclient.h
+++ b/drivers/staging/lustre/lustre/include/lclient.h
@@ -279,7 +279,7 @@ int ccc_req_init(const struct lu_env *env, struct cl_device *dev,
 void ccc_umount(const struct lu_env *env, struct cl_device *dev);
 int ccc_global_init(struct lu_device_type *device_type);
 void ccc_global_fini(struct lu_device_type *device_type);
-int ccc_object_init0(const struct lu_env *env,struct ccc_object *vob,
+int ccc_object_init0(const struct lu_env *env, struct ccc_object *vob,
 		     const struct cl_object_conf *conf);
 int ccc_object_init(const struct lu_env *env, struct lu_object *obj,
 		    const struct lu_object_conf *conf);
@@ -319,11 +319,12 @@ int ccc_transient_page_prep(const struct lu_env *env,
 			    struct cl_io *io);
 void ccc_lock_delete(const struct lu_env *env,
 		     const struct cl_lock_slice *slice);
-void ccc_lock_fini(const struct lu_env *env,struct cl_lock_slice *slice);
-int ccc_lock_enqueue(const struct lu_env *env,const struct cl_lock_slice *slice,
+void ccc_lock_fini(const struct lu_env *env, struct cl_lock_slice *slice);
+int ccc_lock_enqueue(const struct lu_env *env,
+		     const struct cl_lock_slice *slice,
 		     struct cl_io *io, __u32 enqflags);
-int ccc_lock_unuse(const struct lu_env *env,const struct cl_lock_slice *slice);
-int ccc_lock_wait(const struct lu_env *env,const struct cl_lock_slice *slice);
+int ccc_lock_unuse(const struct lu_env *env, const struct cl_lock_slice *slice);
+int ccc_lock_wait(const struct lu_env *env, const struct cl_lock_slice *slice);
 int ccc_lock_fits_into(const struct lu_env *env,
 		       const struct cl_lock_slice *slice,
 		       const struct cl_lock_descr *need,
@@ -348,7 +349,8 @@ int ccc_prep_size(const struct lu_env *env, struct cl_object *obj,
 		  struct cl_io *io, loff_t start, size_t count, int *exceed);
 void ccc_req_completion(const struct lu_env *env,
 			const struct cl_req_slice *slice, int ioret);
-void ccc_req_attr_set(const struct lu_env *env,const struct cl_req_slice *slice,
+void ccc_req_attr_set(const struct lu_env *env,
+		      const struct cl_req_slice *slice,
 		      const struct cl_object *obj,
 		      struct cl_req_attr *oa, u64 flags);
 
diff --git a/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h b/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h
index 8621bac..f9522de 100644
--- a/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h
+++ b/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h
@@ -99,17 +99,19 @@ static inline void ll_set_fs_pwd(struct fs_struct *fs, struct vfsmount *mnt,
 #define FS_HAS_FIEMAP			(0)
 #endif
 
-#define ll_vfs_rmdir(dir,entry,mnt)	     vfs_rmdir(dir,entry)
-#define ll_vfs_mkdir(inode,dir,mnt,mode)	vfs_mkdir(inode,dir,mode)
-#define ll_vfs_link(old,mnt,dir,new,mnt1)       vfs_link(old,dir,new)
-#define ll_vfs_unlink(inode,entry,mnt)	  vfs_unlink(inode,entry)
-#define ll_vfs_mknod(dir,entry,mnt,mode,dev)    vfs_mknod(dir,entry,mode,dev)
-#define ll_security_inode_unlink(dir,entry,mnt) security_inode_unlink(dir,entry)
+#define ll_vfs_rmdir(dir, entry, mnt)	     vfs_rmdir(dir, entry)
+#define ll_vfs_mkdir(inode, dir, mnt, mode)	vfs_mkdir(inode, dir, mode)
+#define ll_vfs_link(old, mnt, dir, new, mnt1)       vfs_link(old, dir, new)
+#define ll_vfs_unlink(inode, entry, mnt)	  vfs_unlink(inode, entry)
+#define ll_vfs_mknod(dir, entry, mnt, mode, dev) \
+		     vfs_mknod(dir, entry, mode, dev)
+#define ll_security_inode_unlink(dir, entry, mnt) \
+				 security_inode_unlink(dir, entry)
 #define ll_vfs_rename(old, old_dir, mnt, new, new_dir, mnt1) \
 		vfs_rename(old, old_dir, new, new_dir, NULL, 0)
 
-#define cfs_bio_io_error(a,b)   bio_io_error((a))
-#define cfs_bio_endio(a,b,c)    bio_endio((a),(c))
+#define cfs_bio_io_error(a, b)   bio_io_error((a))
+#define cfs_bio_endio(a, b, c)    bio_endio((a), (c))
 
 #define cfs_fs_pwd(fs)       ((fs)->pwd.dentry)
 #define cfs_fs_mnt(fs)       ((fs)->pwd.mnt)
diff --git a/drivers/staging/lustre/lustre/include/linux/lustre_fsfilt.h b/drivers/staging/lustre/lustre/include/linux/lustre_fsfilt.h
index d5c97be..18c06fb 100644
--- a/drivers/staging/lustre/lustre/include/linux/lustre_fsfilt.h
+++ b/drivers/staging/lustre/lustre/include/linux/lustre_fsfilt.h
@@ -59,7 +59,7 @@ struct fsfilt_operations {
 	char   *(* fs_getlabel)(struct super_block *sb);
 	void   *(* fs_start)(struct inode *inode, int op, void *desc_private,
 			     int logs);
-	int     (* fs_commit)(struct inode *inode, void *handle,int force_sync);
+	int     (*fs_commit)(struct inode *inode, void *handle, int force_sync);
 	int     (* fs_map_inode_pages)(struct inode *inode, struct page **page,
 				       int pages, unsigned long *blocks,
 				       int create, struct mutex *sem);
@@ -155,7 +155,8 @@ static inline int fsfilt_write_record(struct obd_device *obd, struct file *file,
 				      void *buf, loff_t size, loff_t *offs,
 				      int force_sync)
 {
-	return obd->obd_fsops->fs_write_record(file, buf, size,offs,force_sync);
+	return obd->obd_fsops->fs_write_record(file, buf, size, offs,
+					       force_sync);
 }
 
 static inline int fsfilt_setup(struct obd_device *obd, struct super_block *fs)
diff --git a/drivers/staging/lustre/lustre/include/lprocfs_status.h b/drivers/staging/lustre/lustre/include/lprocfs_status.h
index 16b3d68..503685b 100644
--- a/drivers/staging/lustre/lustre/include/lprocfs_status.h
+++ b/drivers/staging/lustre/lustre/include/lprocfs_status.h
@@ -351,7 +351,7 @@ struct obd_histogram;
 
 /* Days / hours / mins / seconds format */
 struct dhms {
-	int d,h,m,s;
+	int d, h, m, s;
 };
 static inline void s2dhms(struct dhms *ts, time_t secs)
 {
@@ -864,7 +864,8 @@ static inline void lprocfs_free_md_stats(struct obd_device *obddev)
 struct obd_export;
 static inline int lprocfs_add_clear_entry(struct obd_export *exp)
 { return 0; }
-static inline int lprocfs_exp_setup(struct obd_export *exp,lnet_nid_t *peer_nid,
+static inline int lprocfs_exp_setup(struct obd_export *exp,
+				    lnet_nid_t *peer_nid,
 				    int *newnid)
 { return 0; }
 static inline int lprocfs_exp_cleanup(struct obd_export *exp)
diff --git a/drivers/staging/lustre/lustre/include/lu_object.h b/drivers/staging/lustre/lustre/include/lu_object.h
index a6ce42a..6015ee5 100644
--- a/drivers/staging/lustre/lustre/include/lu_object.h
+++ b/drivers/staging/lustre/lustre/include/lu_object.h
@@ -1146,8 +1146,8 @@ struct lu_context_key {
 	struct __##mod##__dummy_fini {;} /* semicolon catcher */
 
 #define LU_KEY_INIT_FINI(mod, type)   \
-	LU_KEY_INIT(mod,type);	\
-	LU_KEY_FINI(mod,type)
+	LU_KEY_INIT(mod, type);	\
+	LU_KEY_FINI(mod, type)
 
 #define LU_CONTEXT_KEY_DEFINE(mod, tags)		\
 	struct lu_context_key mod##_thread_key = {      \
diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
index 570f54f..fd6dc53 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
@@ -1355,8 +1355,9 @@ extern void lustre_swab_ptlrpc_body(struct ptlrpc_body *pb);
 #define CLIENT_CONNECT_MDT_REQD (OBD_CONNECT_IBITS | OBD_CONNECT_FID | \
 				 OBD_CONNECT_FULL20)
 
-#define OBD_OCD_VERSION(major,minor,patch,fix) (((major)<<24) + ((minor)<<16) +\
-						((patch)<<8) + (fix))
+#define OBD_OCD_VERSION(major, minor, patch, fix) (((major)<<24) + \
+						  ((minor)<<16) + \
+						  ((patch)<<8) + (fix))
 #define OBD_OCD_VERSION_MAJOR(version) ((int)((version)>>24)&255)
 #define OBD_OCD_VERSION_MINOR(version) ((int)((version)>>16)&255)
 #define OBD_OCD_VERSION_PATCH(version) ((int)((version)>>8)&255)
@@ -2855,7 +2856,7 @@ extern void lustre_swab_ldlm_request (struct ldlm_request *rq);
 
 /* If LDLM_ENQUEUE, 1 slot is already occupied, 1 is available.
  * Otherwise, 2 are available. */
-#define ldlm_request_bufsize(count,type)				\
+#define ldlm_request_bufsize(count, type)				\
 ({								      \
 	int _avail = LDLM_LOCKREQ_HANDLES;			      \
 	_avail -= (type == LDLM_ENQUEUE ? LDLM_ENQUEUE_CANCEL_OFF : 0); \
diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
index 4c1b3cb..01a6674 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
@@ -841,7 +841,7 @@ struct ioc_data_version {
 				version. Dirty caches are left unchanged. */
 
 #ifndef offsetof
-# define offsetof(typ,memb)     ((unsigned long)((char *)&(((typ *)0)->memb)))
+# define offsetof(typ, memb)     ((unsigned long)((char *)&(((typ *)0)->memb)))
 #endif
 
 #define dot_lustre_name ".lustre"
diff --git a/drivers/staging/lustre/lustre/include/lustre_net.h b/drivers/staging/lustre/lustre/include/lustre_net.h
index d6af2ca..e8b4912 100644
--- a/drivers/staging/lustre/lustre/include/lustre_net.h
+++ b/drivers/staging/lustre/lustre/include/lustre_net.h
@@ -2912,11 +2912,13 @@ __u32 lustre_msg_calc_cksum(struct lustre_msg *msg, int compat18);
 # warning "remove checksum compatibility support for b1_8"
 __u32 lustre_msg_calc_cksum(struct lustre_msg *msg);
 #endif
-void lustre_msg_set_handle(struct lustre_msg *msg,struct lustre_handle *handle);
+void lustre_msg_set_handle(struct lustre_msg *msg,
+			   struct lustre_handle *handle);
 void lustre_msg_set_type(struct lustre_msg *msg, __u32 type);
 void lustre_msg_set_opc(struct lustre_msg *msg, __u32 opc);
 void lustre_msg_set_last_xid(struct lustre_msg *msg, __u64 last_xid);
-void lustre_msg_set_last_committed(struct lustre_msg *msg,__u64 last_committed);
+void lustre_msg_set_last_committed(struct lustre_msg *msg,
+				   __u64 last_committed);
 void lustre_msg_set_versions(struct lustre_msg *msg, __u64 *versions);
 void lustre_msg_set_transno(struct lustre_msg *msg, __u64 transno);
 void lustre_msg_set_status(struct lustre_msg *msg, __u32 status);
diff --git a/drivers/staging/lustre/lustre/include/lustre_ver.h b/drivers/staging/lustre/lustre/include/lustre_ver.h
index dc187b8..caa4da1 100644
--- a/drivers/staging/lustre/lustre/include/lustre_ver.h
+++ b/drivers/staging/lustre/lustre/include/lustre_ver.h
@@ -10,7 +10,9 @@
 #define LUSTRE_FIX 0
 #define LUSTRE_VERSION_STRING "2.3.64"
 
-#define LUSTRE_VERSION_CODE OBD_OCD_VERSION(LUSTRE_MAJOR,LUSTRE_MINOR,LUSTRE_PATCH,LUSTRE_FIX)
+#define LUSTRE_VERSION_CODE OBD_OCD_VERSION(LUSTRE_MAJOR, \
+					    LUSTRE_MINOR, LUSTRE_PATCH, \
+					    LUSTRE_FIX)
 
 /* liblustre clients are only allowed to connect if their LUSTRE_FIX mismatches
  * by this amount (set in lustre/autoconf/lustre-version.ac). */
diff --git a/drivers/staging/lustre/lustre/include/obd.h b/drivers/staging/lustre/lustre/include/obd.h
index 808cb0e..d7a982a 100644
--- a/drivers/staging/lustre/lustre/include/obd.h
+++ b/drivers/staging/lustre/lustre/include/obd.h
@@ -212,7 +212,7 @@ static inline int lov_lum_swab_if_needed(struct lov_user_md_v3 *lumv3,
 					 int *lmm_magic,
 					 struct lov_user_md *lum)
 {
-	if (lum && copy_from_user(lumv3, lum,sizeof(struct lov_user_md_v1)))
+	if (lum && copy_from_user(lumv3, lum, sizeof(struct lov_user_md_v1)))
 		return -EFAULT;
 
 	*lmm_magic = lumv3->lmm_magic;
@@ -745,7 +745,8 @@ static inline void oti_init(struct obd_trans_info *oti,
 		oti->oti_conn_cnt = lustre_msg_get_conn_cnt(req->rq_reqmsg);
 }
 
-static inline void oti_alloc_cookies(struct obd_trans_info *oti,int num_cookies)
+static inline void oti_alloc_cookies(struct obd_trans_info *oti,
+				     int num_cookies)
 {
 	if (!oti)
 		return;
@@ -1183,7 +1184,8 @@ struct obd_ops {
 			      __u64 max_age, struct ptlrpc_request_set *set);
 	int (*o_packmd)(struct obd_export *exp, struct lov_mds_md **disk_tgt,
 			struct lov_stripe_md *mem_src);
-	int (*o_unpackmd)(struct obd_export *exp,struct lov_stripe_md **mem_tgt,
+	int (*o_unpackmd)(struct obd_export *exp,
+			  struct lov_stripe_md **mem_tgt,
 			  struct lov_mds_md *disk_src, int disk_len);
 	int (*o_preallocate)(struct lustre_handle *, u32 *req, u64 *ids);
 	/* FIXME: add fid capability support for create & destroy! */
diff --git a/drivers/staging/lustre/lustre/include/obd_class.h b/drivers/staging/lustre/lustre/include/obd_class.h
index 3597226..f77e63d 100644
--- a/drivers/staging/lustre/lustre/include/obd_class.h
+++ b/drivers/staging/lustre/lustre/include/obd_class.h
@@ -943,7 +943,7 @@ static inline struct obd_uuid *obd_get_uuid(struct obd_export *exp)
  *    by obd are returned.
  */
 static inline int obd_connect(const struct lu_env *env,
-			      struct obd_export **exp,struct obd_device *obd,
+			      struct obd_export **exp, struct obd_device *obd,
 			      struct obd_uuid *cluuid,
 			      struct obd_connect_data *data,
 			      void *localdata)
@@ -1165,7 +1165,8 @@ static inline int obd_statfs_async(struct obd_export *exp,
 	if (cfs_time_before_64(obd->obd_osfs_age, max_age)) {
 		rc = OBP(obd, statfs_async)(exp, oinfo, max_age, rqset);
 	} else {
-		CDEBUG(D_SUPER,"%s: use %p cache blocks %llu/%llu objects %llu/%llu\n",
+		CDEBUG(D_SUPER,
+		       "%s: use %p cache blocks %llu/%llu objects %llu/%llu\n",
 		       obd->obd_name, &obd->obd_osfs,
 		       obd->obd_osfs.os_bavail, obd->obd_osfs.os_blocks,
 		       obd->obd_osfs.os_ffree, obd->obd_osfs.os_files);
diff --git a/drivers/staging/lustre/lustre/include/obd_support.h b/drivers/staging/lustre/lustre/include/obd_support.h
index 874606a..b9bfc42 100644
--- a/drivers/staging/lustre/lustre/include/obd_support.h
+++ b/drivers/staging/lustre/lustre/include/obd_support.h
@@ -127,12 +127,12 @@ int obd_alloc_fail(const void *ptr, const char *name, const char *type,
  /* Max connect interval for nonresponsive servers; ~50s to avoid building up
     connect requests in the LND queues, but within obd_timeout so we don't
     miss the recovery window */
-#define CONNECTION_SWITCH_MAX min(50U, max(CONNECTION_SWITCH_MIN,obd_timeout))
+#define CONNECTION_SWITCH_MAX min(50U, max(CONNECTION_SWITCH_MIN, obd_timeout))
 #define CONNECTION_SWITCH_INC 5  /* Connection timeout backoff */
 /* In general this should be low to have quick detection of a system
    running on a backup server. (If it's too low, import_select_connection
    will increase the timeout anyhow.)  */
-#define INITIAL_CONNECT_TIMEOUT max(CONNECTION_SWITCH_MIN,obd_timeout/20)
+#define INITIAL_CONNECT_TIMEOUT max(CONNECTION_SWITCH_MIN, obd_timeout/20)
 /* The max delay between connects is SWITCH_MAX + SWITCH_INC + INITIAL */
 #define RECONNECT_DELAY_MAX (CONNECTION_SWITCH_MAX + CONNECTION_SWITCH_INC + \
 			     INITIAL_CONNECT_TIMEOUT)
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
index 3143222..699c6cd 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
@@ -970,7 +970,8 @@ static void search_granted_lock(struct list_head *queue,
 			prev->policy_link = &req->l_sl_policy;
 			return;
 		} else {
-			LDLM_ERROR(lock,"is not LDLM_PLAIN or LDLM_IBITS lock");
+			LDLM_ERROR(lock,
+				   "is not LDLM_PLAIN or LDLM_IBITS lock");
 			LBUG();
 		}
 	}
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_request.c b/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
index 37b8608..91f581e 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
@@ -510,7 +510,7 @@ static void failed_lock_cleanup(struct ldlm_namespace *ns,
 int ldlm_cli_enqueue_fini(struct obd_export *exp, struct ptlrpc_request *req,
 			  ldlm_type_t type, __u8 with_policy, ldlm_mode_t mode,
 			  __u64 *flags, void *lvb, __u32 lvb_len,
-			  struct lustre_handle *lockh,int rc)
+			  struct lustre_handle *lockh, int rc)
 {
 	struct ldlm_namespace *ns = exp->exp_obd->obd_namespace;
 	int is_replay = *flags & LDLM_FL_REPLAY;
@@ -629,7 +629,8 @@ int ldlm_cli_enqueue_fini(struct obd_export *exp, struct ptlrpc_request *req,
 						&reply->lock_desc.l_policy_data,
 						&lock->l_policy_data);
 		if (type != LDLM_PLAIN)
-			LDLM_DEBUG(lock,"client-side enqueue, new policy data");
+			LDLM_DEBUG(lock,
+				   "client-side enqueue, new policy data");
 	}
 
 	if ((*flags) & LDLM_FL_AST_SENT ||
diff --git a/drivers/staging/lustre/lustre/libcfs/debug.c b/drivers/staging/lustre/lustre/libcfs/debug.c
index 5a5b7fc..48c5d55 100644
--- a/drivers/staging/lustre/lustre/libcfs/debug.c
+++ b/drivers/staging/lustre/lustre/libcfs/debug.c
@@ -441,9 +441,11 @@ int libcfs_debug_clear_buffer(void)
 #define DEBUG_SUBSYSTEM S_UNDEFINED
 int libcfs_debug_mark_buffer(const char *text)
 {
-	CDEBUG(D_TRACE,"***************************************************\n");
+	CDEBUG(D_TRACE,
+	       "***************************************************\n");
 	LCONSOLE(D_WARNING, "DEBUG MARKER: %s\n", text);
-	CDEBUG(D_TRACE,"***************************************************\n");
+	CDEBUG(D_TRACE,
+	       "***************************************************\n");
 
 	return 0;
 }
diff --git a/drivers/staging/lustre/lustre/libcfs/hash.c b/drivers/staging/lustre/lustre/libcfs/hash.c
index 8ef1deb..ec933cc 100644
--- a/drivers/staging/lustre/lustre/libcfs/hash.c
+++ b/drivers/staging/lustre/lustre/libcfs/hash.c
@@ -2098,7 +2098,8 @@ int cfs_hash_debug_str(struct cfs_hash *hs, struct seq_file *m)
 			maxdepb = ffz(~maxdep);
 		}
 		total += bd.bd_bucket->hsb_count;
-		dist[min(__cfs_fls(bd.bd_bucket->hsb_count/max(theta,1)),7)]++;
+		dist[min(__cfs_fls(bd.bd_bucket->hsb_count/max(theta,
+							       1)), 7)]++;
 		cfs_hash_bd_unlock(hs, &bd, 0);
 	}
 
diff --git a/drivers/staging/lustre/lustre/libcfs/module.c b/drivers/staging/lustre/lustre/libcfs/module.c
index 3396858..6b9b1d2 100644
--- a/drivers/staging/lustre/lustre/libcfs/module.c
+++ b/drivers/staging/lustre/lustre/libcfs/module.c
@@ -217,7 +217,7 @@ int libcfs_deregister_ioctl(struct libcfs_ioctl_handler *hand)
 }
 EXPORT_SYMBOL(libcfs_deregister_ioctl);
 
-static int libcfs_ioctl_int(struct cfs_psdev_file *pfile,unsigned long cmd,
+static int libcfs_ioctl_int(struct cfs_psdev_file *pfile, unsigned long cmd,
 			    void *arg, struct libcfs_ioctl_data *data)
 {
 	int err = -EINVAL;
diff --git a/drivers/staging/lustre/lustre/libcfs/upcall_cache.c b/drivers/staging/lustre/lustre/libcfs/upcall_cache.c
index 88af820..0e95588 100644
--- a/drivers/staging/lustre/lustre/libcfs/upcall_cache.c
+++ b/drivers/staging/lustre/lustre/libcfs/upcall_cache.c
@@ -316,7 +316,7 @@ int upcall_cache_downcall(struct upcall_cache *cache, __u32 err, __u64 key,
 	}
 
 	if (!UC_CACHE_IS_ACQUIRING(entry)) {
-		CDEBUG(D_RPCTRACE,"%s: found uptodate entry %p (key %llu)\n",
+		CDEBUG(D_RPCTRACE, "%s: found uptodate entry %p (key %llu)\n",
 		       cache->uc_name, entry, entry->ue_key);
 		GOTO(out, rc = 0);
 	}
diff --git a/drivers/staging/lustre/lustre/llite/dir.c b/drivers/staging/lustre/lustre/llite/dir.c
index de5892c..3e504ba 100644
--- a/drivers/staging/lustre/lustre/llite/dir.c
+++ b/drivers/staging/lustre/lustre/llite/dir.c
@@ -1721,7 +1721,7 @@ out_quotactl_18:
 
 		rc = quotactl_ioctl(sbi, qctl);
 
-		if (rc == 0 && copy_to_user((void *)arg,qctl,sizeof(*qctl)))
+		if (rc == 0 && copy_to_user((void *)arg, qctl, sizeof(*qctl)))
 			rc = -EFAULT;
 
 out_quotactl:
diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
index acfb078..dc63979 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -652,7 +652,7 @@ static inline struct inode *ll_info2i(struct ll_inode_info *lli)
 }
 
 __u32 ll_i2suppgid(struct inode *i);
-void ll_i2gids(__u32 *suppgids, struct inode *i1,struct inode *i2);
+void ll_i2gids(__u32 *suppgids, struct inode *i1, struct inode *i2);
 
 static inline int ll_need_32bit_api(struct ll_sb_info *sbi)
 {
diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index ff375d3..f05a450 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -1377,7 +1377,7 @@ int ll_setattr_raw(struct dentry *dentry, struct iattr *attr, bool hsm_import)
 		 * OST maximum object size and number of stripes.  This
 		 * needs another check in addition to the VFS check above. */
 		if (attr->ia_size > ll_file_maxbytes(inode)) {
-			CDEBUG(D_INODE,"file "DFID" too large %llu > %llu\n",
+			CDEBUG(D_INODE, "file "DFID" too large %llu > %llu\n",
 			       PFID(&lli->lli_fid), attr->ia_size,
 			       ll_file_maxbytes(inode));
 			return -EFBIG;
@@ -1568,7 +1568,8 @@ int ll_statfs_internal(struct super_block *sb, struct obd_statfs *osfs,
 	osfs->os_type = sb->s_magic;
 
 	CDEBUG(D_SUPER, "MDC blocks %llu/%llu objects %llu/%llu\n",
-	       osfs->os_bavail, osfs->os_blocks, osfs->os_ffree,osfs->os_files);
+	       osfs->os_bavail, osfs->os_blocks, osfs->os_ffree,
+	       osfs->os_files);
 
 	if (sbi->ll_flags & LL_SBI_LAZYSTATFS)
 		flags |= OBD_STATFS_NODELAY;
diff --git a/drivers/staging/lustre/lustre/llite/lproc_llite.c b/drivers/staging/lustre/lustre/llite/lproc_llite.c
index 77f68b5..f07d9ebf 100644
--- a/drivers/staging/lustre/lustre/llite/lproc_llite.c
+++ b/drivers/staging/lustre/lustre/llite/lproc_llite.c
@@ -1098,7 +1098,7 @@ void lprocfs_unregister_mountpoint(struct ll_sb_info *sbi)
 }
 #undef MAX_STRING_SIZE
 
-#define pct(a,b) (b ? a * 100 / b : 0)
+#define pct(a, b) (b ? a * 100 / b : 0)
 
 static void ll_display_extents_info(struct ll_rw_extents_info *io_extents,
 				   struct seq_file *seq, int which)
diff --git a/drivers/staging/lustre/lustre/llite/namei.c b/drivers/staging/lustre/lustre/llite/namei.c
index 0dc7173..08c7456 100644
--- a/drivers/staging/lustre/lustre/llite/namei.c
+++ b/drivers/staging/lustre/lustre/llite/namei.c
@@ -1137,7 +1137,8 @@ static int ll_rename_generic(struct inode *src, struct dentry *src_dparent,
 	struct md_op_data *op_data;
 	int err;
 
-	CDEBUG(D_VFSTRACE,"VFS Op:oldname=%.*s,src_dir=%lu/%u(%p),newname=%.*s,"
+	CDEBUG(D_VFSTRACE,
+	       "VFS Op:oldname=%.*s,src_dir=%lu/%u(%p),newname=%.*s,"
 	       "tgt_dir=%lu/%u(%p)\n", src_name->len, src_name->name,
 	       src->i_ino, src->i_generation, src, tgt_name->len,
 	       tgt_name->name, tgt->i_ino, tgt->i_generation, tgt);
diff --git a/drivers/staging/lustre/lustre/llite/rw26.c b/drivers/staging/lustre/lustre/llite/rw26.c
index 3f157e7..4384859 100644
--- a/drivers/staging/lustre/lustre/llite/rw26.c
+++ b/drivers/staging/lustre/lustre/llite/rw26.c
@@ -436,7 +436,7 @@ static ssize_t ll_direct_IO_26(int rw, struct kiocb *iocb,
 				size = ((((size / 2) - 1) |
 					 ~CFS_PAGE_MASK) + 1) &
 					CFS_PAGE_MASK;
-				CDEBUG(D_VFSTRACE,"DIO size now %lu\n",
+				CDEBUG(D_VFSTRACE, "DIO size now %lu\n",
 				       size);
 				continue;
 			}
diff --git a/drivers/staging/lustre/lustre/llite/statahead.c b/drivers/staging/lustre/lustre/llite/statahead.c
index c39cf8d..bb91b93 100644
--- a/drivers/staging/lustre/lustre/llite/statahead.c
+++ b/drivers/staging/lustre/lustre/llite/statahead.c
@@ -528,7 +528,7 @@ static void ll_sai_put(struct ll_statahead_info *sai)
 		spin_unlock(&lli->lli_sa_lock);
 
 		if (sai->sai_sent > sai->sai_replied)
-			CDEBUG(D_READA,"statahead for dir "DFID
+			CDEBUG(D_READA, "statahead for dir "DFID
 			      " does not finish: [sent:%llu] [replied:%llu]\n",
 			      PFID(&lli->lli_fid),
 			      sai->sai_sent, sai->sai_replied);
@@ -878,7 +878,8 @@ static int do_sa_revalidate(struct inode *dir, struct ll_sa_entry *entry,
 		return 1;
 
 	entry->se_inode = igrab(inode);
-	rc = md_revalidate_lock(ll_i2mdexp(dir), &it, ll_inode2fid(inode),NULL);
+	rc = md_revalidate_lock(ll_i2mdexp(dir), &it, ll_inode2fid(inode),
+				NULL);
 	if (rc == 1) {
 		entry->se_handle = it.d.lustre.it_lock_handle;
 		ll_intent_release(&it);
diff --git a/drivers/staging/lustre/lustre/llite/vvp_dev.c b/drivers/staging/lustre/lustre/llite/vvp_dev.c
index 0f2e79d..eec5d38 100644
--- a/drivers/staging/lustre/lustre/llite/vvp_dev.c
+++ b/drivers/staging/lustre/lustre/llite/vvp_dev.c
@@ -405,7 +405,7 @@ static void vvp_pgcache_page_show(const struct lu_env *env,
 
 	cpg = cl2ccc_page(cl_page_at(page, &vvp_device_type));
 	vmpage = cpg->cpg_page;
-	seq_printf(seq," %5i | %p %p %s %s %s %s | %p %lu/%u(%p) %lu %u [",
+	seq_printf(seq, " %5i | %p %p %s %s %s %s | %p %lu/%u(%p) %lu %u [",
 		   0 /* gen */,
 		   cpg, page,
 		   "none",
diff --git a/drivers/staging/lustre/lustre/llite/vvp_io.c b/drivers/staging/lustre/lustre/llite/vvp_io.c
index fd24874..5c30499 100644
--- a/drivers/staging/lustre/lustre/llite/vvp_io.c
+++ b/drivers/staging/lustre/lustre/llite/vvp_io.c
@@ -721,7 +721,7 @@ static int vvp_io_fault_start(const struct lu_env *env,
 			CDEBUG(D_PAGE,
 				"llite: mkwrite and truncate race happened: "
 				"%p: 0x%lx 0x%lx\n",
-				vmpage->mapping,fio->ft_index,last_index);
+				vmpage->mapping, fio->ft_index, last_index);
 			/*
 			 * We need to return if we are
 			 * passed the end of the file. This will propagate
diff --git a/drivers/staging/lustre/lustre/lmv/lmv_obd.c b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
index a48818a..187ffe3 100644
--- a/drivers/staging/lustre/lustre/lmv/lmv_obd.c
+++ b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
@@ -1802,7 +1802,7 @@ lmv_enqueue(struct obd_export *exp, struct ldlm_enqueue_info *einfo,
 }
 
 static int
-lmv_getattr_name(struct obd_export *exp,struct md_op_data *op_data,
+lmv_getattr_name(struct obd_export *exp, struct md_op_data *op_data,
 		 struct ptlrpc_request **request)
 {
 	struct ptlrpc_request   *req = NULL;
diff --git a/drivers/staging/lustre/lustre/lov/lov_pack.c b/drivers/staging/lustre/lustre/lov/lov_pack.c
index 20e5870..62ea223 100644
--- a/drivers/staging/lustre/lustre/lov/lov_pack.c
+++ b/drivers/staging/lustre/lustre/lov/lov_pack.c
@@ -95,7 +95,7 @@ void lov_dump_lmm_v1(int level, struct lov_mds_md_v1 *lmm)
 void lov_dump_lmm_v3(int level, struct lov_mds_md_v3 *lmm)
 {
 	lov_dump_lmm_common(level, lmm);
-	CDEBUG(level,"pool_name "LOV_POOLNAMEF"\n", lmm->lmm_pool_name);
+	CDEBUG(level, "pool_name "LOV_POOLNAMEF"\n", lmm->lmm_pool_name);
 	lov_dump_lmm_objects(level, lmm->lmm_objects,
 			     le16_to_cpu(lmm->lmm_stripe_count));
 }
diff --git a/drivers/staging/lustre/lustre/lov/lov_request.c b/drivers/staging/lustre/lustre/lov/lov_request.c
index 174a5fe..d00ab79 100644
--- a/drivers/staging/lustre/lustre/lov/lov_request.c
+++ b/drivers/staging/lustre/lustre/lov/lov_request.c
@@ -1315,7 +1315,8 @@ out_set:
 			(tot) += (add);				 \
 	} while (0)
 
-int lov_fini_statfs(struct obd_device *obd, struct obd_statfs *osfs,int success)
+int lov_fini_statfs(struct obd_device *obd, struct obd_statfs *osfs,
+		    int success)
 {
 	if (success) {
 		__u32 expected_stripes = lov_get_stripecnt(&obd->u.lov,
diff --git a/drivers/staging/lustre/lustre/obdclass/genops.c b/drivers/staging/lustre/lustre/obdclass/genops.c
index 504c59a..c2e561d 100644
--- a/drivers/staging/lustre/lustre/obdclass/genops.c
+++ b/drivers/staging/lustre/lustre/obdclass/genops.c
@@ -1425,7 +1425,8 @@ int obd_export_evict_by_nid(struct obd_device *obd, const char *nid)
 	cfs_hash_putref(nid_hash);
 
 	if (!exports_evicted)
-		CDEBUG(D_HA,"%s: can't disconnect NID '%s': no exports found\n",
+		CDEBUG(D_HA,
+		       "%s: can't disconnect NID '%s': no exports found\n",
 		       obd->obd_name, nid);
 	return exports_evicted;
 }
diff --git a/drivers/staging/lustre/lustre/obdclass/llog_cat.c b/drivers/staging/lustre/lustre/obdclass/llog_cat.c
index ca9927c..a7c75e2 100644
--- a/drivers/staging/lustre/lustre/obdclass/llog_cat.c
+++ b/drivers/staging/lustre/lustre/obdclass/llog_cat.c
@@ -114,7 +114,8 @@ static int llog_cat_new_log(const struct lu_env *env,
 	cathandle->lgh_last_idx = index;
 	llh->llh_tail.lrt_index = index;
 
-	CDEBUG(D_RPCTRACE,"new recovery log "DOSTID":%x for index %u of catalog"
+	CDEBUG(D_RPCTRACE,
+	       "new recovery log "DOSTID":%x for index %u of catalog"
 	       DOSTID"\n", POSTID(&loghandle->lgh_id.lgl_oi),
 	       loghandle->lgh_id.lgl_ogen, index,
 	       POSTID(&cathandle->lgh_id.lgl_oi));
diff --git a/drivers/staging/lustre/lustre/obdclass/llog_lvfs.c b/drivers/staging/lustre/lustre/obdclass/llog_lvfs.c
index fd48d59..f6632db 100644
--- a/drivers/staging/lustre/lustre/obdclass/llog_lvfs.c
+++ b/drivers/staging/lustre/lustre/obdclass/llog_lvfs.c
@@ -78,7 +78,8 @@ static int llog_lvfs_pad(struct obd_device *obd, struct file *file, int len,
 	}
 
 	file->f_pos += len - sizeof(rec) - sizeof(tail);
-	rc = fsfilt_write_record(obd, file, &tail, sizeof(tail),&file->f_pos,0);
+	rc = fsfilt_write_record(obd, file, &tail, sizeof(tail),
+				 &file->f_pos, 0);
 	if (rc) {
 		CERROR("error writing padding record: rc %d\n", rc);
 		goto out;
@@ -102,7 +103,8 @@ static int llog_lvfs_write_blob(struct obd_device *obd, struct file *file,
 		CWARN("0-length record\n");
 
 	if (!buf) {
-		rc = fsfilt_write_record(obd, file, rec, buflen,&file->f_pos,0);
+		rc = fsfilt_write_record(obd, file, rec, buflen,
+					 &file->f_pos, 0);
 		if (rc) {
 			CERROR("error writing log record: rc %d\n", rc);
 			goto out;
diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
index 8309d4c..fe6d686 100644
--- a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
+++ b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
@@ -947,7 +947,8 @@ int lprocfs_obd_setup(struct obd_device *obd, struct lprocfs_vars *list)
 					       list, obd);
 	if (IS_ERR(obd->obd_proc_entry)) {
 		rc = PTR_ERR(obd->obd_proc_entry);
-		CERROR("error %d setting up lprocfs for %s\n",rc,obd->obd_name);
+		CERROR("error %d setting up lprocfs for %s\n",
+		       rc, obd->obd_name);
 		obd->obd_proc_entry = NULL;
 	}
 	return rc;
@@ -1593,7 +1594,7 @@ static int lprocfs_nid_stats_clear_write_cb(void *obj, void *data)
 {
 	struct nid_stat *stat = obj;
 
-	CDEBUG(D_INFO,"refcnt %d\n", atomic_read(&stat->nid_exp_ref_count));
+	CDEBUG(D_INFO, "refcnt %d\n", atomic_read(&stat->nid_exp_ref_count));
 	if (atomic_read(&stat->nid_exp_ref_count) == 1) {
 		/* object has only hash references. */
 		spin_lock(&stat->nid_obd->obd_nid_lock);
@@ -1783,7 +1784,8 @@ int lprocfs_seq_read_frac_helper(struct seq_file *m, long val, int mult)
 }
 EXPORT_SYMBOL(lprocfs_seq_read_frac_helper);
 
-int lprocfs_write_u64_helper(const char *buffer, unsigned long count,__u64 *val)
+int lprocfs_write_u64_helper(const char *buffer, unsigned long count,
+			     __u64 *val)
 {
 	return lprocfs_write_frac_u64_helper(buffer, count, val, 1);
 }
diff --git a/drivers/staging/lustre/lustre/obdclass/obd_mount.c b/drivers/staging/lustre/lustre/obdclass/obd_mount.c
index d972f71..9833863 100644
--- a/drivers/staging/lustre/lustre/obdclass/obd_mount.c
+++ b/drivers/staging/lustre/lustre/obdclass/obd_mount.c
@@ -318,7 +318,8 @@ int lustre_start_mgc(struct super_block *sb)
 		   (using its local copy of the log), but we do want to connect
 		   if at all possible. */
 		recov_bk++;
-		CDEBUG(D_MOUNT, "%s: Set MGC reconnect %d\n", mgcname,recov_bk);
+		CDEBUG(D_MOUNT, "%s: Set MGC reconnect %d\n", mgcname,
+		       recov_bk);
 		rc = obd_set_info_async(NULL, obd->obd_self_export,
 					sizeof(KEY_INIT_RECOV_BACKUP),
 					KEY_INIT_RECOV_BACKUP,
diff --git a/drivers/staging/lustre/lustre/osc/lproc_osc.c b/drivers/staging/lustre/lustre/osc/lproc_osc.c
index ad2777f..9f719bc 100644
--- a/drivers/staging/lustre/lustre/osc/lproc_osc.c
+++ b/drivers/staging/lustre/lustre/osc/lproc_osc.c
@@ -565,7 +565,7 @@ static struct lprocfs_vars lprocfs_osc_module_vars[] = {
 	{ NULL }
 };
 
-#define pct(a,b) (b ? a * 100 / b : 0)
+#define pct(a, b) (b ? a * 100 / b : 0)
 
 static int osc_rpc_stats_seq_show(struct seq_file *seq, void *v)
 {
diff --git a/drivers/staging/lustre/lustre/osc/osc_internal.h b/drivers/staging/lustre/lustre/osc/osc_internal.h
index 0f182da..d788dac 100644
--- a/drivers/staging/lustre/lustre/osc/osc_internal.h
+++ b/drivers/staging/lustre/lustre/osc/osc_internal.h
@@ -161,7 +161,7 @@ static inline unsigned long rpcs_in_flight(struct client_obd *cli)
 }
 
 #ifndef min_t
-#define min_t(type,x,y) \
+#define min_t(type, x, y) \
 	({ type __x = (x); type __y = (y); __x < __y ? __x: __y; })
 #endif
 
diff --git a/drivers/staging/lustre/lustre/osc/osc_request.c b/drivers/staging/lustre/lustre/osc/osc_request.c
index c502f34..5e088f5 100644
--- a/drivers/staging/lustre/lustre/osc/osc_request.c
+++ b/drivers/staging/lustre/lustre/osc/osc_request.c
@@ -836,7 +836,7 @@ static void osc_announce_cached(struct client_obd *cli, struct obdo *oa,
 	oa->o_dropped = cli->cl_lost_grant;
 	cli->cl_lost_grant = 0;
 	client_obd_list_unlock(&cli->cl_loi_list_lock);
-	CDEBUG(D_CACHE,"dirty: %llu undirty: %u dropped %u grant: %llu\n",
+	CDEBUG(D_CACHE, "dirty: %llu undirty: %u dropped %u grant: %llu\n",
 	       oa->o_dirty, oa->o_undirty, oa->o_dropped, oa->o_grant);
 
 }
@@ -1218,7 +1218,8 @@ static u32 osc_checksum_bulk(int nob, u32 pg_count,
 	return cksum;
 }
 
-static int osc_brw_prep_request(int cmd, struct client_obd *cli,struct obdo *oa,
+static int osc_brw_prep_request(int cmd, struct client_obd *cli,
+				struct obdo *oa,
 				struct lov_stripe_md *lsm, u32 page_count,
 				struct brw_page **pga,
 				struct ptlrpc_request **reqp,
@@ -1523,7 +1524,8 @@ static int osc_brw_fini_request(struct ptlrpc_request *req, int rc)
 					 cksum_type_unpack(aa->aa_oa->o_flags)))
 			return -EAGAIN;
 
-		rc = check_write_rcs(req, aa->aa_requested_nob,aa->aa_nio_count,
+		rc = check_write_rcs(req, aa->aa_requested_nob,
+				     aa->aa_nio_count,
 				     aa->aa_page_count, aa->aa_ppga);
 		GOTO(out, rc);
 	}
@@ -2320,7 +2322,7 @@ static int osc_enqueue_fini(struct ptlrpc_request *req, struct ost_lvb *lvb,
 	if ((intent != 0 && rc == ELDLM_LOCK_ABORTED && agl == 0) ||
 	    (rc == 0)) {
 		*flags |= LDLM_FL_LVB_READY;
-		CDEBUG(D_INODE,"got kms %llu blocks %llu mtime %llu\n",
+		CDEBUG(D_INODE, "got kms %llu blocks %llu mtime %llu\n",
 		       lvb->lvb_size, lvb->lvb_blocks, lvb->lvb_mtime);
 	}
 
diff --git a/drivers/staging/lustre/lustre/ptlrpc/events.c b/drivers/staging/lustre/lustre/ptlrpc/events.c
index c3ec21d..b68157b 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/events.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/events.c
@@ -186,7 +186,8 @@ void client_bulk_callback(lnet_event_t *ev)
 	if (CFS_FAIL_CHECK_ORSET(OBD_FAIL_PTLRPC_CLIENT_BULK_CB, CFS_FAIL_ONCE))
 		ev->status = -EIO;
 
-	if (CFS_FAIL_CHECK_ORSET(OBD_FAIL_PTLRPC_CLIENT_BULK_CB2,CFS_FAIL_ONCE))
+	if (CFS_FAIL_CHECK_ORSET(OBD_FAIL_PTLRPC_CLIENT_BULK_CB2,
+				 CFS_FAIL_ONCE))
 		ev->status = -EIO;
 
 	CDEBUG((ev->status == 0) ? D_NET : D_ERROR,
@@ -481,7 +482,7 @@ int ptlrpc_uuid_to_peer(struct obd_uuid *uuid,
 		}
 	}
 
-	CDEBUG(D_NET,"%s->%s\n", uuid->uuid, libcfs_id2str(*peer));
+	CDEBUG(D_NET, "%s->%s\n", uuid->uuid, libcfs_id2str(*peer));
 	return rc;
 }
 
diff --git a/drivers/staging/lustre/lustre/ptlrpc/import.c b/drivers/staging/lustre/lustre/ptlrpc/import.c
index 771b213..cb4f07c 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/import.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/import.c
@@ -297,7 +297,8 @@ void ptlrpc_invalidate_import(struct obd_import *imp)
 			timeout = 1;
 		}
 
-		CDEBUG(D_RPCTRACE,"Sleeping %d sec for inflight to error out\n",
+		CDEBUG(D_RPCTRACE,
+		       "Sleeping %d sec for inflight to error out\n",
 		       timeout);
 
 		/* Wait for all requests to error out and call completion
@@ -843,7 +844,7 @@ static int ptlrpc_connect_interpret(const struct lu_env *env,
 	if ((ocd->ocd_connect_flags & imp->imp_connect_flags_orig) !=
 	    ocd->ocd_connect_flags) {
 		CERROR("%s: Server didn't granted asked subset of flags: asked=%#llx grranted=%#llx\n",
-		       imp->imp_obd->obd_name,imp->imp_connect_flags_orig,
+		       imp->imp_obd->obd_name, imp->imp_connect_flags_orig,
 		       ocd->ocd_connect_flags);
 		GOTO(out, rc = -EPROTO);
 	}
diff --git a/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c b/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
index bc22030..ace12e8 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
@@ -119,7 +119,7 @@ struct ll_rpc_opcode {
 	{ OBD_IDX_READ,	    "dt_index_read" },
 	{ LLOG_ORIGIN_HANDLE_CREATE,	 "llog_origin_handle_open" },
 	{ LLOG_ORIGIN_HANDLE_NEXT_BLOCK, "llog_origin_handle_next_block" },
-	{ LLOG_ORIGIN_HANDLE_READ_HEADER,"llog_origin_handle_read_header" },
+	{ LLOG_ORIGIN_HANDLE_READ_HEADER, "llog_origin_handle_read_header" },
 	{ LLOG_ORIGIN_HANDLE_WRITE_REC,  "llog_origin_handle_write_rec" },
 	{ LLOG_ORIGIN_HANDLE_CLOSE,      "llog_origin_handle_close" },
 	{ LLOG_ORIGIN_CONNECT,	   "llog_origin_connect" },
@@ -130,7 +130,7 @@ struct ll_rpc_opcode {
 	{ QUOTA_DQREL,      "quota_release" },
 	{ SEQ_QUERY,	"seq_query" },
 	{ SEC_CTX_INIT,     "sec_ctx_init" },
-	{ SEC_CTX_INIT_CONT,"sec_ctx_init_cont" },
+	{ SEC_CTX_INIT_CONT, "sec_ctx_init_cont" },
 	{ SEC_CTX_FINI,     "sec_ctx_fini" },
 	{ FLD_QUERY,	"fld_query" },
 	{ UPDATE_OBJ,	    "update_obj" },
@@ -194,7 +194,8 @@ void ptlrpc_lprocfs_register(struct proc_dir_entry *root, char *dir,
 	LASSERT(*procroot_ret == NULL);
 	LASSERT(*stats_ret == NULL);
 
-	svc_stats = lprocfs_alloc_stats(EXTRA_MAX_OPCODES+LUSTRE_MAX_OPCODES,0);
+	svc_stats = lprocfs_alloc_stats(EXTRA_MAX_OPCODES+LUSTRE_MAX_OPCODES,
+					0);
 	if (svc_stats == NULL)
 		return;
 
diff --git a/drivers/staging/lustre/lustre/ptlrpc/pinger.c b/drivers/staging/lustre/lustre/ptlrpc/pinger.c
index 5e4e49f..97fdc7f 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/pinger.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/pinger.c
@@ -281,7 +281,8 @@ static int ptlrpc_pinger_main(void *arg)
 		   ping will get sent 2 timeouts from now!  Beware. */
 		CDEBUG(D_INFO, "next wakeup in "CFS_DURATION_T" ("
 		       CFS_TIME_T")\n", time_to_next_wake,
-		       cfs_time_add(this_ping,cfs_time_seconds(PING_INTERVAL)));
+		       cfs_time_add(this_ping,
+				    cfs_time_seconds(PING_INTERVAL)));
 		if (time_to_next_wake > 0) {
 			lwi = LWI_TIMEOUT(max_t(long, time_to_next_wake,
 						cfs_time_seconds(1)),
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec_null.c b/drivers/staging/lustre/lustre/ptlrpc/sec_null.c
index a477914..099cec3 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec_null.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec_null.c
@@ -471,5 +471,6 @@ void sptlrpc_null_fini(void)
 
 	rc = sptlrpc_unregister_policy(&null_policy);
 	if (rc)
-		CERROR("failed to unregister %s: %d\n", null_policy.sp_name,rc);
+		CERROR("failed to unregister %s: %d\n",
+		       null_policy.sp_name, rc);
 }
diff --git a/drivers/staging/lustre/lustre/ptlrpc/service.c b/drivers/staging/lustre/lustre/ptlrpc/service.c
index c88eae27b..6c09d88 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/service.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/service.c
@@ -1896,7 +1896,8 @@ ptlrpc_server_handle_request(struct ptlrpc_service_part *svcpt,
 		libcfs_debug_dumplog();
 
 	do_gettimeofday(&work_start);
-	timediff = cfs_timeval_sub(&work_start, &request->rq_arrival_time,NULL);
+	timediff = cfs_timeval_sub(&work_start, &request->rq_arrival_time,
+				   NULL);
 	if (likely(svc->srv_stats != NULL)) {
 		lprocfs_counter_add(svc->srv_stats, PTLRPC_REQWAIT_CNTR,
 				    timediff);
-- 
1.9.1

