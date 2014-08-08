Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbaHHTqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 15:46:17 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:33692 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751002AbaHHTqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 15:46:14 -0400
Date: Fri, 8 Aug 2014 14:46:11 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <htejun@gmail.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>,
        Mike Travis <travis@sgi.com>
Subject: Re: percpu: Define this_cpu_cpumask_var_t_ptr
In-Reply-To: <alpine.DEB.2.11.1408070959250.28468@gentwo.org>
Message-ID: <alpine.DEB.2.11.1408081445470.27009@gentwo.org>
References: <alpine.DEB.2.11.1408070959250.28468@gentwo.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Needs a small fixup

From: Christoph Lameter <cl@linux.com>
Subject: One & too much

Remove it.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/include/linux/cpumask.h
===================================================================
--- linux.orig/include/linux/cpumask.h
+++ linux/include/linux/cpumask.h
@@ -690,7 +690,7 @@ void free_bootmem_cpumask_var(cpumask_va
 #else
 typedef struct cpumask cpumask_var_t[1];

-#define this_cpu_cpumask_var_t_ptr(x) this_cpu_ptr(&x)
+#define this_cpu_cpumask_var_t_ptr(x) this_cpu_ptr(x)

 static inline bool alloc_cpumask_var(cpumask_var_t *mask, gfp_t flags)
 {
