Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab3LPIIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 03:08:41 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:43012 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab3LPIIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 03:08:39 -0500
From: Alexander Popov <a13xp0p0v88@gmail.com>
To: Gerhard Sittig <gsi@denx.de>, Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        Anatolij Gustschin <agust@denx.de>,
        Alexander Popov <a13xp0p0v88@gmail.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] dmaengine: fix incorrect kernel-doc comment for struct dma_slave_config
Date: Mon, 16 Dec 2013 12:12:17 +0400
Message-Id: <1387181537-3254-1-git-send-email-a13xp0p0v88@gmail.com>
X-Mailer: git-send-email 1.7.11.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'direction' member of 'struct dma_slave_config' is of data
type 'enum dma_transfer_direction', so update the kernel-doc comment
for 'struct dma_slave_config' to refer to appropriate values.

Signed-off-by: Alexander Popov <a13xp0p0v88@gmail.com>
---
 include/linux/dmaengine.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 41cf0c3..bd6b882 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -305,9 +305,8 @@ enum dma_slave_buswidth {
 /**
  * struct dma_slave_config - dma slave channel runtime config
  * @direction: whether the data shall go in or out on this slave
- * channel, right now. DMA_TO_DEVICE and DMA_FROM_DEVICE are
- * legal values, DMA_BIDIRECTIONAL is not acceptable since we
- * need to differentiate source and target addresses.
+ * channel, right now. DMA_MEM_TO_DEV and DMA_DEV_TO_MEM are
+ * legal values.
  * @src_addr: this is the physical address where DMA slave data
  * should be read (RX), if the source is memory this argument is
  * ignored.
-- 
1.8.4.2

