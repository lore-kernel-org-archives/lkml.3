Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaHQRcU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 13:32:20 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:59298 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752178AbaHQRcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 13:32:00 -0400
Message-Id: <20140817173038.319065067@linux.com>
Date: Sun, 17 Aug 2014 12:30:58 -0500
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 35/35] [PATCH 33/36] Remove __get_cpu_var and __raw_get_cpu_var macros [only
 in 3.17]
References: <20140817173023.439660246@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0033-Remove-__get_cpu_var-and-__raw_get_cpu_var-macros-on.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No user is left in the kernel source tree. Therefore we can
drop the definitions.

[Patch should not be merged until all the replacement patches have been
merged. Probably this means hold until the 3.17 merge window]

Signed-off-by: Christoph Lameter <cl@linux.com>
---
 include/asm-generic/percpu.h | 5 -----
 1 file changed, 5 deletions(-)

Index: linux/include/linux/percpu-defs.h
===================================================================
--- linux.orig/include/linux/percpu-defs.h
+++ linux/include/linux/percpu-defs.h
@@ -254,8 +254,6 @@ do {									\
 #endif	/* CONFIG_SMP */
 
 #define per_cpu(var, cpu)	(*per_cpu_ptr(&(var), cpu))
-#define __raw_get_cpu_var(var)	(*raw_cpu_ptr(&(var)))
-#define __get_cpu_var(var)	(*this_cpu_ptr(&(var)))
 
 /*
  * Must be an lvalue. Since @var must be a simple identifier,

