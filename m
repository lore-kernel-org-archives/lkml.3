Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbaIIOhE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:37:04 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:57175 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746AbaIIOhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:37:00 -0400
From: Hugues Morisset <morisset.hugues@gmail.com>
X-Google-Original-From: Hugues Morisset <morisset.hugues@gamil.com>
To: oleg.drokin@intel.com, andreas.dilger@intel.com
Cc: gregkh@linuxfoundation.org, HPDD-discuss@ml01.01.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Hugues Morisset <morisset.hugues@gmail.com>
Subject: [PATCH 1/3] staging: lustre: fix coding style on long lines
Date: Tue,  9 Sep 2014 16:36:25 +0200
Message-Id: <1410273387-682902-2-git-send-email-morisset.hugues@gamil.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410273387-682902-1-git-send-email-morisset.hugues@gamil.com>
References: <1410273387-682902-1-git-send-email-morisset.hugues@gamil.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugues Morisset <morisset.hugues@gmail.com>

Signed-off-by: Hugues Morisset <morisset.hugues@gmail.com>
---
 drivers/staging/lustre/lustre/include/obd.h | 34 +++++++++++++++--------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/obd.h b/drivers/staging/lustre/lustre/include/obd.h
index 66fc457..db39d23 100644
--- a/drivers/staging/lustre/lustre/include/obd.h
+++ b/drivers/staging/lustre/lustre/include/obd.h
@@ -336,10 +336,10 @@ struct client_obd {
 	 * grant before trying to dirty a page and unreserve the rest.
 	 * See osc_{reserve|unreserve}_grant for details. */
 	long		 cl_reserved_grant;
-	struct list_head	   cl_cache_waiters; /* waiting for cache/grant */
-	unsigned long	   cl_next_shrink_grant;   /* jiffies */
-	struct list_head	   cl_grant_shrink_list;  /* Timeout event list */
-	int		  cl_grant_shrink_interval; /* seconds */
+	struct list_head cl_cache_waiters; /* waiting for cache/grant */
+	unsigned long	 cl_next_shrink_grant;   /* jiffies */
+	struct list_head cl_grant_shrink_list;  /* Timeout event list */
+	int		 cl_grant_shrink_interval; /* seconds */
 
 	/* A chunk is an optimal size used by osc_extent to determine
 	 * the extent size. A chunk is max(PAGE_CACHE_SIZE, OST block size) */
@@ -389,12 +389,12 @@ struct client_obd {
 
 	/* lru for osc caching pages */
 	struct cl_client_cache	*cl_cache;
-	struct list_head		 cl_lru_osc; /* member of cl_cache->ccc_lru */
+	struct list_head	 cl_lru_osc; /* member of cl_cache->ccc_lru */
 	atomic_t		*cl_lru_left;
 	atomic_t		 cl_lru_busy;
 	atomic_t		 cl_lru_shrinkers;
 	atomic_t		 cl_lru_in_list;
-	struct list_head		 cl_lru_list; /* lru page list */
+	struct list_head	 cl_lru_list; /* lru page list */
 	client_obd_lock_t	 cl_lru_list_lock; /* page list protector */
 
 	/* number of in flight destroy rpcs is limited to max_rpcs_in_flight */
@@ -500,9 +500,9 @@ struct lov_statfs_data {
 };
 /* Stripe placement optimization */
 struct lov_qos {
-	struct list_head	  lq_oss_list; /* list of OSSs that targets use */
+	struct list_head    lq_oss_list; /* list of OSSs that targets use */
 	struct rw_semaphore lq_rw_sem;
-	__u32	       lq_active_oss_count;
+	__u32		lq_active_oss_count;
 	unsigned int	lq_prio_free;   /* priority for free space */
 	unsigned int	lq_threshold_rr;/* priority for rr */
 	struct lov_qos_rr   lq_rr;	  /* round robin qos data */
@@ -545,8 +545,8 @@ struct pool_desc {
 	struct hlist_node      pool_hash;	      /* access by poolname */
 	struct list_head	    pool_list;	      /* serial access */
 	struct proc_dir_entry *pool_proc_entry;	/* file in /proc */
-	struct obd_device    *pool_lobd;	      /* obd of the lov/lod to which
-						       * this pool belongs */
+	struct obd_device    *pool_lobd;	/* obd of the lov/lod to which
+						*  this pool belongs */
 };
 
 struct lov_obd {
@@ -564,7 +564,7 @@ struct lov_obd {
 	int		     lov_connects;
 	int		     lov_pool_count;
 	struct cfs_hash	     *lov_pools_hash_body; /* used for key access */
-	struct list_head	      lov_pool_list; /* used for sequential access */
+	struct list_head	lov_pool_list; /* used for sequential access */
 	struct proc_dir_entry   *lov_pool_proc_entry;
 	enum lustre_sec_part    lov_sp_me;
 
@@ -708,7 +708,7 @@ struct obd_trans_info {
 	unsigned long		 oti_sync_write:1;
 
 	/* initial thread handling transaction */
-	struct ptlrpc_thread *   oti_thread;
+	struct ptlrpc_thread *oti_thread;
 	__u32		    oti_conn_cnt;
 	/** VBR: versions */
 	__u64		    oti_pre_version;
@@ -733,6 +733,7 @@ static inline void oti_init(struct obd_trans_info *oti,
 	if (req->rq_reqmsg != NULL &&
 	    lustre_msg_get_flags(req->rq_reqmsg) & MSG_REPLAY) {
 		__u64 *pre_version = lustre_msg_get_versions(req->rq_reqmsg);
+
 		oti->oti_pre_version = pre_version ? pre_version[0] : 0;
 		oti->oti_transno = lustre_msg_get_transno(req->rq_reqmsg);
 	}
@@ -909,9 +910,9 @@ struct obd_device {
 	int			      obd_requests_queued_for_recovery;
 	wait_queue_head_t		      obd_next_transno_waitq;
 	/* protected by obd_recovery_task_lock */
-	struct timer_list	      obd_recovery_timer;
-	time_t			   obd_recovery_start; /* seconds */
-	time_t			   obd_recovery_end; /* seconds, for lprocfs_status */
+	struct timer_list	obd_recovery_timer;
+	time_t			obd_recovery_start; /* seconds */
+	time_t			obd_recovery_end; /* seconds, for lprocfs_status */
 	int			      obd_recovery_time_hard;
 	int			      obd_recovery_timeout;
 	int			      obd_recovery_ir_factor;
@@ -947,7 +948,7 @@ struct obd_device {
 	struct lprocfs_stats  *obd_svc_stats;
 	atomic_t	   obd_evict_inprogress;
 	wait_queue_head_t	    obd_evict_inprogress_waitq;
-	struct list_head	     obd_evict_list; /* protected with pet_lock */
+	struct list_head	obd_evict_list; /* protected with pet_lock */
 
 	/**
 	 * Ldlm pool part. Save last calculated SLV and Limit.
@@ -1434,6 +1435,7 @@ static inline struct lustre_capa *oinfo_capa(struct obd_info *oinfo)
 static inline struct md_open_data *obd_mod_alloc(void)
 {
 	struct md_open_data *mod;
+
 	OBD_ALLOC_PTR(mod);
 	if (mod == NULL)
 		return NULL;
-- 
2.1.0

