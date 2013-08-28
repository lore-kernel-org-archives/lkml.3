Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab3H1Rdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 13:33:55 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37678 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817Ab3H1Rdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 13:33:51 -0400
From: George Cherian <george.cherian@ti.com>
To: <balbi@ti.com>, <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <grant.likely@linaro.org>,
        <rob@landley.net>, <ian.campbell@citrix.com>, <swarren@wwwdotorg.org>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>,
        <rob.herring@calxeda.com>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <bcousson@baylibre.com>,
        <davidb@codeaurora.org>, <arnd@arndb.de>, <swarren@nvidia.com>,
        <popcornmix@gmail.com>, George Cherian <george.cherian@ti.com>
Subject: [PATCH v3 2/3] drivers: Makefile: Extcon is a framework so bump it up
Date: Wed, 28 Aug 2013 23:03:04 +0530
Message-ID: <1377711185-31238-3-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1377711185-31238-1-git-send-email-george.cherian@ti.com>
References: <1377711185-31238-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bump up the order, since extcon is a framework and needed by
other drivers. With the previous order it failed to detect
extcon device in DWC3 when both were compiled built-in.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/Makefile b/drivers/Makefile
index ab93de8..4573b8d 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -49,6 +49,7 @@ obj-y				+= char/
 obj-y				+= gpu/
 
 obj-$(CONFIG_CONNECTOR)		+= connector/
+obj-$(CONFIG_EXTCON)		+= extcon/
 
 # i810fb and intelfb depend on char/agp/
 obj-$(CONFIG_FB_I810)           += video/i810/
@@ -145,7 +146,6 @@ obj-$(CONFIG_VIRT_DRIVERS)	+= virt/
 obj-$(CONFIG_HYPERV)		+= hv/
 
 obj-$(CONFIG_PM_DEVFREQ)	+= devfreq/
-obj-$(CONFIG_EXTCON)		+= extcon/
 obj-$(CONFIG_MEMORY)		+= memory/
 obj-$(CONFIG_IIO)		+= iio/
 obj-$(CONFIG_VME_BUS)		+= vme/
-- 
1.8.1.4

