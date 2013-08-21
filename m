Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab3HUJ5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 05:57:12 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:49580 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab3HUJ5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 05:57:10 -0400
Date: Wed, 21 Aug 2013 10:57:04 +0100
From: Lee Jones <lee.jones@linaro.org>
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] For mfd-next, then onto v3.12
Message-ID: <20130821095704.GF29850@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 5ae90d8e467e625e447000cb4335c4db973b1095:

  Linux 3.11-rc3 (2013-07-28 20:53:33 -0700)

are available in the git repository at:

  git://git.linaro.org/people/ljones/mfd.git tags/mfd-lee-3.12-1

for you to fetch changes up to 8a105ca202b1a1061a24f1e980206cd2808e2f8b:

  mfd: pcf50633-adc: Use devm_*() functions (2013-08-20 09:27:35 +0100)

----------------------------------------------------------------
Hi Sam,

These are the patches due for the MFD Next tree.

If there are any dramas with them, please let me know.

Kind regards,
Lee

----------------------------------------------------------------
Alexander Shiyan (1):
      mfd: syscon: Remove "base" field from private driver data

Andrea Adami (2):
      mfd: mcp: Add missing linux/device.h header
      mfd: ucb1x00: Explicitely include linux/device.h

Ankur Raina (2):
      mfd: Fix for DA9055 driver initialization
      mfd: Update DA9055 i2c device id name

Benedikt Spranger (1):
      mfd: core: Copy DMA mask and params from parent

Bill Huang (1):
      mfd: palmas: Add power off control

Charles Keepax (5):
      mfd: arizona: Move regulator disable to after marking cache only
      mfd: wm5110: Mark register containing FLL gains as readable
      mfd: wm5110: Add mic detect level registers
      mfd: wm5110: Add missing Mic Detect 3 register into defaults
      mfd: wm5110: Set FX_CTRL2 to volatile

J Keerthy (1):
      mfd: Add TPS659038 documentation under Palmas

Jingoo Han (17):
      mfd: Use dev_get_platdata()
      mfd: max8997: Cast void pointer to data of max8997_pmic_dt_match
      mfd: lpc_ich: Staticize struct 'lpc_chipset_info'
      mfd: twl4030-power: Staticize local functions
      mfd: menelaus: Use NULL instead of 0
      MFD: ucb1x00-core: Add CONFIG_PM_SLEEP to suspend/resume
      mfd: ab8500-gpadc: Add CONFIG_PM_RUNTIME to runtime_suspend/runtime_resume
      mfd: ab8500-gpadc: Add CONFIG_PM_SLEEP to suspend/resume
      mfd: pm8921: Include missing linux/module.h
      mfd: pm8921: Remove unnecessary platform_set_drvdata()
      mfd: pm8921: Use devm_*() functions
      mfd: max8997: Use devm_*() functions
      mfd: max8998: Use devm_*() functions
      mfd: menelaus: Use devm_*() functions
      mfd: tps65010: Use devm_*() functions
      mfd: wl1273: Use devm_*() functions
      mfd: pcf50633-adc: Use devm_*() functions

Mark Brown (7):
      mfd: sec: Add register cache for interrupt mask registers
      mfd: wm8997: Make Kconfig prompt for WM8997 more consistent
      mfd: wm8994: Remove unneeded check for JACKDET
      mfd: wm8994: Remove check for active audio in runtime suspend
      mfd: wm831x: Remove erronious bits per word set
      mfd: stmpe: Staticise stmpe_of_probe()
      mfd: tps65010: Use power efficient workqueue for power polling

Michael Brunner (1):
      mfd: Add support for COMe-bHL6 and COMe-cTH6 to Kontron PLD driver

Patil, Rachna (2):
      MFD: ti_tscadc: ADC Clock check not required
      MFD: ti_tscadc: Disable TSC config registers in adc mode

Peter Ujfalusi (3):
      mfd: twl6040: Remove support for legacy (pdata) mode
      mfd: twl6040: Cosmetic, parameter alignment change
      mfd: twl6040: Cleanup in early error handling in probe function

Yadwinder Singh Brar (3):
      mfd: s2mps11: Add device tree support
      mfd: s2mps11: Remove clocks from regulators list
      mfd: sec: Add clock cell for s2mps11

