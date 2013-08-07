Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604Ab3HGKXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:23:37 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:56310 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932458Ab3HGKXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:23:34 -0400
Date: Wed, 7 Aug 2013 12:16:51 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: Davide Ciminaghi <ciminaghi@gnudd.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org,
        Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org
Subject: [PATCH 03/26] mmc: Use the new <linux/sizes.h>
Message-ID: <85d780625135282d3dda1ad136b74db9b658d927.1375867291.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1375867291.git.rubini@gnudd.com>
In-Reply-To: <cover.1375867291.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For portability, use <linux/sizes.h>.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Link: http://lkml.kernel.org/r/1355146956-6009-6-git-send-email-ciminaghi@gnudd.com
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
Acked-by: David Brown <davidb@codeaurora.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 drivers/mmc/host/mmci.c     |    2 +-
 drivers/mmc/host/msm_sdcc.c |    2 +-
 drivers/mmc/host/mvsdio.c   |    2 +-
 drivers/mmc/host/pxamci.c   |    3 +--
 4 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index c3785ed..edd987e 100644
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
index b900de4..405f0d8 100644
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
 #include <mach/dma.h>
diff --git a/drivers/mmc/host/mvsdio.c b/drivers/mmc/host/mvsdio.c
index 4ddd83f..4dec50f 100644
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
 
diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index 1956a3d..3924f36 100644
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
