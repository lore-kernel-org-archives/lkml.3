Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab3BUVND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 16:13:03 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:55564 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309Ab3BUVM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 16:12:58 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL 08/09] arm-soc: device tree conversions
Date: Thu, 21 Feb 2013 21:12:28 +0000
Message-Id: <1361481149-27559-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361481149-27559-1-git-send-email-arnd@arndb.de>
References: <1361481149-27559-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:i0XDag5ZGM5pB4bgQGBCmmpL6W+ubTnrVqzr3g+L24r
 EOoXRljKYHHt79YpqGUit/uplObaCiIJN46NWqeBcikmuFS5WR
 y5RozsphA2ZHr24ASV/XuAmeFw1rMR6u+ovWfhk8VJuCSb1/Fi
 /zM9I9RUbQkupZlj31iynSzEYNfDDEWPMzJiq98wcRn+xOAFxZ
 Nf4LGdSEff3iksSoaucneWRSkiZU9SWOSW0Uw2lZFUPkZXS5N8
 dTSWJ+anbW6v6RAxUMaPceHqUoEZh6+4FC6Fo9tTWQNIY5EYAs
 K0zHVFsHFkJIoa2HvYGO4apcFvdLst9jDXNwggdikIuKHTpt9L
 GNBiPv4pHpWNVjeKiXYv51IXJeL5dg0NrMwjboJJB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f7c66dc0bf0f4ecd349c79315c87841c67e27aef:

  ARM: tegra: remove empty tegra_smp_init_cpus() (2013-02-05 13:13:08 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/dt

for you to fetch changes up to 89dfe564b5926297ee29b973fe75e25c83c5e615:

  Merge tag 'tegra-for-3.9-soc-ccf-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-tegra into next/dt (2013-02-19 22:38:51 +0100)

----------------------------------------------------------------

arm-soc: device tree conversions

These are device tree conversions for a number of platforms,
with the intention of turning code from board files into
device tree descriptions. Notable changes are:

* davinci bindings for pinctrl, MTD, RTC, watchdog and i2c
* nomadik bindings for all devices, removing the board files
* bcm2835 bindings for mmc and i2c
* tegra bindings for hdmi, keyboard, audio, as well as some updates
* at91 bindings for hardware ecc and for devices on RM9200
* mxs bindings for cfa100xx
* sunxi support for Miniand Hackberry board

----------------------------------------------------------------
Arnd Bergmann (4):
      Revert "sunxi: a13-olinuxino: Add user LED to the device tree"
      Revert "sunxi: a10-cubieboard: Add user LEDs to the device tree"
      Merge tag 'tegra-for-3.9-soc-ccf-fixes' of git://git.kernel.org/.../swarren/linux-tegra into next/dt

Bryan Wu (3):
      ARM: DT: tegra: Unify the description of Tegra20 boards
      ARM: DT: tegra: Add board level compatible properties
      ARM: DT: tegra: Add Tegra30 Beaver board support

Emilio López (1):
      sunxi: a10-cubieboard: Add user LEDs to the device tree

Hiroshi Doyu (2):
      ARM: dt: tegra20: Rename "gart" to "iommu"
      ARM: dt: tegra30: Rename "smmu" to "iommu"

Jean-Christophe PLAGNIOL-VILLARD (1):
      ARM: at91: Animeo IP: enable watchdog support

Joachim Eastwood (3):
      ARM: at91: add MMC bindings to RM9200 DT
      ARM: at91: add SSC bindings to RM9200 DT
      ARM: at91: add EMAC bindings to RM9200 DT

Joseph Lo (1):
      clk: tegra: fix wrong clock index between se to sata_cold

Josh Wu (2):
      ARM: at91: at91sam9x5: add DT parameters to enable PMECC
      ARM: at91: at91sam9n12: add DT parameters to enable PMECC

Kumar, Anil (5):
      ARM: davinci: da850: add pinctrl driver DT entries
      ARM: davinci: da850: add NAND driver DT entries
      ARM: davinci: da8xx defconfig: enable pinctrl config option
      ARM: davinci: da850: add wdt DT node
      ARM: davinci: da850 DT: add support for machine reboot

Lad, Prabhakar (1):
      ARM: davinci: da850: move interrupt-parent property to soc node

Laxman Dewangan (8):
      ARM: tegra30: tegra30 gpio is not compatible with tegra20 gpio
      ARM: tegra: dts: add aliases and DMA requestor for serial controller
      ARM: tegra: add DT entry for KBC controller
      ARM: tegra: seaboard: enable keyboard in DT
      ARM: tegra: cardhu: register UARTC
      ARM: tegra: whistler: enable keyboard in DT
      ARM: tegra: harmony: enable keyboard in DT
      clk: tegra: initialise parent of uart clocks

Linus Walleij (12):
      ARM: nomadik: move last custom calls to pinctrl
      ARM: nomadik: initial devicetree support
      ARM: nomadik: move pin maps to cpu file
      ARM: nomadik: move remaining PrimeCells to device tree
      ARM: nomadik: add FSMC NAND
      ARM: nomadik: move GPIO and pinctrl to device tree
      ARM: nomadik: convert SMSC91x ethernet to device tree
      ARM: nomadik: migrate MMC/SD card support to device tree
      ARM: nomadik: add I2C devices to the device tree
      ARM: nomadik: delete old board files
      ARM: nomadik: get rid of <mach/hardware.h>
      ARM: nomadik: fix OF compilation regression

Lucas Stach (4):
      ASoC: tegra: add ac97 host controller to device tree
      ARM: tegra: move serial clock-frequency attr into the Tegra20 dtsi
      ARM: tegra: Add Colibri T20 512MB COM device tree
      ARM: tegra: Add Toradex Iris carrier board DT with T20 512MB COM

Marek Vasut (1):
      ARM: mxs: Enable touchscreen on m28evk

Maxime Ripard (9):
      ARM: dts: cfa10049: Add PCA9555 GPIO expander to the device tree
      ARM: sunxi: Add device tree for Miniand Hackberry
      ARM: mxs: dt: Add Crystalfontz CFA-10037 device tree support
      ARM: dts: cfa10049: Change the SPI3 bus to spi-gpio
      ARM: dts: mxs: Add muxing options for the third PWM
      ARM: dts: mxs: Add the LCD to the 10049 board
      ARM: mxs: dts: Add gpio-keys for the rotary to the CFA-10049
      ARM: mxs: dts: Add rotary encoder to the CFA-10049
      sunxi: a13-olinuxino: Add user LED to the device tree

Mrugesh Katepallewar (1):
      ARM: davinci: da850: add RTC DT entries

Olof Johansson (12):
      Merge tag 'davinci-for-v3.9/dt' of git://gitorious.org/linux-davinci/linux-davinci into next/dt
      Merge branch 'depends/cleanup' into next/dt
      Merge tag 'nmk-dt-on-cleanups' of git://git.kernel.org/.../linusw/linux-nomadik into next/dt
      Merge tag 'bcm2835-for-3.9-dt' of git://git.kernel.org/.../swarren/linux-rpi into next/dt
      Merge tag 'v3.8-rc6' into next/dt
      Merge branch 'next/soc' into next/dt
      Merge tag 'tegra-for-3.9-dt' of git://git.kernel.org/.../swarren/linux-tegra into next/dt
      Merge tag 'at91-dt' of git://github.com/at91linux/linux-at91 into next/dt
      Merge tag 'davinci-for-v3.9/dt-2' of git://gitorious.org/linux-davinci/linux-davinci into next/dt
      Merge tag 'mxs-dt-3.9' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/dt
      Merge tag 'sunxi-dt-for-3.9' of https://github.com/mripard/linux into next/dt
      Merge tag 'at91-dt-late' of git://github.com/at91linux/linux-at91 into next/dt

Peter De Schrijver (3):
      clk: tegra: Implement locking for super clock
      clk: tegra: Add missing spinlock for hclk and pclk
      clk: tegra: local arrays should be static

Stephen Warren (12):
      ARM: bcm2835 rpi: remove hard-coded memreserve from DT
      ARM: bcm2835: add SDHCI node to DT
      ARM: bcm2835: add I2C controllers to DT
      ARM: bcm2835: fix clock node aliasing in device tree
      ARM: tegra: trimslice: add gpio-poweroff node to DT
      ARM: tegra: seaboard: enable HDMI port
      ARM: tegra: ventana: enable HDMI port
      ARM: tegra: paz00: enable HDMI port
      ARM: tegra: swap cache-/interrupt-ctrlr nodes in DT
      ARM: tegra: move serial clock-frequency attr into the Tegra30 dtsi
      clk: tegra: fix driver to match DT binding
      ARM: tegra: remove clock-frequency properties from serial nodes

Vishwanathrao Badarkhe, Manish (1):
      ARM: davinci: da850: add DT node for I2C0

 .../devicetree/bindings/arm/ste-nomadik.txt        |  27 ++
 Documentation/devicetree/bindings/arm/tegra.txt    |  32 +-
 .../devicetree/bindings/mtd/fsmc-nand.txt          |   2 +-
 arch/arm/Kconfig                                   |   2 +
 arch/arm/arm-soc-for-next-contents.txt             |  48 +-
 arch/arm/boot/dts/Makefile                         |   5 +
 arch/arm/boot/dts/animeo_ip.dts                    |   4 +
 arch/arm/boot/dts/at91rm9200.dtsi                  | 158 +++++++
 arch/arm/boot/dts/at91rm9200ek.dts                 |   5 +
 arch/arm/boot/dts/at91sam9n12.dtsi                 |   3 +-
 arch/arm/boot/dts/at91sam9n12ek.dts                |   5 +-
 arch/arm/boot/dts/at91sam9x5.dtsi                  |   4 +
 arch/arm/boot/dts/at91sam9x5cm.dtsi                |   5 +-
 arch/arm/boot/dts/bcm2835-rpi-b.dts                |  16 +-
 arch/arm/boot/dts/bcm2835.dtsi                     |  44 ++
 arch/arm/boot/dts/da850-evm.dts                    |  20 +
 arch/arm/boot/dts/da850.dtsi                       |  70 ++-
 arch/arm/boot/dts/imx28-cfa10037.dts               |  77 ++++
 arch/arm/boot/dts/imx28-cfa10049.dts               | 214 +++++++--
 arch/arm/boot/dts/imx28-m28evk.dts                 |   1 +
 arch/arm/boot/dts/imx28.dtsi                       |  10 +
 arch/arm/boot/dts/ste-nomadik-s8815.dts            |  30 ++
 arch/arm/boot/dts/ste-nomadik-stn8815.dtsi         | 256 +++++++++++
 arch/arm/boot/dts/sun4i-a10-hackberry.dts          |  30 ++
 arch/arm/boot/dts/tegra20-colibri-512.dtsi         | 491 +++++++++++++++++++++
 arch/arm/boot/dts/tegra20-harmony.dts              | 120 ++++-
 arch/arm/boot/dts/tegra20-iris-512.dts             |  89 ++++
 arch/arm/boot/dts/tegra20-paz00.dts                |  22 +-
 arch/arm/boot/dts/tegra20-seaboard.dts             | 158 ++++++-
 arch/arm/boot/dts/tegra20-tamonten.dtsi            |   1 -
 arch/arm/boot/dts/tegra20-trimslice.dts            |  11 +-
 arch/arm/boot/dts/tegra20-ventana.dts              |  23 +-
 arch/arm/boot/dts/tegra20-whistler.dts             |  15 +-
 arch/arm/boot/dts/tegra20.dtsi                     |  67 ++-
 arch/arm/boot/dts/tegra30-beaver.dts               | 373 ++++++++++++++++
 arch/arm/boot/dts/tegra30-cardhu.dtsi              |  15 +-
 arch/arm/boot/dts/tegra30.dtsi                     |  61 ++-
 arch/arm/configs/da8xx_omapl_defconfig             |   1 +
 arch/arm/mach-at91/at91rm9200.c                    |   2 +
 arch/arm/mach-davinci/Kconfig                      |   1 +
 arch/arm/mach-davinci/da8xx-dt.c                   |   9 +-
 arch/arm/mach-davinci/devices-da8xx.c              |  12 +-
 arch/arm/mach-davinci/include/mach/da8xx.h         |   1 -
 arch/arm/mach-mxs/mach-mxs.c                       |  30 ++
 arch/arm/mach-nomadik/Kconfig                      |  10 +-
 arch/arm/mach-nomadik/Makefile                     |   6 -
 arch/arm/mach-nomadik/board-nhk8815.c              | 353 ---------------
 arch/arm/mach-nomadik/cpu-8815.c                   | 358 +++++++++++----
 arch/arm/mach-nomadik/cpu-8815.h                   |   4 -
 arch/arm/mach-nomadik/i2c-8815nhk.c                |  88 ----
 arch/arm/mach-nomadik/include/mach/hardware.h      |  90 ----
 arch/arm/mach-nomadik/include/mach/irqs.h          |   2 -
 arch/arm/mach-nomadik/include/mach/uncompress.h    |   1 -
 drivers/clk/tegra/clk-super.c                      |  18 +-
 drivers/clk/tegra/clk-tegra20.c                    |  22 +-
 drivers/clk/tegra/clk-tegra30.c                    |  47 +-
 drivers/mtd/nand/fsmc_nand.c                       |   1 +
 drivers/pinctrl/pinctrl-nomadik.c                  |   4 +
 58 files changed, 2787 insertions(+), 787 deletions(-)
