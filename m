Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbaBISsd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 13:48:33 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62411 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbaBISs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 13:48:27 -0500
From: Richard Weinberger <richard@nod.at>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        dmaengine@vger.kernel.org (open list:DMA GENERIC OFFLO...),
        linux-kernel@vger.kernel.org (open list)
Cc: Richard Weinberger <richard@nod.at>
Subject: [PATCH 03/28] Remove MACH_BCM2708
Date: Sun,  9 Feb 2014 19:47:41 +0100
Message-Id: <1391971686-9517-4-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1391971686-9517-1-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol is an orphan, get rid of it.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/dma/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 9bed1a2..e4382ec 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -308,7 +308,7 @@ config DMA_OMAP
 
 config DMA_BCM2835
 	tristate "BCM2835 DMA engine support"
-	depends on (ARCH_BCM2835 || MACH_BCM2708)
+	depends on ARCH_BCM2835
 	select DMA_ENGINE
 	select DMA_VIRTUAL_CHANNELS
 
-- 
1.8.4.2

