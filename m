Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab3LEBXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 20:23:17 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:40548 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756381Ab3LEBXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 20:23:16 -0500
From: Brian Norris <computersforpeace@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Brian Norris <computersforpeace@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        iommu@lists.linux-foundation.org, Hiroshi DOYU <hdoyu@nvidia.com>
Subject: [PATCH] iommu: add missing include
Date: Wed,  4 Dec 2013 17:22:53 -0800
Message-Id: <1386206573-16158-1-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a warning in of_iommu.c:

drivers/iommu/of_iommu.c:38:5: warning: no previous prototype for 'of_get_dma_window' [-Wmissing-prototypes]

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Cc: Hiroshi DOYU <hdoyu@nvidia.com>
---
 drivers/iommu/of_iommu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/of_iommu.c b/drivers/iommu/of_iommu.c
index ee249bc959f8..e550ccb7634e 100644
--- a/drivers/iommu/of_iommu.c
+++ b/drivers/iommu/of_iommu.c
@@ -20,6 +20,7 @@
 #include <linux/export.h>
 #include <linux/limits.h>
 #include <linux/of.h>
+#include <linux/of_iommu.h>
 
 /**
  * of_get_dma_window - Parse *dma-window property and returns 0 if found.
-- 
1.8.5

