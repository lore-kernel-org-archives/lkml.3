Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965261AbaGOXYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:24:45 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:37477 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934349AbaGOXYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:24:41 -0400
Subject: [PATCH] dmaengine: jz4740: Fix GPL v2 license string typo
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: dmaengine@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        linux-kernel@vger.kernel.org
Date: Tue, 15 Jul 2014 17:24:38 -0600
Message-ID: <20140715232438.24028.90309.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per license_is_gpl_compatible(), the MODULE_LICENSE() string for GPL v2 is
"GPL v2", not "GPLv2".  Use "GPL v2" so this module doesn't taint the
kernel.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/dma/dma-jz4740.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/dma-jz4740.c b/drivers/dma/dma-jz4740.c
index 94c380f07538..bfbce6b07902 100644
--- a/drivers/dma/dma-jz4740.c
+++ b/drivers/dma/dma-jz4740.c
@@ -614,4 +614,4 @@ module_platform_driver(jz4740_dma_driver);
 
 MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
 MODULE_DESCRIPTION("JZ4740 DMA driver");
-MODULE_LICENSE("GPLv2");
+MODULE_LICENSE("GPL v2");

