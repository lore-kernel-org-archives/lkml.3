Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016AbaIHWEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 18:04:48 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:56922 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbaIHWEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 18:04:47 -0400
Message-ID: <540E27FB.2070206@gmail.com>
Date: Tue, 09 Sep 2014 00:04:43 +0200
From: Hugues <morisset.hugues@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] staging: lustre: fix coding style issues
Content-Type: multipart/mixed;
 boundary="------------020408090604020601040904"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020408090604020601040904
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

Fix coding style issues:
* limit the length of changed lines to 80 columns.

--------------020408090604020601040904
Content-Type: text/x-patch;
 name="0001-staging-lustre-fix-coding-style-issues.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-staging-lustre-fix-coding-style-issues.patch"

>From a244d32aa34d0b13ac40dd014b88d0ff5ed10817 Mon Sep 17 00:00:00 2001
From: Hugues Morisset <morisset.hugues@gmail.com>
Date: Mon, 8 Sep 2014 21:23:28 +0200
Subject: [PATCH 1/4] staging: lustre: fix coding style issues

Signed-off-by: Hugues Morisset <morisset.hugues@gmail.com>
---
 drivers/staging/lustre/lustre/include/obd.h | 46 ++++++++++++++++-------------
 1 file changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/obd.h b/drivers/staging/lustre/lustre/include/obd.h
index 9f13878..b0afbb2 100644
--- a/drivers/staging/lustre/lustre/include/obd.h
+++ b/drivers/staging/lustre/lustre/include/obd.h
@@ -101,7 +101,8 @@ struct lov_stripe_md {
 		__u32 lw_magic;
 		__u32 lw_stripe_size;      /* size of the stripe */
 		__u32 lw_pattern;	  /* striping pattern (RAID0, RAID1) */
-		__u16 lw_stripe_count;  /* number of objects being striped over */
+		__u16 lw_stripe_count;
+			/* number of objects being striped over */
 		__u16 lw_layout_gen;       /* generation of the layout */
 		char  lw_pool_name[LOV_MAXPOOLNAME]; /* pool name */
 	} lsm_wire;
@@ -336,10 +337,10 @@ struct client_obd {
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
@@ -389,12 +390,12 @@ struct client_obd {
 
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
@@ -500,9 +501,9 @@ struct lov_statfs_data {
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
@@ -545,8 +546,8 @@ struct pool_desc {
 	struct hlist_node      pool_hash;	      /* access by poolname */
 	struct list_head	    pool_list;	      /* serial access */
 	struct proc_dir_entry *pool_proc_entry;	/* file in /proc */
-	struct obd_device    *pool_lobd;	      /* obd of the lov/lod to which
-						       * this pool belongs */
+	struct obd_device    *pool_lobd;      /* obd of the lov/lod to which
+					       * this pool belongs */
 };
 
 struct lov_obd {
@@ -564,7 +565,7 @@ struct lov_obd {
 	int		     lov_connects;
 	int		     lov_pool_count;
 	struct cfs_hash	     *lov_pools_hash_body; /* used for key access */
-	struct list_head	      lov_pool_list; /* used for sequential access */
+	struct list_head	lov_pool_list; /* used for sequential access */
 	struct proc_dir_entry   *lov_pool_proc_entry;
 	enum lustre_sec_part    lov_sp_me;
 
@@ -639,7 +640,8 @@ struct niobuf_local {
 #define LUSTRE_LWP_NAME		"lwp"
 
 /* obd device type names */
- /* FIXME all the references to LUSTRE_MDS_NAME should be swapped with LUSTRE_MDT_NAME */
+ /* FIXME all the references to LUSTRE_MDS_NAME
+    should be swapped with LUSTRE_MDT_NAME */
 #define LUSTRE_MDS_NAME	 "mds"
 #define LUSTRE_MDT_NAME	 "mdt"
 #define LUSTRE_MDC_NAME	 "mdc"
@@ -708,7 +710,7 @@ struct obd_trans_info {
 	unsigned long		 oti_sync_write:1;
 
 	/* initial thread handling transaction */
-	struct ptlrpc_thread *   oti_thread;
+	struct ptlrpc_thread *oti_thread;
 	__u32		    oti_conn_cnt;
 	/** VBR: versions */
 	__u64		    oti_pre_version;
@@ -733,6 +735,7 @@ static inline void oti_init(struct obd_trans_info *oti,
 	if (req->rq_reqmsg != NULL &&
 	    lustre_msg_get_flags(req->rq_reqmsg) & MSG_REPLAY) {
 		__u64 *pre_version = lustre_msg_get_versions(req->rq_reqmsg);
+
 		oti->oti_pre_version = pre_version ? pre_version[0] : 0;
 		oti->oti_transno = lustre_msg_get_transno(req->rq_reqmsg);
 	}
@@ -847,14 +850,15 @@ struct obd_device {
 		      obd_recovering:1,    /* there are recoverable clients */
 		      obd_abort_recovery:1,/* recovery expired */
 		      obd_version_recov:1, /* obd uses version checking */
-		      obd_replayable:1,    /* recovery is enabled; inform clients */
-		      obd_no_transno:1,    /* no committed-transno notification */
+		      obd_replayable:1,    /* recovery is enabled;
+					      inform clients */
+		      obd_no_transno:1,	/* no committed-transno notification */
 		      obd_no_recov:1,      /* fail instead of retry messages */
 		      obd_stopping:1,      /* started cleanup */
 		      obd_starting:1,      /* started setup */
 		      obd_force:1,	 /* cleanup with > 0 obd refcount */
 		      obd_fail:1,	  /* cleanup with failover */
-		      obd_async_recov:1,   /* allow asynchronous orphan cleanup */
+		      obd_async_recov:1, /* allow asynchronous orphan cleanup */
 		      obd_no_conn:1,       /* deny new connections */
 		      obd_inactive:1,      /* device active/inactive
 					   * (for /proc/status only!!) */
@@ -909,9 +913,9 @@ struct obd_device {
 	int			      obd_requests_queued_for_recovery;
 	wait_queue_head_t		      obd_next_transno_waitq;
 	/* protected by obd_recovery_task_lock */
-	struct timer_list	      obd_recovery_timer;
-	time_t			   obd_recovery_start; /* seconds */
-	time_t			   obd_recovery_end; /* seconds, for lprocfs_status */
+	struct timer_list	obd_recovery_timer;
+	time_t			obd_recovery_start; /* seconds */
+	time_t		obd_recovery_end; /* seconds, for lprocfs_status */
 	int			      obd_recovery_time_hard;
 	int			      obd_recovery_timeout;
 	int			      obd_recovery_ir_factor;
@@ -947,7 +951,7 @@ struct obd_device {
 	struct lprocfs_stats  *obd_svc_stats;
 	atomic_t	   obd_evict_inprogress;
 	wait_queue_head_t	    obd_evict_inprogress_waitq;
-	struct list_head	     obd_evict_list; /* protected with pet_lock */
+	struct list_head	obd_evict_list; /* protected with pet_lock */
 
 	/**
 	 * Ldlm pool part. Save last calculated SLV and Limit.
-- 
2.1.0



--------------020408090604020601040904--
