Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbaFSLu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 07:50:58 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:59007 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757129AbaFSLu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 07:50:56 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: andreas.dilger@intel.com, oleg.drokin@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, hpdd-discuss@ml01.01.org,
        Anil Belur <askb23@gmail.com>
Subject: [PATCH 1/2] staging: lustre: lustre: fld: lproc_fld.c fixed warning
Date: Thu, 19 Jun 2014 21:50:41 +1000
Message-Id: <1403178642-6984-1-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anil Belur <askb23@gmail.com>

fixed warning for line over 80 characters by moving the struct init
onto a diff line.

Signed-off-by: Anil Belur <askb23@gmail.com>
---
 drivers/staging/lustre/lustre/fld/lproc_fld.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/fld/lproc_fld.c b/drivers/staging/lustre/lustre/fld/lproc_fld.c
index b6fff2e..01380b6 100644
--- a/drivers/staging/lustre/lustre/fld/lproc_fld.c
+++ b/drivers/staging/lustre/lustre/fld/lproc_fld.c
@@ -91,10 +91,11 @@ static ssize_t
 fld_proc_hash_seq_write(struct file *file, const char *buffer,
 			size_t count, loff_t *off)
 {
-	struct lu_client_fld *fld = ((struct seq_file *)file->private_data)->private;
+	struct lu_client_fld *fld;
 	struct lu_fld_hash *hash = NULL;
 	int i;
 
+	fld = ((struct seq_file *)file->private_data)->private;
 	LASSERT(fld != NULL);
 
 	for (i = 0; fld_hash[i].fh_name != NULL; i++) {
-- 
1.9.0