Zubair Lutfullah (2):
      mfd: ti_am335x_tscadc: Fix spin lock and reg_cache
      mfd: ti_am335x_tscadc: Update reg_cache variable in clr function

 Documentation/devicetree/bindings/mfd/palmas.txt            |   2 ++
 Documentation/devicetree/bindings/mfd/s2mps11.txt           | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 Documentation/devicetree/bindings/regulator/palmas-pmic.txt |   5 +++++
 drivers/mfd/88pm800.c                                       |   2 +-
 drivers/mfd/88pm805.c                                       |   2 +-
 drivers/mfd/88pm860x-core.c                                 |   2 +-
 drivers/mfd/Kconfig                                         |   2 +-
 drivers/mfd/aat2870-core.c                                  |   2 +-
 drivers/mfd/ab3100-core.c                                   |   2 +-
 drivers/mfd/ab8500-gpadc.c                                  |   4 ++++
 drivers/mfd/adp5520.c                                       |   2 +-
 drivers/mfd/arizona-core.c                                  |   2 +-
 drivers/mfd/as3711.c                                        |   2 +-
 drivers/mfd/asic3.c                                         |   2 +-
 drivers/mfd/da903x.c                                        |   2 +-
 drivers/mfd/da9052-core.c                                   |   2 +-
 drivers/mfd/da9055-core.c                                   |   7 ++++++-
 drivers/mfd/da9055-i2c.c                                    |   2 +-
 drivers/mfd/dm355evm_msp.c                                  |   4 ++--
 drivers/mfd/ezx-pcap.c                                      |   6 +++---
 drivers/mfd/htc-egpio.c                                     |   2 +-
 drivers/mfd/htc-i2cpld.c                                    |  10 +++++-----
 drivers/mfd/htc-pasic3.c                                    |   2 +-
 drivers/mfd/intel_msic.c                                    |   4 ++--
 drivers/mfd/kempld-core.c                                   |  30 +++++++++++++++++++++++------
 drivers/mfd/lm3533-core.c                                   |   8 ++++----
 drivers/mfd/lp8788.c                                        |   2 +-
 drivers/mfd/lpc_ich.c                                       |   2 +-
 drivers/mfd/max77686.c                                      |   2 +-
 drivers/mfd/max77693.c                                      |   2 +-
 drivers/mfd/max8925-i2c.c                                   |   2 +-
 drivers/mfd/max8997.c                                       |  18 +++++++-----------
 drivers/mfd/max8998.c                                       |   7 +++----
 drivers/mfd/mcp-sa11x0.c                                    |   2 +-
 drivers/mfd/menelaus.c                                      |  22 +++++++++------------
 drivers/mfd/mfd-core.c                                      |   2 ++
 drivers/mfd/omap-usb-host.c                                 |   4 ++--
 drivers/mfd/palmas.c                                        |  33 ++++++++++++++++++++++++++++++--
 drivers/mfd/pcf50633-adc.c                                  |   3 +--
 drivers/mfd/pcf50633-core.c                                 |   2 +-
 drivers/mfd/pm8921-core.c                                   |  14 +++++---------
 drivers/mfd/rc5t583.c                                       |   2 +-
 drivers/mfd/sec-core.c                                      |  40 ++++++++++++++++++++++++++++++++++++--
 drivers/mfd/si476x-i2c.c                                    |   2 +-
 drivers/mfd/sm501.c                                         |   6 +++---
 drivers/mfd/sta2x11-mfd.c                                   |   4 ++--
 drivers/mfd/stmpe.c                                         |   3 ++-
 drivers/mfd/syscon.c                                        |   8 ++++----
 drivers/mfd/t7l66xb.c                                       |   8 ++++----
 drivers/mfd/tc3589x.c                                       |   2 +-
 drivers/mfd/tc6387xb.c                                      |   6 +++---
 drivers/mfd/tc6393xb.c                                      |   8 ++++----
 drivers/mfd/ti-ssp.c                                        |   2 +-
 drivers/mfd/ti_am335x_tscadc.c                              |  32 +++++++++++++++----------------
 drivers/mfd/tps6105x.c                                      |   2 +-
 drivers/mfd/tps65010.c                                      |  24 +++++++++++------------
 drivers/mfd/tps65090.c                                      |   2 +-
 drivers/mfd/tps6586x.c                                      |   2 +-
 drivers/mfd/tps65912-core.c                                 |   2 +-
 drivers/mfd/tps80031.c                                      |   2 +-
 drivers/mfd/twl-core.c                                      |   2 +-
 drivers/mfd/twl4030-audio.c                                 |   2 +-
 drivers/mfd/twl4030-madc.c                                  |   2 +-
 drivers/mfd/twl4030-power.c                                 |   8 ++++----
 drivers/mfd/twl6040.c                                       |  90 +++++++++++++++++++++++++++-----------------------------------------------------------
 drivers/mfd/ucb1400_core.c                                  |   2 +-
 drivers/mfd/ucb1x00-core.c                                  |   6 ++++--
 drivers/mfd/wl1273-core.c                                   |   8 ++------
 drivers/mfd/wm5110-tables.c                                 |  18 ++++++++++++++++++
 drivers/mfd/wm831x-core.c                                   |   2 +-
 drivers/mfd/wm831x-irq.c                                    |   2 +-
 drivers/mfd/wm831x-spi.c                                    |   1 -
 drivers/mfd/wm8350-i2c.c                                    |   3 ++-
 drivers/mfd/wm8400-core.c                                   |   2 +-
 drivers/mfd/wm8994-core.c                                   |  44 +-----------------------------------------
 drivers/mfd/wm8994-irq.c                                    |   2 +-
 include/linux/mfd/mcp.h                                     |   2 ++
 include/linux/mfd/palmas.h                                  |   1 +
 include/linux/mfd/samsung/s2mps11.h                         |   6 +-----
 include/linux/mfd/ti_am335x_tscadc.h                        |   1 -
 include/linux/mfd/twl6040.h                                 |   1 +
 include/linux/mfd/ucb1x00.h                                 |   1 +
 82 files changed, 417 insertions(+), 282 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/s2mps11.txt

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
