Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab3A2Qlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 11:41:39 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54369 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab3A2Qlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 11:41:37 -0500
Date: Tue, 29 Jan 2013 16:41:31 +0000
From: Lee Jones <lee.jones@linaro.org>
To: broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, linus.walleij@linaro.org
Subject: [GIT PULL][FOR REVIEW] Regulators: Bring the AB8500 into the 20th
 century
Message-ID: <20130129164131.GN18212@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

As requested, the whole-shebang.

The Mainline AB8500 and DB8500 regulators are currently stuck in the
Victorian era (AKA v2.6.35). This branch contains all of the
upstreamable changes that have occurred on the internal repository and
aims to bring them back into the 20th century.

If you'd like me to sent the patches to the MLs for a better review
platform I can do, but I'd like to get permission before I go and
start upsetting people.

This branch contains 111 patches and has already gone though multiple
cycles of fixing-up, squashing, splitting and revert removal.

Enjoy!

Kind regards,
Lee

---

The following changes since commit 949db153b6466c6f7cad5a427ecea94985927311:

  Linux 3.8-rc5 (2013-01-25 11:57:28 -0800)

are available in the git repository at:

  git://git.linaro.org/people/ljones/linux-3.0-ux500.git tb-regulators

for you to fetch changes up to d3887ef58b60106677354e2f1314bc0f7cdeebf6:

  regulator: dbx500-prcmu: Add write access to reg_state and reg_name
  (2013-01-29 16:27:55 +0000)

----------------------------------------------------------------
Alexandre Torgue (2):
      regulator: ab8500: Provide full settings for AB8540 regulators
      regulator: ab8500: Correct init mask for AB8540

Bengt Jonsson (32):
      regulator: Suspend force is activated for power save profile
      regulator: ab8500-debug: Force off VextSupply3
      regulator: ab8500-debug: Fix build error when no CONFIG_PM
      regulator: ab8500-debug: Added debug function to record
      regulator registers
      regulator: ab8500-debug: Change board version numbering
      regulator: ab8500-debug: Removed ARM-controlled regulators from
      suspend-force
      regulator: Initialize Vrf1 regulator
      regulator: Removed suspend force of Vsmps1 and Vsmps2
      regulator: Added SysClkReq1 control of Vpll
      ARM: ux500: Vsmps3 controlled by SysClkReq1
      regulator: ab8500: Fix for regulator_set_mode functionality
      regulator: ab8500: Added get_optimum_mode on regulators with
      idle mode
      regulator: ab8500-debug: Remove force of VextSupplies on AB 3.x
      ARM: ux500: regulators: Add mask for configuration
      regulator: ab8500: Added more configurable bits
      regulator: ab8500: Removed initialization of body biasing
      regulator: ab8500-debug: Do not disable Vext3 during suspend
      regulator: ab8500: Separate regulator and MFD platform data
      regulator: ab8500: Add support of low voltage battery
      regulator: ab8500-ext: Cosmetic changes
      regulator: ab8500-ext: Add HW request support
      regulator: ab8500-ext: Add suspend support
      regulator: ab8500-ext: Add regulator_set_mode/get_mode
      regulator: ab8500-ext: Add VextSupply1 regulator
      regulator: ab8500-ext: Add VextSupply2 regulator
      regulator: ab8500: Remove USB regulator
      regulator: ab8500: Set current debug state as default
      regulator: ab8500: Remove Vsafe voltage settings
      regulator: ab8500: Remove Vsafe settings
      regulator: ab8500: Clean out SoC registers
      regulator: ab8500-debug: Remove TVOUTCTRL
      regulator: ab8500-ext: Add support for AB8505/AB9540

Carl-Johan Irekvist (1):
      regulator: ab8500-debug: Change boot-info address

Daniel WILLERUD (1):
      regulator: ab8500: Add AB8505 register initialization

David Paris (1):
      regulator: ab8500: Update VAna supply management for the AB9540

Emeric Vigier (1):
      regulator: ab8500: Add set_mode/get_mode support

Gabriel Fernandez (3):
      regulator: ab8500-ext: Adapt regulator registration for newly
      changed API
      regulator: ab8500: Use a struct to select the good regulator
      configuration
      regulator: of: Add regulator Device Tree properties

Jonas Aaberg (4):
      regulator: ab8500: Correct TVOUT regulator start-up delay
      regulator: ab8500-debug: Add read regulator status
      regulator: dbx500-prcmu: debug: Fast path usage info
      regulator: ab8500: Remove surplus include of id.h

Jorgen Jonsson (1):
      regulator: ab8500-debug: Remove not needed registers for AB8505

Lee Jones (21):
      regulator: Possibility to force extsupplies down in suspend
      regulator: Show consumers that hold a regulator in Sysfs
      ARM: ux500: Update displays in vaux1 consumer list
      regulator: ab8500: Init debug from regulator driver
      ARM: ux500: Add supply for the L3G4200D Gyroscope
      ARM: ux500: Add supply for the Proximity and Hal sensor
      ARM: ux500: Add supply for the Ambient light sensor device
      ARM: ux500: Add supply for the Pressure sensor
      ARM: ux500: Add supply for the Cypress TrueTouch Touchscreen
      ARM: ux500: Add supply for the MMIO Camera
      regulator: ab8500: Add support for the AB9540
      ARM: ux500: regulator: Use device IDs instead of device names
      regulator: ab8500-debug: Reorder update and save regulator
      registers
      regulator: ab8500-debug: Tiny cosmetic change
      regulator: ab8500-debug: Reorder the AB8500_REGU_VREF_DDR
      regulator: ab8500-debug: Add an update entry for
      AB8500_OTHER_TVOUT_CTRL
      regulator: dbx500: Place file in correct order
      regulator: ab8500: Use regulator_list_voltage_table()
      regulator: ab8500-debug: Fix suspend-force
      regulator: ab8500: Provide DT support for additional platforms
      regulator: ab8500-debug: Remove use of TVoutCtrl register

