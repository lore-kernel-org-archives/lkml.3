Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933674AbaKMRwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 12:52:13 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59005 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933357AbaKMRwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 12:52:11 -0500
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org, lgirdwood@gmail.com, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com, linus.walleij@linaro.org, gnurou@gmail.com,
        broonie@kernel.org, tiwai@suse.de
Cc: perex@perex.cz, sameo@linux.intel.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        ckeepax@opensource.wolfsonmicro.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        linux-gpio@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH 0/6] Add support for the WM8280 and WM8281 codecs
Date: Thu, 13 Nov 2014 17:50:40 +0000
Message-Id: <1415901046-3391-1-git-send-email-rf@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches adds support for the WM8280 and WM8281
codecs to the Wolfson Arizona drivers.

Richard Fitzgerald (6):
  mfd: arizona: add support for WM8280/WM8281
  Documentation: devicetree: arizona: Add bindings for WM8280
  regulator: arizona-micsupp: Add support for WM8280/WM8281
  gpio: arizona: Add support for WM8280/WM8281
  extcon: arizona: Add support for WM8280/WM8281
  ASoC: arizona: Add support for WM8280/WM8281

 Documentation/devicetree/bindings/mfd/arizona.txt |   10 ++++++----
 drivers/extcon/extcon-arizona.c                   |    1 +
 drivers/gpio/gpio-arizona.c                       |    1 +
 drivers/mfd/Kconfig                               |    5 +++--
 drivers/mfd/arizona-core.c                        |   14 ++++++++++++--
 drivers/mfd/arizona-i2c.c                         |    2 ++
 drivers/mfd/arizona-irq.c                         |    1 +
 drivers/mfd/arizona-spi.c                         |    2 ++
 drivers/regulator/arizona-micsupp.c               |    1 +
 include/linux/mfd/arizona/core.h                  |    1 +
 sound/soc/codecs/arizona.c                        |    2 ++
 11 files changed, 32 insertions(+), 8 deletions(-)

-- 
1.7.2.5

