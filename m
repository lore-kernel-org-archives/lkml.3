Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbbAQP0M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 10:26:12 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42015 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751344AbbAQP0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 10:26:09 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: broonie@kernel.org, cw00.choi@samsung.com, linus.walleij@linaro.org,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, rf@opensource.wolfsonmicro.com
Subject: [RESEND PATCH 0/6] Add support for the WM8280 and WM8281 codecs
Date: Sat, 17 Jan 2015 15:21:21 +0000
Message-Id: <1421508087-22311-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches adds support for the WM8280 and WM8281
codecs to the Wolfson Arizona drivers.

I made one small correction to the first patch to removed a
potentially uninitialised variable, but otherwise just a
resend of Richard's work. I would suggest we put the whole
series through the MFD tree I believe we have all the required
Acks and I don't believe there arn't any other patches making
their way through at the moment that this should conflict with.

Thanks,
Charles

Richard Fitzgerald (6):
  mfd: arizona: Add support for WM8280/WM8281
  Documentation: devicetree: arizona: Add bindings for WM8280
  regulator: arizona-micsupp: Add support for WM8280/WM8281
  gpio: arizona: Add support for WM8280/WM8281
  extcon: arizona: Add support for WM8280/WM8281
  ASoC: arizona: Add support for WM8280/WM8281

 Documentation/devicetree/bindings/mfd/arizona.txt |   15 +++++++++++----
 drivers/extcon/extcon-arizona.c                   |    1 +
 drivers/gpio/gpio-arizona.c                       |    1 +
 drivers/mfd/Kconfig                               |    5 +++--
 drivers/mfd/arizona-core.c                        |   15 +++++++++++++--
 drivers/mfd/arizona-i2c.c                         |    2 ++
 drivers/mfd/arizona-irq.c                         |    1 +
 drivers/mfd/arizona-spi.c                         |    2 ++
 drivers/regulator/arizona-micsupp.c               |    1 +
 include/linux/mfd/arizona/core.h                  |    1 +
 sound/soc/codecs/arizona.c                        |    2 ++
 11 files changed, 38 insertions(+), 8 deletions(-)

-- 
1.7.2.5

