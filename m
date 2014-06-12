Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbaFLTBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 15:01:10 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:32761 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750952AbaFLTBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 15:01:09 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjkIAMn3mVNbsHy//2dsb2JhbABagw2qdQUBAQEBAQEFAZkegQsXdYRgI4EaN4hGAbg7mhQXhVyIG2QdhCsEj2iKSoswiCKDPjuBMA
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] kernel/time/tick-sched.c: add __init to tick_nohz_init_all
Date: Thu, 12 Jun 2014 21:00:56 +0200
Message-Id: <1402599656-6366-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tick_nohz_init_all is only called by __init tick_nohz_init

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/time/tick-sched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 6558b7a..51fe9e7 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -323,7 +323,7 @@ static int tick_nohz_cpu_down_callback(struct notifier_block *nfb,
  */
 static char __initdata nohz_full_buf[NR_CPUS + 1];
 
-static int tick_nohz_init_all(void)
+static int __init tick_nohz_init_all(void)
 {
 	int err = -1;
 
-- 
1.9.1

