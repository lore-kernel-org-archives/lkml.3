Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966938AbaFTTc6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:32:58 -0400
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:42072
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966614AbaFTTc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:32:56 -0400
Message-Id: <20140620193128.591265936@linux.com>
Date: Fri, 20 Jun 2014 14:31:46 -0500
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 31/31] percpu: Remove __this_cpu_ptr
References: <20140620193115.547427118@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=__this_cpu_ptr_gone
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __this_cpu_ptr macro is no longer in use so drop it.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/include/asm-generic/percpu.h
===================================================================
--- linux.orig/include/asm-generic/percpu.h	2014-04-29 11:47:08.872553359 -0500
+++ linux/include/asm-generic/percpu.h	2014-04-29 11:47:08.868553436 -0500
@@ -117,7 +117,4 @@
 #define PER_CPU_DEF_ATTRIBUTES
 #endif
 
-/* Keep until we have removed all uses of __this_cpu_ptr */
-#define __this_cpu_ptr raw_cpu_ptr
-
 #endif /* _ASM_GENERIC_PERCPU_H_ */

