Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbaEGUlx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 16:41:53 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:35650 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750904AbaEGUlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 16:41:52 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApQXAIKZalNXQBiQ/2dsb2JhbABagwaCQXyoawoFAZoKAgKBHRd0gmYcIxiBAiQTiEUB0DaFVoh8hEYBA48bihsBiwCHe4M2Ow
Date: Wed, 7 May 2014 22:41:42 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/2] kernel/stop_machine.c: kernel-doc warning fix
Message-Id: <20140507224142.084f4d778591d9ffd9138409@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/stop_machine.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 01fbae5..695f0c6 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -307,6 +307,7 @@ int stop_two_cpus(unsigned int cpu1, unsigned int cpu2, cpu_stop_fn_t fn, void *
  * @cpu: cpu to stop
  * @fn: function to execute
  * @arg: argument to @fn
+ * @work_buf: pointer to cpu_stop_work structure
  *
  * Similar to stop_one_cpu() but doesn't wait for completion.  The
  * caller is responsible for ensuring @work_buf is currently unused
-- 
1.8.4.5

