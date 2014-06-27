Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbaF0NOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 09:14:23 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:44303 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbaF0NOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 09:14:22 -0400
Date: Fri, 27 Jun 2014 16:14:16 +0300
From: Sami Laine <laine.j.sami@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, andreas.dilger@intel.com, bergwolf@gmail.com,
        green@linuxhacker.ru, jinshan.xiong@intel.com, john.hammond@intel.com,
        fabio.falzoi84@gmail.com, behlendorf1@llnl.gov,
        andrew_perepechko@xyratex.com, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: [PATCH next-20140627] drivers/staging/lustre/lustre/llite: sparse
 warning corrections
Message-ID: <20140627131415.GA17223@outside>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sami Laine <laine.j.sami@gmail.com>

Sparse warning corrections: NULL-pointers as NULL instead of static 0's.

Signed-off-by: Sami Laine <laine.j.sami@gmail.com>
---
diff --git a/drivers/staging/lustre/lustre/llite/lproc_llite.c b/drivers/staging/lustre/lustre/llite/lproc_llite.c
index 77ee9e5..d9c874c 100644
--- a/drivers/staging/lustre/lustre/llite/lproc_llite.c
+++ b/drivers/staging/lustre/lustre/llite/lproc_llite.c
@@ -811,37 +811,38 @@ static ssize_t ll_xattr_cache_seq_write(struct file *file, const char *buffer,
 LPROC_SEQ_FOPS(ll_xattr_cache);
 
 static struct lprocfs_vars lprocfs_llite_obd_vars[] = {
-	{ "uuid",	  &ll_sb_uuid_fops,	  0, 0 },
+	{ "uuid",	  &ll_sb_uuid_fops,	  NULL, 0 },
 	//{ "mntpt_path",   ll_rd_path,	     0, 0 },
-	{ "fstype",       &ll_fstype_fops,	  0, 0 },
-	{ "site",	  &ll_site_stats_fops,    0, 0 },
-	{ "blocksize",    &ll_blksize_fops,	  0, 0 },
-	{ "kbytestotal",  &ll_kbytestotal_fops,   0, 0 },
-	{ "kbytesfree",   &ll_kbytesfree_fops,    0, 0 },
-	{ "kbytesavail",  &ll_kbytesavail_fops,   0, 0 },
-	{ "filestotal",   &ll_filestotal_fops,    0, 0 },
-	{ "filesfree",    &ll_filesfree_fops,	  0, 0 },
-	{ "client_type",  &ll_client_type_fops,   0, 0 },
+	{ "fstype",       &ll_fstype_fops,	  NULL, 0 },
+	{ "site",	  &ll_site_stats_fops,    NULL, 0 },
+	{ "blocksize",    &ll_blksize_fops,	  NULL, 0 },
+	{ "kbytestotal",  &ll_kbytestotal_fops,   NULL, 0 },
+	{ "kbytesfree",   &ll_kbytesfree_fops,    NULL, 0 },
+	{ "kbytesavail",  &ll_kbytesavail_fops,   NULL, 0 },
+	{ "filestotal",   &ll_filestotal_fops,    NULL, 0 },
+	{ "filesfree",    &ll_filesfree_fops,	  NULL, 0 },
+	{ "client_type",  &ll_client_type_fops,   NULL, 0 },
 	//{ "filegroups",   lprocfs_rd_filegroups,  0, 0 },
-	{ "max_read_ahead_mb", &ll_max_readahead_mb_fops, 0 },
-	{ "max_read_ahead_per_file_mb", &ll_max_readahead_per_file_mb_fops, 0 },
-	{ "max_read_ahead_whole_mb", &ll_max_read_ahead_whole_mb_fops, 0 },
-	{ "max_cached_mb",    &ll_max_cached_mb_fops, 0 },
-	{ "checksum_pages",   &ll_checksum_fops, 0 },
-	{ "max_rw_chunk",     &ll_max_rw_chunk_fops, 0 },
-	{ "stats_track_pid",  &ll_track_pid_fops, 0 },
-	{ "stats_track_ppid", &ll_track_ppid_fops, 0 },
-	{ "stats_track_gid",  &ll_track_gid_fops, 0 },
-	{ "statahead_max",    &ll_statahead_max_fops, 0 },
-	{ "statahead_agl",    &ll_statahead_agl_fops, 0 },
-	{ "statahead_stats",  &ll_statahead_stats_fops, 0, 0 },
-	{ "lazystatfs",       &ll_lazystatfs_fops, 0 },
-	{ "max_easize",       &ll_max_easize_fops, 0, 0 },
-	{ "default_easize",   &ll_defult_easize_fops, 0, 0 },
-	{ "max_cookiesize",   &ll_max_cookiesize_fops, 0, 0 },
-	{ "default_cookiesize", &ll_defult_cookiesize_fops, 0, 0 },
-	{ "sbi_flags",	      &ll_sbi_flags_fops, 0, 0 },
-	{ "xattr_cache",      &ll_xattr_cache_fops, 0, 0 },
+	{ "max_read_ahead_mb", &ll_max_readahead_mb_fops, NULL },
+	{ "max_read_ahead_per_file_mb", &ll_max_readahead_per_file_mb_fops,
+		NULL },
+	{ "max_read_ahead_whole_mb", &ll_max_read_ahead_whole_mb_fops, NULL },
+	{ "max_cached_mb",    &ll_max_cached_mb_fops, NULL },
+	{ "checksum_pages",   &ll_checksum_fops, NULL },
+	{ "max_rw_chunk",     &ll_max_rw_chunk_fops, NULL },
+	{ "stats_track_pid",  &ll_track_pid_fops, NULL },
+	{ "stats_track_ppid", &ll_track_ppid_fops, NULL },
+	{ "stats_track_gid",  &ll_track_gid_fops, NULL },
+	{ "statahead_max",    &ll_statahead_max_fops, NULL },
+	{ "statahead_agl",    &ll_statahead_agl_fops, NULL },
+	{ "statahead_stats",  &ll_statahead_stats_fops, NULL, 0 },
+	{ "lazystatfs",       &ll_lazystatfs_fops, NULL },
+	{ "max_easize",       &ll_max_easize_fops, NULL, 0 },
+	{ "default_easize",   &ll_defult_easize_fops, NULL, 0 },
+	{ "max_cookiesize",   &ll_max_cookiesize_fops, NULL, 0 },
+	{ "default_cookiesize", &ll_defult_cookiesize_fops, NULL, 0 },
+	{ "sbi_flags",	      &ll_sbi_flags_fops, NULL, 0 },
+	{ "xattr_cache",      &ll_xattr_cache_fops, NULL, 0 },
 	{ 0 }
 };
 
