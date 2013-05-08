Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab3EHVbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 17:31:25 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:25190 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab3EHVbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 17:31:23 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: akpm@linux-foundation.org, bob.liu@oracle.com, dan.magenheimer@oracle.com,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/8] xen/tmem: Cleanup. Remove the parts that say temporary.
Date: Wed,  8 May 2013 17:31:01 -0400
Message-Id: <1368048668-8140-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1368048668-8140-1-git-send-email-konrad.wilk@oracle.com>
References: <1368048668-8140-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frontswap is upstream, no need for this #ifdef.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/tmem.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/xen/tmem.c b/drivers/xen/tmem.c
index e3600be..5686d6d 100644
--- a/drivers/xen/tmem.c
+++ b/drivers/xen/tmem.c
@@ -11,11 +11,7 @@
 #include <linux/init.h>
 #include <linux/pagemap.h>
 #include <linux/cleancache.h>
-
-/* temporary ifdef until include/linux/frontswap.h is upstream */
-#ifdef CONFIG_FRONTSWAP
 #include <linux/frontswap.h>
-#endif
 
 #include <xen/xen.h>
 #include <xen/interface/xen.h>
-- 
1.8.1.4

