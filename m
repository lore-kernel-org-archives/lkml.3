Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341AbaEFRNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 13:13:21 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:22447 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751831AbaEFRNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 13:13:20 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsMUAG8XaVNbtAAq/2dsb2JhbABZgwaCQaksBAEBAQEBAQUBmgcCAoEfF3SCZhwjGIECJBOIRQHONYVWiHyERgEDjxuKGwGLAId7gzY7
Date: Tue, 6 May 2014 19:13:13 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] kernel/latencytop.c: convert seq_printf to seq_puts
Message-Id: <20140506191313.894bd684c95489dc126598f0@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch also fixes one function declaration over 80 characters.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/latencytop.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/latencytop.c b/kernel/latencytop.c
index a462b31..a028127 100644
--- a/kernel/latencytop.c
+++ b/kernel/latencytop.c
@@ -88,7 +88,8 @@ static void clear_global_latency_tracing(void)
 }
 
 static void __sched
-account_global_scheduler_latency(struct task_struct *tsk, struct latency_record *lat)
+account_global_scheduler_latency(struct task_struct *tsk,
+				 struct latency_record *lat)
 {
 	int firstnonnull = MAXLR + 1;
 	int i;
@@ -255,7 +256,7 @@ static int lstats_show(struct seq_file *m, void *v)
 					break;
 				seq_printf(m, " %ps", (void *)bt);
 			}
-			seq_printf(m, "\n");
+			seq_puts(m, "\n");
 		}
 	}
 	return 0;
-- 
1.8.4.5

