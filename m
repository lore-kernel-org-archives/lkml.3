Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933353Ab3CLWJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:09:39 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:61199 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932065Ab3CLWJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:09:37 -0400
Message-ID: <1363126175.3137.160.camel@x61.thuisdomein>
Subject: [PATCH] ASoC: samsung: remove last traces of neo1973-gta01
From: Paul Bolle <pebolle@tiscali.nl>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Date: Tue, 12 Mar 2013 23:09:35 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Mar 2013 22:09:36.0046 (UTC) FILETIME=[485114E0:01CE1F6E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The (rudimentary) support for the Openmoko Neo1973 GTA01 got removed in
commit 1ae5cbc52e7c6619a3f44b87809fd25370df31bb ("ASoC: neo1973_wm8753:
remove references to the neo1973-gta01 machine"). Remove its last traces
in the Kconfig file too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 sound/soc/samsung/Kconfig | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/sound/soc/samsung/Kconfig b/sound/soc/samsung/Kconfig
index 90e7e66..475fb0d 100644
--- a/sound/soc/samsung/Kconfig
+++ b/sound/soc/samsung/Kconfig
@@ -35,11 +35,10 @@ config SND_SAMSUNG_I2S
 	tristate
 
 config SND_SOC_SAMSUNG_NEO1973_WM8753
-	tristate "Audio support for Openmoko Neo1973 Smartphones (GTA01/GTA02)"
-	depends on SND_SOC_SAMSUNG && (MACH_NEO1973_GTA01 || MACH_NEO1973_GTA02)
+	tristate "Audio support for Openmoko Neo1973 Smartphones (GTA02)"
+	depends on SND_SOC_SAMSUNG && MACH_NEO1973_GTA02
 	select SND_S3C24XX_I2S
 	select SND_SOC_WM8753
-	select SND_SOC_LM4857 if MACH_NEO1973_GTA01
 	select SND_SOC_DFBMCS320
 	help
 	  Say Y here to enable audio support for the Openmoko Neo1973
-- 
1.7.11.7

