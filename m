Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157AbaFSH3L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 03:29:11 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:44360 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097AbaFSH3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 03:29:09 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: andreas.dilger@intel.com, oleg.drokin@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, hpdd-discuss@ml01.01.org,
        Anil Belur <askb23@gmail.com>
Subject: [PATCH 1/1] staging : lustre : lustre : fid : lproc_fid.c: fixed warning
Date: Thu, 19 Jun 2014 17:29:01 +1000
Message-Id: <1403162941-25159-1-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anil Belur <askb23@gmail.com>

fixed warning for line over 80 characters by moving the initilation
onto a diff line.

Signed-off-by: Anil Belur <askb23@gmail.com>
---
 drivers/staging/lustre/lustre/fid/lproc_fid.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/fid/lproc_fid.c b/drivers/staging/lustre/lustre/fid/lproc_fid.c
index 6f5674d..20078df 100644
--- a/drivers/staging/lustre/lustre/fid/lproc_fid.c
+++ b/drivers/staging/lustre/lustre/fid/lproc_fid.c
@@ -98,9 +98,10 @@ static ssize_t lprocfs_fid_space_seq_write(struct file *file,
 					   const char __user *buffer,
 					   size_t count, loff_t *off)
 {
-	struct lu_client_seq *seq = ((struct seq_file *)file->private_data)->private;
+	struct lu_client_seq *seq;
 	int rc;
 
+	seq = ((struct seq_file *)file->private_data)->private;
 	LASSERT(seq != NULL);
 
 	mutex_lock(&seq->lcs_mutex);
@@ -135,10 +136,11 @@ static ssize_t lprocfs_fid_width_seq_write(struct file *file,
 					   const char __user *buffer,
 					   size_t count, loff_t *off)
 {
-	struct lu_client_seq *seq = ((struct seq_file *)file->private_data)->private;
+	struct lu_client_seq *seq;
 	__u64  max;
 	int rc, val;
 
+	seq = ((struct seq_file *)file->private_data)->private;
 	LASSERT(seq != NULL);
 
 	rc = lprocfs_write_helper(buffer, count, &val);
-- 
1.9.0

