Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541Ab3EOJwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:52:34 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:53461 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932507Ab3EOJwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:52:31 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.hengli.com.au,
        vinod.koul@intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 10/39] dmaengine: ste_dma40: Correct copy/paste error
Date: Wed, 15 May 2013 10:51:33 +0100
Message-Id: <1368611522-9984-11-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'struct stedma40_half_channel_info's header comment says that it's
called 'struct stedma40_chan_cfg'. Let's straighten that out.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 include/linux/platform_data/dma-ste-dma40.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/platform_data/dma-ste-dma40.h b/include/linux/platform_data/dma-ste-dma40.h
index af0064e..288dc24 100644
--- a/include/linux/platform_data/dma-ste-dma40.h
+++ b/include/linux/platform_data/dma-ste-dma40.h
@@ -86,7 +86,7 @@ enum stedma40_xfer_dir {
 
 
 /**
- * struct stedma40_chan_cfg - dst/src channel configuration
+ * struct stedma40_half_channel_info - dst/src channel configuration
  *
  * @big_endian: true if the src/dst should be read as big endian
  * @data_width: Data width of the src/dst hardware
-- 
1.7.10.4

