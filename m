Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613AbaEPQEr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 12:04:47 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:65308 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753810AbaEPQEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 12:04:46 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjASAMI2dlNXQB71/2dsb2JhbABZgwaCQqgmBQUFAZoZAgKBFhd0gmYcIxiBAiQTiEUB0haFVYh6hEcBA48tiioBixGICIM5Ow
Date: Fri, 16 May 2014 18:04:43 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 2/3] kernel/hrtimer.c: move EXPORT_SYMBOL
Message-Id: <20140516180443.ef444911350b6ef8a7e98095@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warnings:
"WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable"

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/hrtimer.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 14f9030..1eccb98 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -292,7 +292,6 @@ ktime_t ktime_add_ns(const ktime_t kt, u64 nsec)
 
 	return ktime_add(kt, tmp);
 }
-
 EXPORT_SYMBOL_GPL(ktime_add_ns);
 
 /**
@@ -316,7 +315,6 @@ ktime_t ktime_sub_ns(const ktime_t kt, u64 nsec)
 
 	return ktime_sub(kt, tmp);
 }
-
 EXPORT_SYMBOL_GPL(ktime_sub_ns);
 # endif /* !CONFIG_KTIME_SCALAR */
 
@@ -357,7 +355,6 @@ ktime_t ktime_add_safe(const ktime_t lhs, const ktime_t rhs)
 
 	return res;
 }
-
 EXPORT_SYMBOL_GPL(ktime_add_safe);
 
 #ifdef CONFIG_DEBUG_OBJECTS_TIMERS
-- 
1.8.4.5

