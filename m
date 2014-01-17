Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaAQP1f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:27:35 -0500
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:50573 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753332AbaAQP1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 10:27:16 -0500
Message-Id: <20140117151838.656283091@linux.com>
Date: Fri, 17 Jan 2014 09:18:53 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 41/41] percpu: Remove __this_cpu_ptr
References: <20140117151812.770437629@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=__this_cpu_ptr_gone
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __this_cpu_ptr macro is no longer in use so drop it.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/include/asm-generic/percpu.h
===================================================================
--- linux.orig/include/asm-generic/percpu.h	2013-12-18 13:41:37.359646058 -0600
+++ linux/include/asm-generic/percpu.h	2013-12-18 13:42:00.428902830 -0600
@@ -117,7 +117,4 @@ extern void setup_per_cpu_areas(void);
 #define PER_CPU_DEF_ATTRIBUTES
 #endif
 
-/* Keep until we have removed all uses of __this_cpu_ptr */
-#define __this_cpu_ptr raw_cpu_ptr
-
 #endif /* _ASM_GENERIC_PERCPU_H_ */

