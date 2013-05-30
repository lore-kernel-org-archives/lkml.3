Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967814Ab3E3Hht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 03:37:49 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:64764 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967739Ab3E3Hhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 03:37:43 -0400
Message-ID: <1369899460.23034.31.camel@x61.thuisdomein>
Subject: [PATCH] ASoC: OMAP: Remove obsolete Makefile line
From: Paul Bolle <pebolle@tiscali.nl>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Date: Thu, 30 May 2013 09:37:40 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 May 2013 07:37:41.0383 (UTC) FILETIME=[90FB4170:01CE5D08]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for omap2evm was removed in v3.0. But only one of its two
lines in this Makefile was removed. Remove the second line too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Eyeball tested only.

 sound/soc/omap/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/omap/Makefile b/sound/soc/omap/Makefile
index 2b22594..a725905 100644
--- a/sound/soc/omap/Makefile
+++ b/sound/soc/omap/Makefile
@@ -26,7 +26,6 @@ obj-$(CONFIG_SND_OMAP_SOC_N810) += snd-soc-n810.o
 obj-$(CONFIG_SND_OMAP_SOC_RX51) += snd-soc-rx51.o
 obj-$(CONFIG_SND_OMAP_SOC_AMS_DELTA) += snd-soc-ams-delta.o
 obj-$(CONFIG_SND_OMAP_SOC_OSK5912) += snd-soc-osk5912.o
-obj-$(CONFIG_SND_OMAP_SOC_OMAP2EVM) += snd-soc-omap2evm.o
 obj-$(CONFIG_SND_OMAP_SOC_AM3517EVM) += snd-soc-am3517evm.o
 obj-$(CONFIG_SND_OMAP_SOC_OMAP_ABE_TWL6040) += snd-soc-omap-abe-twl6040.o
 obj-$(CONFIG_SND_OMAP_SOC_OMAP_TWL4030) += snd-soc-omap-twl4030.o
-- 
1.7.11.7

