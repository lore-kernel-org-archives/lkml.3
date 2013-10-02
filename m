Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab3JBRYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:24:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:18490 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755095Ab3JBRYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:24:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1019,1371106800"; 
   d="scan'208";a="302314593"
From: Dave Jiang <dave.jiang@intel.com>
To: linux-kernel@vger.kernel.org
Cc: dan.j.williams@intel.com
Subject: [PATCH] MAINTAINERS: add to ioatdma maintainer list
Date: Wed,  2 Oct 2013 10:23:36 -0700
Message-Id: <1380734616-16598-1-git-send-email-dave.jiang@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 744a239..dd5b220 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4345,7 +4345,8 @@ F:	arch/x86/kernel/microcode_intel.c
 
 INTEL I/OAT DMA DRIVER
 M:	Dan Williams <dan.j.williams@intel.com>
-S:	Maintained
+M:	Dave Jiang <dave.jiang@intel.com>
+S:	Supported
 F:	drivers/dma/ioat*
 
 INTEL IOMMU (VT-d)
-- 
1.8.3.1

