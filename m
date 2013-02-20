Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935466Ab3BTVYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 16:24:11 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:33753 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759095Ab3BTVYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 16:24:06 -0500
Date: Wed, 20 Feb 2013 22:23:51 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Davide Ciminaghi <ciminaghi@gnudd.com>, davidb@codeaurora.org
Subject: [PATCH V5 3/5] mmc: Use the new <linux/sizes.h>
Message-ID: <641707735b36583ea3cd26e237636b2691952b2a.1361393832.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1361393832.git.rubini@gnudd.com>
In-Reply-To: <cover.1361393832.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For portability, use <linux/sizes.h>.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
Acked-by: David Brown <davidb@codeaurora.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---

@David: I repost this after rebasing, on hpa's suggestion.

 drivers/mmc/host/mmci.c     |    2 +-
 drivers/mmc/host/msm_sdcc.c |    2 +-
 drivers/mmc/host/mvsdio.c   |    2 +-
 drivers/mmc/host/mxcmmc.c   |    2 +-
 drivers/mmc/host/pxamci.c   |    3 +--
 5 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 372e921..a47aa70 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -34,11 +34,11 @@
 #include <linux/amba/mmci.h>
 #include <linux/pm_runtime.h>
 #include <linux/types.h>
+#include <linux/sizes.h>
 #include <linux/pinctrl/consumer.h>
 
 #include <asm/div64.h>
 #include <asm/io.h>
-#include <asm/sizes.h>
 
 #include "mmci.h"
 
diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index 7c0af0e..aa61b79 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -37,10 +37,10 @@
 #include <linux/memory.h>
 #include <linux/gfp.h>
 #include <linux/gpio.h>
+#include <linux/sizes.h>
 
 #include <asm/cacheflush.h>
 #include <asm/div64.h>
-#include <asm/sizes.h>
 
 #include <linux/platform_data/mmc-msm_sdcc.h>
 #include <mach/msm_iomap.h>
diff --git a/drivers/mmc/host/mvsdio.c b/drivers/mmc/host/mvsdio.c
index 145cdaf..53a1224 100644
--- a/drivers/mmc/host/mvsdio.c
+++ b/drivers/mmc/host/mvsdio.c
@@ -23,11 +23,11 @@
 #include <linux/gpio.h>
 #include <linux/of_gpio.h>
 #include <linux/of_irq.h>
+#include <linux/sizes.h>
 #include <linux/mmc/host.h>
 #include <linux/mmc/slot-gpio.h>
 #include <linux/pinctrl/consumer.h>
 
-#include <asm/sizes.h>
 #include <asm/unaligned.h>
 #include <linux/platform_data/mmc-mvsdio.h>
 
diff --git a/drivers/mmc/host/mxcmmc.c b/drivers/mmc/host/mxcmmc.c
index a72936e..8ce7e73 100644
--- a/drivers/mmc/host/mxcmmc.c
+++ b/drivers/mmc/host/mxcmmc.c
@@ -34,10 +34,10 @@
 #include <linux/regulator/consumer.h>
 #include <linux/dmaengine.h>
 #include <linux/types.h>
+#include <linux/sizes.h>
 
 #include <asm/dma.h>
 #include <asm/irq.h>
-#include <asm/sizes.h>
 #include <linux/platform_data/mmc-mxcmmc.h>
 
 #include <linux/platform_data/dma-imx.h>
diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index 2b2f65a..6fa54a9 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -33,8 +33,7 @@
 #include <linux/of.h>
 #include <linux/of_gpio.h>
 #include <linux/of_device.h>
-
-#include <asm/sizes.h>
+#include <linux/sizes.h>
 
 #include <mach/hardware.h>
 #include <mach/dma.h>
-- 
1.7.7.2
