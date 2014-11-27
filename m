Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbaK0Kmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 05:42:32 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:33927 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754127AbaK0Km2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 05:42:28 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Mark Brown <broonie@kernel.org>, <linux@arm.linux.org.uk>,
        <nsekhar@ti.com>, <arnd@arndb.de>, <vinod.koul@intel.com>,
        <khilman@deeprootsystems.com>
CC: Liam Girdwood <lgirdwood@gmail.com>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, <ulf.hansson@linaro.org>,
        <chris@printf.net>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mmc@vger.kernel.org>, <linux-spi@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        <dmaengine@vger.kernel.org>
Subject: [PATCH 1/3] ASoC: davinci-evm: Do not include edma headers
Date: Thu, 27 Nov 2014 12:41:29 +0200
Message-ID: <1417084891-17990-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417084891-17990-1-git-send-email-peter.ujfalusi@ti.com>
References: <1417084891-17990-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The machine driver has no business with the underlying dma.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/davinci/davinci-evm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/sound/soc/davinci/davinci-evm.c b/sound/soc/davinci/davinci-evm.c
index 158cb3d1db70..d1a8b6e3ac3b 100644
--- a/sound/soc/davinci/davinci-evm.c
+++ b/sound/soc/davinci/davinci-evm.c
@@ -14,7 +14,6 @@
 #include <linux/timer.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
-#include <linux/platform_data/edma.h>
 #include <linux/i2c.h>
 #include <linux/of_platform.h>
 #include <linux/clk.h>
@@ -25,8 +24,6 @@
 #include <asm/dma.h>
 #include <asm/mach-types.h>
 
-#include <linux/edma.h>
-
 #include "davinci-pcm.h"
 #include "davinci-i2s.h"
 
-- 
2.1.3

