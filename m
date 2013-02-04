Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab3BDJ0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 04:26:39 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:46765 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab3BDJ0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 04:26:37 -0500
Date: Mon, 4 Feb 2013 09:26:31 +0000
From: Lee Jones <lee.jones@linaro.org>
To: sameo@linux.intel.com
Cc: linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] mfd: First patch-set to update the AB8500 series
Message-ID: <20130204092631.GV2042@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 949db153b6466c6f7cad5a427ecea94985927311:

  Linux 3.8-rc5 (2013-01-25 11:57:28 -0800)

are available in the git repository at:

  git://git.linaro.org/people/ljones/linux-3.0-ux500.git for-mfd

for you to fetch changes up to 8908c04985ed67b9138c6e06be2c81867f24e2d4:

  mfd: ab8500-gpadc: Use new ab8500_gpadc_get() with name parameter (2013-02-04 08:33:30 +0000)

----------------------------------------------------------------
Ashok G (1):
      mfd: ab8500-debugfs: sizeof() mismatch bugfix

Bengt Jonsson (1):
      mfd: ab8500-debugfs: Add interrupt debug

John Beckett (1):
      mfd: ab8500-debugfs: Export all AB8500 ADCs as debugfs nodes

Jonas Aaberg (4):
      mfd: ab8500-sysctrl: If a charger is present, reboot instead
      mfd: ab8500-sysctrl: Only reboot into charging mode if battery type is known
      mfd: ab8500-sysctrl.c: Provide charging as reset reason
      mfd: ab8500-sysctrl: export read/write symbols

Kennet Wallden (1):
      mfd: ab8500-sysctrl: Provide configuration for SysClkReqRfClkBuf registers

Lee Jones (7):
      mfd: ab8500-sysctrl: Provide a platform specific pm_power_off() call-back
      mfd: ab8500-gpadc: Change to usleep_range() for greater resolution
      mfd: ab8500-debugfs: Provide a means for a user subscribe to IRQs
      mfd: ab8500-debugfs: Use NULL to initialise remaining NULL pointer
      mfd: ab8500-gpadc: Add runtime pm support
      mfd: ab8500-gpadc: Reduce conversion timeout
      mfd: ab8500-gpadc: Remove unused 'struct ab8500_gpadc'

Linus Walleij (1):
      mfd: ab8500-debugfs: Allow number of IRQs to be provided more dynamically

Mattias Wallin (1):
      mfd: ab8500-debugfs: Keep count of IRQs in debugfs

Mian Yousaf Kaukab (3):
      mfd: abx500-core: Provide an API to dump all ABx500 registers
      mfd: ab8500-debugfs: add debugfs node to read all registers
      mfd: ab8500-core: Allow the possibility to dump all AB8500 registers

Michel JAOUEN (1):
      mfd ab8500-gpadc: Introduce new AB version detection

Philippe Langlais (2):
      mfd: ab8500-debugfs: Set the USB charging current to 300mA for ABV3
      mfd: ab8500-gpadc: Use new ab8500_gpadc_get() with name parameter

carriere etienne (1):
      mfd: ab8500-debugfs: Formated access AB8500 registers from debugfs entry

 drivers/mfd/ab8500-core.c                 |    2 +
 drivers/mfd/ab8500-debugfs.c              | 1249 +++++++++++++++++++++++++++--
 drivers/mfd/ab8500-gpadc.c                |   90 ++-
 drivers/mfd/ab8500-sysctrl.c              |   92 +++
 drivers/mfd/abx500-core.c                 |   16 +
 include/linux/mfd/abx500.h                |    2 +
 include/linux/mfd/abx500/ab8500-sysctrl.h |    5 +
 include/linux/mfd/abx500/ab8500.h         |   12 +
 8 files changed, 1394 insertions(+), 74 deletions(-)

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
