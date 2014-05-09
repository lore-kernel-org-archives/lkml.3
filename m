Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbaEIKuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:50:06 -0400
Received: from fallback8.mail.ru ([94.100.176.136]:41357 "EHLO
	fallback8.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbaEIKuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:50:04 -0400
From: Brilliantov Kirill Vladimirovich <brilliantov@inbox.ru>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>, Peng Tao <tao.peng@emc.com>,
        CCing hpdd-discuss <hpdd-discuss@ml01.01.org>,
        linux-kernel@vger.kernel.org,
        Brilliantov Kirill Vladimirovich <brilliantov@inbox.ru>
Subject: [PATCH] staging/lustre: fix sparse warning: Using plain integer as NULL pointer
Date: Fri,  9 May 2014 14:49:24 +0400
Message-Id: <1399632564-10263-1-git-send-email-brilliantov@inbox.ru>
X-Mailer: git-send-email 1.9.1
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Brilliantov Kirill Vladimirovich <brilliantov@inbox.ru>
---
 drivers/staging/lustre/lustre/osc/lproc_osc.c | 68 +++++++++++++--------------
 1 file changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/lustre/lustre/osc/lproc_osc.c b/drivers/staging/lustre/lustre/osc/lproc_osc.c
index 358e32c..0cadfcd 100644
--- a/drivers/staging/lustre/lustre/osc/lproc_osc.c
+++ b/drivers/staging/lustre/lustre/osc/lproc_osc.c
@@ -525,44 +525,44 @@ LPROC_SEQ_FOPS_RW_TYPE(osc, import);
 LPROC_SEQ_FOPS_RW_TYPE(osc, pinger_recov);
 
 static struct lprocfs_vars lprocfs_osc_obd_vars[] = {
-	{ "uuid",	     &osc_uuid_fops,	0, 0 },
-	{ "ping",	     &osc_ping_fops,    0, 0222 },
-	{ "connect_flags",   &osc_connect_flags_fops, 0, 0 },
-	{ "blocksize",       &osc_blksize_fops,     0, 0 },
-	{ "kbytestotal",     &osc_kbytestotal_fops, 0, 0 },
-	{ "kbytesfree",      &osc_kbytesfree_fops,  0, 0 },
-	{ "kbytesavail",     &osc_kbytesavail_fops, 0, 0 },
-	{ "filestotal",      &osc_filestotal_fops,  0, 0 },
-	{ "filesfree",       &osc_filesfree_fops,   0, 0 },
-	//{ "filegroups",      lprocfs_rd_filegroups,  0, 0 },
-	{ "ost_server_uuid", &osc_server_uuid_fops, 0, 0 },
-	{ "ost_conn_uuid",   &osc_conn_uuid_fops, 0, 0 },
-	{ "active",	     &osc_active_fops, 0 },
-	{ "max_pages_per_rpc", &osc_obd_max_pages_per_rpc_fops, 0 },
-	{ "max_rpcs_in_flight", &osc_max_rpcs_in_flight_fops, 0 },
-	{ "destroys_in_flight", &osc_destroys_in_flight_fops, 0, 0 },
-	{ "max_dirty_mb",    &osc_max_dirty_mb_fops, 0 },
-	{ "osc_cached_mb",   &osc_cached_mb_fops, 0 },
-	{ "cur_dirty_bytes", &osc_cur_dirty_bytes_fops, 0, 0 },
-	{ "cur_grant_bytes", &osc_cur_grant_bytes_fops, 0 },
-	{ "cur_lost_grant_bytes", &osc_cur_lost_grant_bytes_fops, 0, 0},
-	{ "grant_shrink_interval", &osc_grant_shrink_interval_fops, 0 },
-	{ "checksums",       &osc_checksum_fops, 0 },
-	{ "checksum_type",   &osc_checksum_type_fops, 0 },
-	{ "resend_count",    &osc_resend_count_fops, 0},
-	{ "timeouts",	     &osc_timeouts_fops, 0, 0 },
-	{ "contention_seconds", &osc_contention_seconds_fops, 0 },
-	{ "lockless_truncate",  &osc_lockless_truncate_fops, 0 },
-	{ "import",		&osc_import_fops, 0 },
-	{ "state",		&osc_state_fops, 0, 0 },
-	{ "pinger_recov",	&osc_pinger_recov_fops, 0 },
-	{ 0 }
+	{ "uuid",	     &osc_uuid_fops,	NULL, 0 },
+	{ "ping",	     &osc_ping_fops,    NULL, 0222 },
+	{ "connect_flags",   &osc_connect_flags_fops, NULL, 0 },
+	{ "blocksize",       &osc_blksize_fops,     NULL, 0 },
+	{ "kbytestotal",     &osc_kbytestotal_fops, NULL, 0 },
+	{ "kbytesfree",      &osc_kbytesfree_fops,  NULL, 0 },
+	{ "kbytesavail",     &osc_kbytesavail_fops, NULL, 0 },
+	{ "filestotal",      &osc_filestotal_fops,  NULL, 0 },
+	{ "filesfree",       &osc_filesfree_fops,   NULL, 0 },
+	/*{ "filegroups",      lprocfs_rd_filegroups,  NULL, 0 },*/
+	{ "ost_server_uuid", &osc_server_uuid_fops, NULL, 0 },
+	{ "ost_conn_uuid",   &osc_conn_uuid_fops, NULL, 0 },
+	{ "active",	     &osc_active_fops, NULL },
+	{ "max_pages_per_rpc", &osc_obd_max_pages_per_rpc_fops, NULL },
+	{ "max_rpcs_in_flight", &osc_max_rpcs_in_flight_fops, NULL },
+	{ "destroys_in_flight", &osc_destroys_in_flight_fops, NULL, 0 },
+	{ "max_dirty_mb",    &osc_max_dirty_mb_fops, NULL },
+	{ "osc_cached_mb",   &osc_cached_mb_fops, NULL },
+	{ "cur_dirty_bytes", &osc_cur_dirty_bytes_fops, NULL, 0 },
+	{ "cur_grant_bytes", &osc_cur_grant_bytes_fops, NULL },
+	{ "cur_lost_grant_bytes", &osc_cur_lost_grant_bytes_fops, NULL, 0},
+	{ "grant_shrink_interval", &osc_grant_shrink_interval_fops, NULL },
+	{ "checksums",       &osc_checksum_fops, NULL },
+	{ "checksum_type",   &osc_checksum_type_fops, NULL },
+	{ "resend_count",    &osc_resend_count_fops, NULL},
+	{ "timeouts",	     &osc_timeouts_fops, NULL, 0 },
+	{ "contention_seconds", &osc_contention_seconds_fops, NULL },
+	{ "lockless_truncate",  &osc_lockless_truncate_fops, NULL },
+	{ "import",		&osc_import_fops, NULL },
+	{ "state",		&osc_state_fops, NULL, 0 },
+	{ "pinger_recov",	&osc_pinger_recov_fops, NULL },
+	{ NULL }
 };
 
 LPROC_SEQ_FOPS_RO_TYPE(osc, numrefs);
 static struct lprocfs_vars lprocfs_osc_module_vars[] = {
-	{ "num_refs",	&osc_numrefs_fops,     0, 0 },
-	{ 0 }
+	{ "num_refs",	&osc_numrefs_fops,     NULL, 0 },
+	{ NULL }
 };
 
 #define pct(a,b) (b ? a * 100 / b : 0)
-- 
1.9.1

