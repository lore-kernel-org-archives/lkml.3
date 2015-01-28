Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbbA2Bfp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:35:45 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:33597 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbbA2Bfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:35:38 -0500
Date: Wed, 28 Jan 2015 16:05:33 +0200
From: Heba Aamer <heba93aamer@gmail.com>
To: devel@driverdev.osuosl.org
Cc: oleg.drokin@intel.com, andreas.dilger@intel.com,
        gregkh@linuxfoundation.org, gdonald@gmail.com, dmitry.eremin@intel.com,
        brilliantov@inbox.ru, tristan@lelong.xyz, HPDD-discuss@ml01.01.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: lustre: osc: fix Prefer seq_puts to
 seq_printf
Message-ID: <20150128140533.GA14301@mohammed-Inspiron-3537>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl warning:
Prefer seq_puts to seq_printf

Signed-off-by: Heba Aamer <heba93aamer@gmail.com>
---
 drivers/staging/lustre/lustre/osc/lproc_osc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/osc/lproc_osc.c b/drivers/staging/lustre/lustre/osc/lproc_osc.c
index 8e22e45..4da837e 100644
--- a/drivers/staging/lustre/lustre/osc/lproc_osc.c
+++ b/drivers/staging/lustre/lustre/osc/lproc_osc.c
@@ -364,7 +364,7 @@ static int osc_checksum_type_seq_show(struct seq_file *m, void *v)
 		else
 			seq_printf(m, "%s ", cksum_name[i]);
 	}
-	seq_printf(m, "\n");
+	seq_puts(m, "\n");
 	return 0;
 }
 
@@ -601,7 +601,7 @@ static int osc_rpc_stats_seq_show(struct seq_file *seq, void *v)
 	seq_printf(seq, "pending read pages:   %d\n",
 		   atomic_read(&cli->cl_pending_r_pages));
 
-	seq_printf(seq, "\n\t\t\tread\t\t\twrite\n");
+	seq_puts(seq, "\n\t\t\tread\t\t\twrite\n");
 	seq_printf(seq, "pages per rpc	 rpcs   %% cum %% |");
 	seq_printf(seq, "       rpcs   %% cum %%\n");
 
@@ -624,7 +624,7 @@ static int osc_rpc_stats_seq_show(struct seq_file *seq, void *v)
 			break;
 	}
 
-	seq_printf(seq, "\n\t\t\tread\t\t\twrite\n");
+	seq_puts(seq, "\n\t\t\tread\t\t\twrite\n");
 	seq_printf(seq, "rpcs in flight	rpcs   %% cum %% |");
 	seq_printf(seq, "       rpcs   %% cum %%\n");
 
@@ -647,7 +647,7 @@ static int osc_rpc_stats_seq_show(struct seq_file *seq, void *v)
 			break;
 	}
 
-	seq_printf(seq, "\n\t\t\tread\t\t\twrite\n");
+	seq_puts(seq, "\n\t\t\tread\t\t\twrite\n");
 	seq_printf(seq, "offset		rpcs   %% cum %% |");
 	seq_printf(seq, "       rpcs   %% cum %%\n");
 
-- 
1.7.9.5

