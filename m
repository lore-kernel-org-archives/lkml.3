Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbbAMM1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 07:27:31 -0500
Received: from down.free-electrons.com ([37.187.137.238]:33565 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751819AbbAMM1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 07:27:30 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Mark Brown <broonie@kernel.org>, Bo Shen <voice.shen@atmel.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] Asoc: sam9x5_wm8731: depend on ARCH_AT91 instead of SOC_AT91SAM9X5
Date: Tue, 13 Jan 2015 13:27:26 +0100
Message-Id: <1421152046-20069-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SOC_AT91SAM9X5 option is going to be removed, only depend on ARCH_AT91 like
for the other drivers.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 sound/soc/atmel/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/atmel/Kconfig b/sound/soc/atmel/Kconfig
index fb3878312bf8..1579e994acf8 100644
--- a/sound/soc/atmel/Kconfig
+++ b/sound/soc/atmel/Kconfig
@@ -45,7 +45,7 @@ config SND_ATMEL_SOC_WM8904
 
 config SND_AT91_SOC_SAM9X5_WM8731
 	tristate "SoC Audio support for WM8731-based at91sam9x5 board"
-	depends on ATMEL_SSC && SND_ATMEL_SOC && SOC_AT91SAM9X5
+	depends on ARCH_AT91 && ATMEL_SSC && SND_ATMEL_SOC
 	select SND_ATMEL_SOC_SSC
 	select SND_ATMEL_SOC_DMA
 	select SND_SOC_WM8731
-- 
2.1.0

