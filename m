Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab3J2Jyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 05:54:49 -0400
Received: from multi.imgtec.com ([194.200.65.239]:62396 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335Ab3J2Jys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 05:54:48 -0400
From: Markos Chandras <markos.chandras@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Markos Chandras <markos.chandras@imgtec.com>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH] percpu-defs: Include missing linux/cache.h header
Date: Tue, 29 Oct 2013 09:54:10 +0000
Message-ID: <1383040450-24283-1-git-send-email-markos.chandras@imgtec.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.31]
X-SEF-Processed: 7_3_0_01192__2013_10_29_09_54_16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The percpu-defs.h header uses the ____cacheline_aligned*
macros which are defined in the linux/cache.h header.

Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
---
 include/linux/percpu-defs.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index 57e890a..9976a11 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_PERCPU_DEFS_H
 #define _LINUX_PERCPU_DEFS_H
 
+#include <linux/cache.h>
+
 /*
  * Base implementations of per-CPU variable declarations and definitions, where
  * the section in which the variable is to be placed is provided by the
-- 
1.8.4


