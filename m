Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762816Ab3IDO2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:28:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758780Ab3IDO2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:28:07 -0400
Date: Wed, 4 Sep 2013 10:28:01 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Matt Porter <mporter@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] edma: Update author email address
Message-ID: <20130904142800.GD12834@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt's @ti.com address bounces.  Update the MODULE_AUTHOR information in
edma.c to his Linaro address.

Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>

---

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 5f3e532..8d1932f 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -667,6 +667,6 @@ static void __exit edma_exit(void)
 }
 module_exit(edma_exit);
 
-MODULE_AUTHOR("Matt Porter <mporter@ti.com>");
+MODULE_AUTHOR("Matt Porter <mporter@linaro.org>");
 MODULE_DESCRIPTION("TI EDMA DMA engine driver");
 MODULE_LICENSE("GPL v2");
