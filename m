Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786Ab3LCXjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 18:39:35 -0500
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:36885
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755704Ab3LCXjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 18:39:14 -0500
Message-Id: <20131203233306.647259536@linux.com>
User-Agent: quilt/0.60-1
Date: Tue, 03 Dec 2013 17:33:13 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 41/41] percpu: Remove __this_cpu_ptr
References: <20131203233232.928771708@linux.com>
Content-Disposition: inline; filename=__this_cpu_ptr_gone
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __this_cpu_ptr macro is no longer in use so drop it.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/include/linux/percpu.h
===================================================================
--- linux.orig/include/linux/percpu.h	2013-12-03 15:52:58.758524804 -0600
+++ linux/include/linux/percpu.h	2013-12-03 15:52:58.758524804 -0600
@@ -139,9 +139,6 @@ extern int __init pcpu_page_first_chunk(
 				pcpu_fc_populate_pte_fn_t populate_pte_fn);
 #endif
 
-/* Keep until we have removed all uses of __this_cpu_ptr */
-#define __this_cpu_ptr raw_cpu_ptr
-
 /*
  * Use this to get to a cpu's version of the per-cpu object
  * dynamically allocated. Non-atomic access to the current CPU's

