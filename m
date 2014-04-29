Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933907AbaD2Lzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 07:55:50 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:36507 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933447AbaD2Lzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 07:55:49 -0400
From: Xia Kaixu <kaixu.xia@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: alsa-devel@alsa-project.org, broonie@kernel.org, lrg@slimlogic.co.uk,
        linaro-kernel@lists.linaro.org, arnd@arndb.de, kaixu.xia@linaro.org
Subject: [PATCH 00/15] ASoC: Arnds randconfig fixes for ASoC
Date: Tue, 29 Apr 2014 19:55:17 +0800
Message-Id: <1398772517-19953-1-git-send-email-kaixu.xia@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset series addresses various bugs found and fixed by Arnd Bergmann
whilst doing randconfig builds.

My involvement has been to review, add/check the maintainers are correct
and submit upstream to try and reduce the backlog.

Best Regards,

Kaixu Xia

Arnd Bergmann (11):
  ASoC: CS42L51 and WM8962 codecs depend on INPUT
  ASoC: davinci: add dependencies for SND_SOC_TLV320AIC3X
  ASoC: SMDK_WM8580_PCM needs REGMAP_I2C
  ASoC: samsung-idma: avoid 64-bit division
  ASoC: nuc900: export nuc900_ac97_data
  ASoC: RX-51 audio needs I2C
  ASoC: UDA1380 needs I2C
  ASoC: Atmel WM8904 codec support needs I2C
  ASoC: SND_S3C_DMA_LEGACY needs S3C24XX_DMA
  ASoC: Amstrad E3 needs TTY support for codec
  ASoC: pxa: remove mach header dependency

Xia Kaixu (4):
  ASoC: TTC DKB audio needs I2C
  ASoC: Migo-R sound needs I2C
  ASoC: TLV320AIC23 and Simtec Hermes audio need I2C
  ASoC: WM0010 needs SPI

 sound/arm/pxa2xx-pcm.c         |    2 ++
 sound/arm/pxa2xx-pcm.h         |    3 +--
 sound/soc/atmel/Kconfig        |    2 +-
 sound/soc/codecs/Kconfig       |    8 ++++----
 sound/soc/davinci/Kconfig      |   10 +++++-----
 sound/soc/fsl/Kconfig          |    2 +-
 sound/soc/nuc900/Kconfig       |    1 +
 sound/soc/nuc900/nuc900-ac97.c |    1 +
 sound/soc/omap/Kconfig         |    4 ++--
 sound/soc/pxa/Kconfig          |    2 +-
 sound/soc/pxa/pxa-ssp.c        |    2 --
 sound/soc/pxa/pxa2xx-pcm.c     |    2 ++
 sound/soc/samsung/Kconfig      |   22 ++++++++++------------
 sound/soc/samsung/idma.c       |    2 +-
 sound/soc/sh/Kconfig           |    2 +-
 15 files changed, 33 insertions(+), 32 deletions(-)

-- 
1.7.9.5