Loic Pallardy (1):
      regulator: dbx500-prcmu: Update debugfs services

Marcus Cooper (5):
      regulator: ab8500: Vaux5/6 cannot be disabled on the AB8540
      regulator: ab8500-debug: Add debugFS info for aux5/6
      regulator: ab8500: Correct regulator id values
      regulator: ab8500-debug: Move ab9540 specific settings to its
      own struct
      regulator: ab8500: Regulator vaux8 not declared using correct
      name

Marcus Danielsson (1):
      regulator: ab8500-debug: Fix coverity issue

Martin Persson (6):
      regulator: ab8500-debug: Update debugfs' ext regulator settings
      regulator: ab8500-debug: Added forced regulator registers in
      suspend
      regulator: ab8500-debug: Restore regulator registers in reverse
      order
      regulator: ab8500-debug: Remove vana and vpll from suspend force
      regulator: ab8500: Remove VBB from suspend force
      regulator: Add init values for vsmps1/2

Mattias Wallin (6):
      regulator: ab8500-debug: AB8505 debug settings not initialized
      regulator: ab8500: add support for ab8505
      regulator: ab8500: Provide ExtSupply register init values for
      AB8505
      regulator: ab8500: Change mode fix for LDO USB
      ARM: ux500: regulators: Add LDO USB consumer
      regulator: ab8500: Default value on LDO USB to HP

Mian Yousaf Kaukab (3):
      regulator: ab8500-debug: Update the VextSupplies fix
      regulator: ab8500-debug: Update suspend force value for
      ExtSupplyRegu
      regulator: dbx500-prcmu: Show status of atomic regulators

Michel JAOUEN (2):
      regulator: ab8500-ext: Add support for AB9540 regulators
      regulator: ab8500: Update AB9540 init masks

Mustapha Ben Zoubeir (1):
      regulator: ab8500: Delete useless fixed_uV field

Philippe Langlais (3):
      regulator: ab8500: dbx500: Add module.h for when building as a
      module
      ARM: ux500: Partially revert changes surrounding audio
      regulators
      regulator: dbx500-prcmu: Provide atomic regulators

Rabin Vincent (5):
      regulator: ab8500: Remove bogus error messages
      ARM ux500: Remove external regulators from AB8505 init data
      regulator: ab8500: Don't register external regulators on AB8505
      regulator: ab8500: Add voltage selection for AUDIO and ANA on
      AB8505
      regulator: ab8500-debug: Remove incorrect error messages

Rickard Andersson (1):
      regulator: ab8500: Add mode operation for v-amic

Zhenhua HUANG (6):
      regulator: ab8500: Add VSDIO definition for the AB8540
      regulator: ab8500: Fix vsdio parameters for AB8540 based
      platforms
      regulator: ab8500: Remove vusb from AB8540 regulator framework
      regulator: ab8500: Update vdmic, vamic[1|2] parameters for
      AB8540
      regulator: ab8500: Introduce aux5, aux6 regulators for AB8540
      regulator: dbx500-prcmu: Add write access to reg_state and
      reg_name

carriere etienne (2):
      regulator: dbx500-prcmu: Support DB8540 new ePODs
      regulator: db8500-prcmu: Fix esram23 name when relating to
      DB8540

xiaomei.zhang (2):
      regulator: ab8500: Also check for AB8505 based platforms
      regulator: ab8500: Add new operations for Vaux3

 .../devicetree/bindings/regulator/regulator.txt    |    5 +
 arch/arm/mach-ux500/board-mop500-regulators.c      |  749 ++++-
 arch/arm/mach-ux500/board-mop500-regulators.h      |    7 +-
 drivers/mfd/ab8500-core.c                          |    3 +
 drivers/regulator/Kconfig                          |   16 +
 drivers/regulator/Makefile                         |    2 +
 drivers/regulator/ab8500-debug.c                   | 2154
 +++++++++++++++
 drivers/regulator/ab8500-debug.h                   |   83 +
 drivers/regulator/ab8500-ext.c                     |  475 ++++
 drivers/regulator/ab8500.c                         | 2850
 ++++++++++++++++++--
 drivers/regulator/core.c                           |   37 +
 drivers/regulator/db8500-prcmu.c                   |   70 +-
 drivers/regulator/dbx500-prcmu.c                   |  322 ++-
 drivers/regulator/dbx500-prcmu.h                   |    3 +-
 drivers/regulator/of_regulator.c                   |   18 +
 include/linux/regulator/ab8500-debug.h             |   16 +
 include/linux/regulator/ab8500.h                   |  216 +-
 include/linux/regulator/db8500-prcmu.h             |    7 +-
 include/linux/regulator/dbx500-prcmu.h             |   92 +
 19 files changed, 6858 insertions(+), 267 deletions(-)
 create mode 100644 drivers/regulator/ab8500-debug.c
 create mode 100644 drivers/regulator/ab8500-debug.h
 create mode 100644 drivers/regulator/ab8500-ext.c
 create mode 100644 include/linux/regulator/ab8500-debug.h
 create mode 100644 include/linux/regulator/dbx500-prcmu.h

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
