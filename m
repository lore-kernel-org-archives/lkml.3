Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbaHFNsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 09:48:05 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57023 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753904AbaHFNrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 09:47:45 -0400
From: Jyri Sarha <jsarha@ti.com>
To: <linux-kernel@vger.kernel.org>, <mturquette@linaro.org>,
        <dri-devel@lists.freedesktop.org>, <airlied@linux.ie>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <bcousson@baylibre.com>
CC: <tony@atomide.com>, <broonie@kernel.org>,
        <liam.r.girdwood@linux.intel.com>, <peter.ujfalusi@ti.com>,
        <detheridge@ti.com>, <zonque@gmail.com>, <t-kristo@ti.com>,
        Jyri Sarha <jsarha@ti.com>
Subject: [PATCH 9/9] ARM: OMAP2+: omap2plus_defconfig: Enable BeagleBone Black HDMI audio support
Date: Wed, 6 Aug 2014 16:47:24 +0300
Message-ID: <4258f2c0f4bf3decf18ae01349fbcdc2261db995.1407332062.git.jsarha@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1407332062.git.jsarha@ti.com>
References: <cover.1407332062.git.jsarha@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Select CONFIG_SND_EDMA_SOC=m and CONFIG_SND_AM335X_SOC_NXPTDA_EVM=m
for BBB HDMI audio.

Signed-off-by: Jyri Sarha <jsarha@ti.com>
---
 arch/arm/configs/omap2plus_defconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
index 8b07fda..73dbfad 100644
--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -222,7 +222,9 @@ CONFIG_SND_DEBUG=y
 CONFIG_SND_USB_AUDIO=m
 CONFIG_SND_SOC=m
 CONFIG_SND_OMAP_SOC=m
+CONFIG_SND_EDMA_SOC=m
 CONFIG_SND_AM33XX_SOC_EVM=m
+CONFIG_SND_AM335X_SOC_NXPTDA_EVM=m
 CONFIG_SND_DAVINCI_SOC=m
 CONFIG_SND_OMAP_SOC_OMAP_TWL4030=m
 CONFIG_SND_OMAP_SOC_OMAP_ABE_TWL6040=m
-- 
1.7.9.5

