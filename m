Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750911Ab3LKGDc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 01:03:32 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:35902 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab3LKGD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 01:03:29 -0500
From: Alexander Popov <a13xp0p0v88@gmail.com>
To: Gerhard Sittig <gsi@denx.de>, Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        Anatolij Gustschin <agust@denx.de>,
        Alexander Popov <a13xp0p0v88@gmail.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] dmaengine: remove obsolete comment reference to dma_data_direction
Date: Wed, 11 Dec 2013 10:07:02 +0400
Message-Id: <1386742022-2995-1-git-send-email-a13xp0p0v88@gmail.com>
X-Mailer: git-send-email 1.7.11.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

enum dma_transfer_direction is currently used
in struct dma_slave_config, so update the comment

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

