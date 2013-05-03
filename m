Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762262Ab3ECADI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 20:03:08 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:40209 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758934Ab3ECADD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 20:03:03 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Simon Jeons <simon.jeons@gmail.com>
Subject: [RFC PATCH v3 15/31] drivers/base/memory.c: alphabetize headers.
Date: Thu,  2 May 2013 17:00:47 -0700
Message-Id: <1367539263-19999-16-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1367539263-19999-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1367539263-19999-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050300-7606-0000-0000-00000B0CBE74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/base/memory.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 14f8a69..5247698 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -10,20 +10,20 @@
  * SPARSEMEM should be contained here, or in mm/memory_hotplug.c.
  */
 
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/topology.h>
+#include <linux/atomic.h>
 #include <linux/capability.h>
 #include <linux/device.h>
-#include <linux/memory.h>
+#include <linux/init.h>
 #include <linux/kobject.h>
+#include <linux/memory.h>
 #include <linux/memory_hotplug.h>
 #include <linux/mm.h>
+#include <linux/module.h>
 #include <linux/mutex.h>
-#include <linux/stat.h>
 #include <linux/slab.h>
+#include <linux/stat.h>
+#include <linux/topology.h>
 
-#include <linux/atomic.h>
 #include <asm/uaccess.h>
 
 static DEFINE_MUTEX(mem_sysfs_mutex);
-- 
1.8.2.2

