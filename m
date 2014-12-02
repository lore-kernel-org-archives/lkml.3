Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323AbaLBJEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 04:04:40 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:13957 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaLBJEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 04:04:37 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <pebolle@tiscali.nl>, <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <alsa-devel@alsa-project.org>, Bo Shen <voice.shen@atmel.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] ASoC: Kconfig: remove not used SND_AT91_SOC_AFEB9260 option
Date: Tue, 2 Dec 2014 10:04:35 +0100
Message-ID: <1417511075-13725-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417461001.30245.35.camel@x220>
References: <1417461001.30245.35.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the driver snd-soc-afeb9260.c is deleted, remove its Kconfig option.

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Hi Paul,

Indeed, I forgot to include the Kconfig removal: sorry for the noise.

Mark,

I send another patch so that it is easier for you to stack it or squash it on
top of your branch. 

Thanks, bye.
 Nicolas

 sound/soc/atmel/Kconfig | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/sound/soc/atmel/Kconfig b/sound/soc/atmel/Kconfig
index 27e3fc4a536b..fb3878312bf8 100644
--- a/sound/soc/atmel/Kconfig
+++ b/sound/soc/atmel/Kconfig
@@ -52,12 +52,3 @@ config SND_AT91_SOC_SAM9X5_WM8731
 	help
 	  Say Y if you want to add support for audio SoC on an
 	  at91sam9x5 based board that is using WM8731 codec.
-
-config SND_AT91_SOC_AFEB9260
-	tristate "SoC Audio support for AFEB9260 board"
-	depends on ARCH_AT91 && ATMEL_SSC && ARCH_AT91 && MACH_AFEB9260 && SND_ATMEL_SOC
-	select SND_ATMEL_SOC_PDC
-	select SND_ATMEL_SOC_SSC
-	select SND_SOC_TLV320AIC23_I2C
-	help
-	  Say Y here to support sound on AFEB9260 board.
-- 
2.1.3

