Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436Ab3CGEjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 23:39:09 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:48608 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704Ab3CGEjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 23:39:07 -0500
Date: Thu, 7 Mar 2013 12:38:59 +0800
From: Lee Jones <lee.jones@linaro.org>
To: cbouatmailru@gmail.com
Cc: sameo@linux.intel.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] AB8500 Power and MFD related updates
Message-ID: <20130307043859.GA11944@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6dbe51c251a327e012439c4772097a13df43c5b8:

  Linux 3.9-rc1 (2013-03-03 15:11:05 -0800)

are available in the git repository at:

  git://git.linaro.org/people/ljones/linux-3.0-ux500.git for-mfd-and-power

for you to fetch changes up to b09f86dbfc20d9420dac43dba016cb65b582c983:

  ab8500-charger: Do not use [delayed_]work_pending() (2013-03-07 12:35:59 +0800)

----------------------------------------------------------------
Daniel WILLERUD (1):
      mfd: ab8500-gpadc: Implemented suspend/resume

Dariusz Szymczak (1):
      mfd: ab8500-core: Hierarchical interrupt registers

Hakan Berg (3):
      ab8500-btemp: Filter btemp readings
      ab8500-fg: Allow capacity to raise from 1% when charging
      ab8500-charger: Add AB8505_USB_LINK_STATUS

Jonas Aaberg (3):
      mfd: ab8500-gpadc: Reread on failure
      mfd: ab8500-debug: Better error handling on crash
      mfd: ab8500-debug: Add wake-up info

Lee Jones (33):
      mfd: ab8500-gpadc: Add gpadc hw conversion
      mfd: ab8500-core: APE Interrupts are not cleared
      mfd: ab8500-debug: Function to save all ABB registers to mem
      mfd: ab8500-core: Add ADC support for ab8540
      mfd: ab8500-core: Rework MFD sub-device initialisation structures
      mfd: ab8500-core: Add Interrupt support for ab8540
      mfd: ab8500-debugfs: Add tests for ab8540 based platform initialisations
      mfd: ab8500-debug: Add support for ab8505 and ab9540
      mfd: ab8500-sysctrl: Add new reset function
      mfd: ab8500-gpadc: Add support for the AB8540
      mfd: ab8500-debug: Add support for the AB8540
      mfd: ab8500-gpadc: Optimise GPADC driver
      mfd: ab8500-core: Add additional resources to ab8505_iddet_resources
      mfd: ab8500-debugfs: Dump sim registers
      mfd: ab8500-debug: Add ADC input channel usb_id in debugfs
      mfd: ab8500-debugfs: Change AB8500 debug permissions
      mfd: ab8500-debug: Add register map for ab8540.
      mfd: ab8500-debugfs: Trivially beautify the debugfs driver
      pm2301_charger: Remove __exit, __init and __devexit_p()
      abx500-chargalg: Store the AB8500 MFD parent device for platform differentiation
      ab8500-fg: Add power cut feature for ab8505 and ab8540
      ab8500-charger: Trivial coding style changes
      ab8500-bm: Quick re-attach charging behaviour
      ab8500-bm: Charge only mode fixes for the ab9540
      ab8500_charger: Prevent auto drop of VBUS
      ab8500-bm: Add usb power path support
      ab8500-bm: Add support for the new ab8540 platform
      abx500-chargalg: Prevent the watchdog from being kicked twice
      ab8500-chargalg: Use hrtimer
      pm2301-charger: Add pm_runtime_resume & pm_runtime_suspend
      ab8500-charger: Remove duplicate code
      abx500-chargalg: Add charging current step interface
      ab8500-charger: Do not use [delayed_]work_pending()

Linus Walleij (1):
      mfd: ab8500-debug: Add explicit dependencies

M BenZoubeir (1):
      pm2301-charger: Adjust interrupt handler behavior

Marcus Cooper (4):
      pm2301-charger: Always compile the PM2301 Charger driver with AB8500 Battery Mgnt
      ab8500-charger: Use USBLink1Status Register
      ab8500-charger: Add UsbLineCtrl2 reference
      ab8500-bm: Trivially fix up some incorrect and out-of-date comments

Marcus Danielsson (1):
      mfd: ab8500-sysctrl: Error check clean up

Martin Bergstrom (1):
      ab8500-fg: Report unscaled capacity

Mattias Wallin (2):
      mfd: ab8500-debug: Print banks in hex
      mfd: ab8500-core: Show turn on status at boot

Mustapha Ben Zoubeir (1):
      pm2301-charger: Resolve I2C detection problem on ab9540

Per Forlin (1):
      pm2301-charger: Force main charger detect

Rabin Vincent (2):
      mfd: ab8500-sysctrl: AB8505 doesn't have SYSCLKREQ5..8
      ab8500-charger: Run detect workaround only on AB8500

Rajkumar Kasirajan (2):
      mfd: ab8500-sysctrl: Update correct turn on status
      pm2301-charger: Enable SW EOC control on the ab9540

Rupesh Kumar (8):
      pm2301-charger: Support for over voltage protection on the ab9540
      pm2301-charger: Die temp thermal protection
      pm2301-charger: Wake system when ext charger is plugged-in
      ab8500-btemp: Defer btemp filtering while initialising
      pm2301-charger: Removed unused code from PM2301 driver
      pm2301-charger: Charging LED control for pm2301
      pm2301-charger: Wake device on register access
      pm2301-charger: Reference put missing after access

Ulf Hansson (1):
      mfd: ab8500-core: Add abx500-clk as an mfd child device

Yang QU (1):
      ab8500-charger: Add backup battery charge voltages on the ab8540

lme00437 (2):
      pm2301-charger: lpn pin used only in C2C boards
      ab8500-fg: Change current calculation

srinidhi kasagar (2):
      mfd: ab8500-debug: Convert to kstrtoul_from_user
      abx500-chargalg: Use module_platform_driver() rather

 drivers/mfd/ab8500-core.c                 |  544 ++++++++++++++++++++++++---------
 drivers/mfd/ab8500-debugfs.c              | 2559 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------
 drivers/mfd/ab8500-gpadc.c                |  560 +++++++++++++++++++++++++++-------
 drivers/mfd/ab8500-sysctrl.c              |   98 +++++-
 drivers/power/Kconfig                     |    7 -
 drivers/power/Makefile                    |    3 +-
 drivers/power/ab8500_bmdata.c             |   96 +++++-
 drivers/power/ab8500_btemp.c              |   75 ++++-
 drivers/power/ab8500_charger.c            |  699 ++++++++++++++++++++++++++++++------------
 drivers/power/ab8500_fg.c                 |  497 +++++++++++++++++++++++++++++-
 drivers/power/abx500_chargalg.c           |  455 +++++++++++++++++++--------
 drivers/power/pm2301_charger.c            |  371 ++++++++++++++++------
 drivers/power/pm2301_charger.h            |   23 +-
 include/linux/mfd/abx500.h                |   21 +-
 include/linux/mfd/abx500/ab8500-bm.h      |   60 +++-
 include/linux/mfd/abx500/ab8500-gpadc.h   |   74 +++--
 include/linux/mfd/abx500/ab8500-sysctrl.h |    6 +
 include/linux/mfd/abx500/ab8500.h         |    3 +
 include/linux/mfd/abx500/ux500_chargalg.h |    7 +
 include/linux/pm2301_charger.h            |    2 +-
 20 files changed, 4835 insertions(+), 1325 deletions(-)

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
