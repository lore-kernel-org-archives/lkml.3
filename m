Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbaKZPPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 10:15:06 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59476 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752870AbaKZPPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 10:15:03 -0500
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org, broonie@kernel.org
Cc: cw00.choi@samsung.com, linus.walleij@linaro.org,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, ckeepax@opensource.wolfsonmicro.com
Subject: [PATCH V2 0/6] Add support for the WM8280 and WM8281 codecs
Date: Wed, 26 Nov 2014 15:13:02 +0000
Message-Id: <1417014788-8311-1-git-send-email-rf@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches adds support for the WM8280 and WM8281
codecs to the Wolfson Arizona drivers.

Only change since V1 series is update to device tree binding
documentation in patch 2

Richard Fitzgerald (6):
  mfd: arizona: add support for WM8280/WM8281
  Documentation: devicetree: arizona: Add bindings for WM8280
  regulator: arizona-micsupp: Add support for WM8280/WM8281
  gpio: arizona: Add support for WM8280/WM8281
  extcon: arizona: Add support for WM8280/WM8281
  ASoC: arizona: Add support for WM8280/WM8281

 Documentation/devicetree/bindings/mfd/arizona.txt |   15 +++++++++++----
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
 11 files changed, 37 insertions(+), 8 deletions(-)

-- 
1.7.2.5

