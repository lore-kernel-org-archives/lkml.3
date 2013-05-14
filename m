Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714Ab3ENSUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 14:20:47 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:42138 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713Ab3ENSUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 14:20:45 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: bob.liu@oracle.com, dan.magenheimer@oracle.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-mm@kvack.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/9] xen/tmem: Cleanup. Remove the parts that say temporary.
Date: Tue, 14 May 2013 14:09:18 -0400
Message-Id: <1368554966-30469-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1368554966-30469-1-git-send-email-konrad.wilk@oracle.com>
References: <1368554966-30469-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frontswap is upstream, not of having this #ifdef.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/tmem.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

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
1.7.7.6

