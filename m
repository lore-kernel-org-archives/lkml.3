Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab3EOJE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:04:58 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:39707 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab3EOJE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:04:56 -0400
Date: Wed, 15 May 2013 10:04:49 +0100
From: Lee Jones <lee.jones@linaro.org>
To: sameo@linux.intel.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, arnd@arndb.de,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [GIT PULL v2] MFD: Fixes due for the v3.10 -rc:s
Message-ID: <20130515090449.GA3494@gmail.com>
References: <20130514091956.GG3297@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130514091956.GG3297@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

Since v1 of my MFD -fixes pull-request, I have applied a few more
patches which really should be entered into the -rc:s. As it appears
that you have not yet pulled v1, I figured sending a v2 in its place
would be appropriate, so here it is.

-----

The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://git.linaro.org/people/ljones/mfd.git for-mfd-fixes

for you to fetch changes up to 27df65e061f51f6bd2c8e9ad6b505c8dbab6460c:

  mfd: db8500-prcmu: Update stored DSI PLL divider value (2013-05-14 15:58:04 +0100)

----------------------------------------------------------------
Arnd Bergmann (1):
      mfd: ab8500: Debugfs code depends on gpadc

Fabio Baltieri (5):
      mfd: abx500-core: Fix sparse warning
      mfd: ab8500-sysctrl: Fix sparse warning
      mfd: ab8500-sysctrl: Set sysctrl_dev during probe
      mfd: ab8500-sysctrl: Let sysctrl driver work without pdata
      mfd: ab8500-sysctrl: Always enable pm_power_off handler

Lee Jones (4):
      mfd: ab8500-gpadc: Suppress 'ignoring regulator_enable() return value' warning
      mfd: ab8500-core: Use the correct driver name when enabling gpio/pinctrl
      mfd: db8500-prcmu: Supply the pdata_size attribute for db8500-thermal
      mfd: ab8500-core: Pass GPADC compatible string to MFD core

Linus Walleij (1):
      mfd: ab8500: Pass AB8500 IRQ to debugfs code by resource

Ulf Hansson (1):
      mfd: db8500-prcmu: Update stored DSI PLL divider value

 drivers/mfd/Kconfig               |    2 +-
 drivers/mfd/ab8500-core.c         |   24 +++++++++++++++++++++---
 drivers/mfd/ab8500-debugfs.c      |   16 ++++++++++++----
 drivers/mfd/ab8500-gpadc.c        |    7 +++++--
 drivers/mfd/ab8500-sysctrl.c      |   15 ++++++++++-----
 drivers/mfd/abx500-core.c         |    2 +-
 drivers/mfd/db8500-prcmu.c        |    3 +++
 include/linux/mfd/abx500/ab8500.h |    2 --
 8 files changed, 53 insertions(+), 18 deletions(-)

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
