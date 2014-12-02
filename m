Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933217AbaLBVZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 16:25:25 -0500
Received: from resqmta-ch2-09v.sys.comcast.net ([69.252.207.41]:50719 "EHLO
	resqmta-ch2-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932989AbaLBVYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 16:24:42 -0500
Message-Id: <20141202212439.918330465@linux.com>
Date: Tue, 02 Dec 2014 15:24:32 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 3/4] ia64: Update comment that references __get_cpu_var
References: <20141202212429.996456533@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=ia64_update
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__get_cpu_var was removed. Update the comments.

Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/arch/ia64/include/asm/percpu.h
===================================================================
--- linux.orig/arch/ia64/include/asm/percpu.h
+++ linux/arch/ia64/include/asm/percpu.h
@@ -35,8 +35,8 @@ extern void *per_cpu_init(void);
 
 /*
  * Be extremely careful when taking the address of this variable!  Due to virtual
- * remapping, it is different from the canonical address returned by __get_cpu_var(var)!
- * On the positive side, using __ia64_per_cpu_var() instead of __get_cpu_var() is slightly
+ * remapping, it is different from the canonical address returned by this_cpu_ptr(&var)!
+ * On the positive side, using __ia64_per_cpu_var() instead of this_cpu_ptr() is slightly
  * more efficient.
  */
 #define __ia64_per_cpu_var(var) (*({					\

