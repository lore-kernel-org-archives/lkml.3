Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357AbaLQSAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 13:00:05 -0500
Received: from mail-pa0-f67.google.com ([209.85.220.67]:45088 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaLQSAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 13:00:04 -0500
From: Hariharan Rangasamy <hariharanrangasamy@gmail.com>
To: oleg.drokin@intel.com, andreas.dilger@intel.com,
        gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Hariharan Rangasamy <hariharanrangasamy@gmail.com>
Subject: [PATCH 2/2] Staging: lustre: lproc_osc.c: used seq_puts() instead of seq_printf()
Date: Wed, 17 Dec 2014 23:29:28 +0530
Message-Id: <1418839168-7921-2-git-send-email-hariharanrangasamy@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418839168-7921-1-git-send-email-hariharanrangasamy@gmail.com>
References: <1418839168-7921-1-git-send-email-hariharanrangasamy@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced seq_printf() with seq_puts()

Signed-off-by: Hariharan Rangasamy <hariharanrangasamy@gmail.com>
---
 drivers/staging/lustre/lustre/osc/lproc_osc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/osc/lproc_osc.c b/drivers/staging/lustre/lustre/osc/lproc_osc.c
index f578b51..d64a400 100644
--- a/drivers/staging/lustre/lustre/osc/lproc_osc.c
+++ b/drivers/staging/lustre/lustre/osc/lproc_osc.c
@@ -358,7 +358,7 @@ static int osc_checksum_type_seq_show(struct seq_file *m, void *v)
 		else
 			seq_printf(m, "%s ", cksum_name[i]);
 	}
-	seq_printf(m, "\n");
+	seq_puts(m, "\n");
 	return 0;
 }
 
@@ -590,7 +590,7 @@ static int osc_rpc_stats_seq_show(struct seq_file *seq, void *v)
 	seq_printf(seq, "pending read pages:   %d\n",
 		   atomic_read(&cli->cl_pending_r_pages));
 
-	seq_printf(seq, "\n\t\t\tread\t\t\twrite\n");
+	seq_puts(seq, "\n\t\t\tread\t\t\twrite\n");
 	seq_printf(seq, "pages per rpc	 rpcs   %% cum %% |");
 	seq_printf(seq, "       rpcs   %% cum %%\n");
 
@@ -613,7 +613,7 @@ static int osc_rpc_stats_seq_show(struct seq_file *seq, void *v)
 			break;
 	}
 
-	seq_printf(seq, "\n\t\t\tread\t\t\twrite\n");
+	seq_puts(seq, "\n\t\t\tread\t\t\twrite\n");
 	seq_printf(seq, "rpcs in flight	rpcs   %% cum %% |");
 	seq_printf(seq, "       rpcs   %% cum %%\n");
 
@@ -636,7 +636,7 @@ static int osc_rpc_stats_seq_show(struct seq_file *seq, void *v)
 			break;
 	}
 
-	seq_printf(seq, "\n\t\t\tread\t\t\twrite\n");
+	seq_puts(seq, "\n\t\t\tread\t\t\twrite\n");
 	seq_printf(seq, "offset		rpcs   %% cum %% |");
 	seq_printf(seq, "       rpcs   %% cum %%\n");
 
-- 
1.9.1

