Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab3GBTTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 15:19:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51742 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab3GBTTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 15:19:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL 7/7] ARM SoC late changes
Date: Tue, 2 Jul 2013 21:14:19 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
References: <201307022055.50717.arnd@arndb.de>
In-Reply-To: <201307022055.50717.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307022114.19228.arnd@arndb.de>
X-Provags-ID: V02:K0:yZs9/c+HZ8+xWgQeq2M2u92do5waDC70X8bU8+mB6+R
 jXVK4zjMrpKvhtTY4UW7y+8BbG7OMlGjImewskOflsfcxFv+ZQ
 jLxz0oTz/hpx2kBNAjUg7CFVCBzI2vTRgkvR11BlCbXNXHLyNm
 MDkRqdARGicnn5r+B1CshD4KMM018wqE1DSjFCgmfJ+cPOBbcT
 dmVqi0ORkHk4rXEh0m1p6GV+XUN6CVv+/VCjaEzR74LQUGyhY9
 6F99TxhEqn33sntxUgUtl1LwT7WPXqv2aNSQT0v+y0wWzITMqP
 nvN6D6UyrxrSrJaXzvd0ulD8O0T83kDC4vJSh3Lm+519pR42aM
 nM4qmAEBfiB3YKhZGJtg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7d132055814ef17a6c7b69f342244c410a5e000f:

  Linux 3.10-rc6 (2013-06-15 11:51:07 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/late-for-linus

for you to fetch changes up to 8c3d913888cfb0066d62831969c3a992f7e4aba5:

  Merge tag 'msm-clock-for-3.11b' of git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm into next/late (2013-06-27 17:04:27 -0700)

----------------------------------------------------------------

ARM SoC late changes

These are changes that arrived a little late before the merge
window or that have multiple dependencies on previous branches
so they did not fit into one of the earlier ones. There
are 10 branches merged here, a total of 39 non-merge commits.
Contents are a mixed bag for the above reasons:

* Two new SoC platforms: ST microelectronics stixxxx and
  the TI 'Nspire' graphing calculator. These should have
  been in the 'soc' branch but were a little late
* Support for the Exynos 5420 variant in mach-exynos,
  which is based on the other exynos branches to avoid
  conflicts.
* Various small changes for sh-mobile, ux500 and davinci
* Common clk support for MSM

Conflicts:
* In Kconfig.debug, various additions trivially conflict,
  the list should be kept in alphabetical order when
  resolving.

----------------------------------------------------------------

Arnd Bergmann (6):
      Merge tag 'renesas-cleanup-for-v3.11' of git://git.kernel.org/.../horms/renesas into next/late
      Merge tag 'soc-exynos5420-1' of git://git.kernel.org/.../kgene/linux-samsung into next/late
      Merge branch 'renesas/boards2' into next/late
      Merge tag 'renesas-sh-sci-for-v3.11' of git://git.kernel.org/.../horms/renesas into next/late
      Merge tag 'davinci-for-v3.11/dt' of git://git.kernel.org/.../nsekhar/linux-davinci into next/late
      Merge tag 'late-for-linus' into for-linus

Chander Kashyap (10):
      ARM: dts: fork out common EXYNOS5 nodes
      ARM: dts: list the CPU nodes for EXYNOS5250
      ARM: EXYNOS: Add support for EXYNOS5420 SoC
      serial: samsung: select EXYNOS specific driver data if ARCH_EXYNOS is defined
      ARM: EXYNOS: use four additional chipid bits to identify EXYNOS family
      clk: exynos5420: register clocks using common clock framework
      ARM: dts: Add initial device tree support for EXYNOS5420
      clocksource: exynos_mct: use (request/free)_irq calls for local timer registration
      ARM: EXYNOS: add secondary CPU boot base location for EXYNOS5420
      ARM: EXYNOS: extend soft-reset support for EXYNOS5420

Daniel Tang (2):
      arm: Add device trees for TI-Nspire hardware
      arm: Add Initial TI-Nspire support

Kuninori Morimoto (1):
      ARM: shmobile: r8a7790: add __initdata on resource and device data

Leela Krishna Amudala (2):
      ARM: dts: add pinctrl support to EXYNOS5420
      pinctrl: exynos: add exynos5420 SoC specific data

Linus Walleij (1):
      ARM: ux500: bail out on alien cpus

Manjunathappa, Prakash (1):
      ARM: davinci: da850: adopt to pinctrl-single change for configuring multiple pins

Olof Johansson (5):
      Merge tag 'soc-exynos5420-2' of git://git.kernel.org/.../kgene/linux-samsung into next/late
      Merge branch 'nspire/soc' into next/late
      Merge branch 'sti/soc' into next/late
      Merge branch 'msm/fixes' into next/late
      Merge tag 'msm-clock-for-3.11b' of git://git.kernel.org/.../davidb/linux-msm into next/late

Philip Avinash (1):
      ARM: davinci: da850: Use #include for all device trees

Simon Horman (2):
      Merge tags 'renesas-pinmux-for-v3.11' and 'renesas-soc-for-v3.11' into cleanup
      serial: sh-sci: Initialise variables before access in sci_set_termios()

Srinivas Kandagatla (5):
      ARM: sti: Add STiH415 SOC support
      ARM: sti: Add STiH416 SOC support
      ARM: sti: Add DEBUG_LL console support
      ARM: stih41x: Add B2000 board support
      ARM: stih41x: Add B2020 board support

Stephen Boyd (12):
      msm_serial: Convert to clk_prepare/unprepare
      msm_serial: Use devm_clk_get() and properly return errors
      usb: otg: msm: Convert to clk_prepare/unprepare
      msm_sdcc: Convert to clk_prepare/unprepare
      msm: iommu: Convert to clk_prepare/unprepare
      msm: iommu: Use clk_set_rate() instead of clk_set_min_rate()
      ARM: msm: Remove custom clk_set_flags() API
      ARM: msm: Remove custom clk_set_{max,min}_rate() API
      ARM: msm: Remove clock-7x30.h include file
      ARM: msm: Prepare clk_get() users in mach-msm for clock-pcom driver
      ARM: msm: Make proc_comm clock control into a platform driver
      ARM: msm: Migrate to common clock framework

Ulrich Hecht (3):
      serial: sh-sci: HSCIF support
      ARM: shmobile: r8a7790: HSCIF support
      ARM: shmobile: r8a7790: don't use external clock for SCIFs

 Documentation/arm/sti/overview.txt                 |  33 +
 Documentation/arm/sti/stih415-overview.txt         |  12 +
 Documentation/arm/sti/stih416-overview.txt         |  12 +
 Documentation/devicetree/bindings/arm/nspire.txt   |  14 +
 .../devicetree/bindings/clock/exynos5420-clock.txt | 201 ++++++
 .../bindings/pinctrl/samsung-pinctrl.txt           |   1 +
 .../devicetree/bindings/vendor-prefixes.txt        |   1 +
 MAINTAINERS                                        |   9 +
 arch/arm/Kconfig                                   |   6 +-
 arch/arm/Kconfig.debug                             |  52 ++
 arch/arm/Makefile                                  |   2 +
 arch/arm/boot/dts/Makefile                         |   8 +
 arch/arm/boot/dts/da850-enbw-cmc.dts               |   2 +-
 arch/arm/boot/dts/da850-evm.dts                    |   2 +-
 arch/arm/boot/dts/da850.dtsi                       |   4 +-
 arch/arm/boot/dts/exynos5.dtsi                     | 111 +++
 arch/arm/boot/dts/exynos5250.dtsi                  |  78 +--
 arch/arm/boot/dts/exynos5420-pinctrl.dtsi          | 680 ++++++++++++++++++
 arch/arm/boot/dts/exynos5420-smdk5420.dts          |  33 +
 arch/arm/boot/dts/exynos5420.dtsi                  | 148 ++++
 arch/arm/boot/dts/nspire-classic.dtsi              |  74 ++
 arch/arm/boot/dts/nspire-clp.dts                   |  45 ++
 arch/arm/boot/dts/nspire-cx.dts                    | 112 +++
 arch/arm/boot/dts/nspire-tp.dts                    |  44 ++
 arch/arm/boot/dts/nspire.dtsi                      | 175 +++++
 arch/arm/boot/dts/st-pincfg.h                      |  71 ++
 arch/arm/boot/dts/stih415-b2000.dts                |  15 +
 arch/arm/boot/dts/stih415-b2020.dts                |  15 +
 arch/arm/boot/dts/stih415-clock.dtsi               |  38 +
 arch/arm/boot/dts/stih415-pinctrl.dtsi             | 268 ++++++++
 arch/arm/boot/dts/stih415.dtsi                     |  87 +++
 arch/arm/boot/dts/stih416-b2000.dts                |  16 +
 arch/arm/boot/dts/stih416-b2020.dts                |  16 +
 arch/arm/boot/dts/stih416-clock.dtsi               |  41 ++
 arch/arm/boot/dts/stih416-pinctrl.dtsi             | 295 ++++++++
 arch/arm/boot/dts/stih416.dtsi                     |  96 +++
 arch/arm/boot/dts/stih41x-b2000.dtsi               |  41 ++
 arch/arm/boot/dts/stih41x-b2020.dtsi               |  42 ++
 arch/arm/boot/dts/stih41x.dtsi                     |  38 +
 arch/arm/include/debug/nspire.S                    |  28 +
 arch/arm/include/debug/sti.S                       |  61 ++
 arch/arm/mach-exynos/Kconfig                       |  10 +
 arch/arm/mach-exynos/common.c                      |  18 +-
 arch/arm/mach-exynos/include/mach/uncompress.h     |   7 +-
 arch/arm/mach-exynos/mach-exynos5-dt.c             |   1 +
 arch/arm/mach-exynos/platsmp.c                     |  12 +-
 arch/arm/mach-msm/Makefile                         |  10 +-
 arch/arm/mach-msm/board-halibut.c                  |   2 +-
 arch/arm/mach-msm/board-msm7x30.c                  |   2 +-
 arch/arm/mach-msm/board-qsd8x50.c                  |   2 +-
 arch/arm/mach-msm/board-trout-panel.c              |  19 +-
 arch/arm/mach-msm/board-trout.c                    |   3 +-
 arch/arm/mach-msm/clock-7x30.h                     | 155 -----
 arch/arm/mach-msm/clock-debug.c                    | 130 ----
 arch/arm/mach-msm/clock-pcom.c                     | 149 ++--
 arch/arm/mach-msm/clock-pcom.h                     |  31 +-
 arch/arm/mach-msm/clock.c                          | 166 +----
 arch/arm/mach-msm/clock.h                          |  51 +-
 arch/arm/mach-msm/devices-msm7x00.c                |  12 +-
 arch/arm/mach-msm/devices-msm7x30.c                |  15 +-
 arch/arm/mach-msm/devices-qsd8x50.c                |  12 +-
 arch/arm/mach-msm/devices.h                        |  15 +-
 arch/arm/mach-msm/dma.c                            |   5 +-
 arch/arm/mach-msm/include/mach/board.h             |   5 -
 arch/arm/mach-msm/include/mach/clk.h               |   9 -
 arch/arm/mach-nspire/Kconfig                       |  16 +
 arch/arm/mach-nspire/Makefile                      |   2 +
 arch/arm/mach-nspire/Makefile.boot                 |   0
 arch/arm/mach-nspire/clcd.c                        | 119 ++++
 arch/arm/mach-nspire/clcd.h                        |  14 +
 arch/arm/mach-nspire/mmio.h                        |  20 +
 arch/arm/mach-nspire/nspire.c                      |  89 +++
 arch/arm/mach-shmobile/setup-r8a7790.c             |  28 +-
 arch/arm/mach-sti/Kconfig                          |  45 ++
 arch/arm/mach-sti/Makefile                         |   2 +
 arch/arm/mach-sti/board-dt.c                       |  48 ++
 arch/arm/mach-sti/headsmp.S                        |  44 ++
 arch/arm/mach-sti/platsmp.c                        | 117 ++++
 arch/arm/mach-sti/smp.h                            |  17 +
 arch/arm/mach-ux500/cache-l2x0.c                   |   3 +-
 arch/arm/plat-samsung/include/plat/cpu.h           |   8 +
 drivers/clk/samsung/Makefile                       |   1 +
 drivers/clk/samsung/clk-exynos5420.c               | 762 +++++++++++++++++++++
 drivers/clocksource/exynos_mct.c                   |  35 +-
 drivers/iommu/msm_iommu_dev.c                      |  20 +-
 drivers/mmc/host/msm_sdcc.c                        |  14 +-
 drivers/pinctrl/pinctrl-exynos.c                   | 118 ++++
 drivers/pinctrl/pinctrl-samsung.c                  |   2 +
 drivers/pinctrl/pinctrl-samsung.h                  |   1 +
 drivers/tty/serial/msm_serial.c                    |  35 +-
 drivers/tty/serial/samsung.c                       |   4 +-
 drivers/tty/serial/sh-sci.c                        | 104 ++-
 drivers/usb/phy/phy-msm-usb.c                      |  38 +-
 include/linux/serial_sci.h                         |  12 +-
 include/uapi/linux/serial_core.h                   |   3 +
 95 files changed, 4799 insertions(+), 790 deletions(-)
 create mode 100644 Documentation/arm/sti/overview.txt
 create mode 100644 Documentation/arm/sti/stih415-overview.txt
 create mode 100644 Documentation/arm/sti/stih416-overview.txt
 create mode 100644 Documentation/devicetree/bindings/arm/nspire.txt
 create mode 100644 Documentation/devicetree/bindings/clock/exynos5420-clock.txt
 create mode 100644 arch/arm/boot/dts/exynos5.dtsi
 create mode 100644 arch/arm/boot/dts/exynos5420-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/exynos5420-smdk5420.dts
 create mode 100644 arch/arm/boot/dts/exynos5420.dtsi
 create mode 100644 arch/arm/boot/dts/nspire-classic.dtsi
 create mode 100644 arch/arm/boot/dts/nspire-clp.dts
 create mode 100644 arch/arm/boot/dts/nspire-cx.dts
 create mode 100644 arch/arm/boot/dts/nspire-tp.dts
 create mode 100644 arch/arm/boot/dts/nspire.dtsi
 create mode 100644 arch/arm/boot/dts/st-pincfg.h
 create mode 100644 arch/arm/boot/dts/stih415-b2000.dts
 create mode 100644 arch/arm/boot/dts/stih415-b2020.dts
 create mode 100644 arch/arm/boot/dts/stih415-clock.dtsi
 create mode 100644 arch/arm/boot/dts/stih415-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/stih415.dtsi
 create mode 100644 arch/arm/boot/dts/stih416-b2000.dts
 create mode 100644 arch/arm/boot/dts/stih416-b2020.dts
 create mode 100644 arch/arm/boot/dts/stih416-clock.dtsi
 create mode 100644 arch/arm/boot/dts/stih416-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/stih416.dtsi
 create mode 100644 arch/arm/boot/dts/stih41x-b2000.dtsi
 create mode 100644 arch/arm/boot/dts/stih41x-b2020.dtsi
 create mode 100644 arch/arm/boot/dts/stih41x.dtsi
 create mode 100644 arch/arm/include/debug/nspire.S
 create mode 100644 arch/arm/include/debug/sti.S
 delete mode 100644 arch/arm/mach-msm/clock-7x30.h
 delete mode 100644 arch/arm/mach-msm/clock-debug.c
 create mode 100644 arch/arm/mach-nspire/Kconfig
 create mode 100644 arch/arm/mach-nspire/Makefile
 create mode 100644 arch/arm/mach-nspire/Makefile.boot
 create mode 100644 arch/arm/mach-nspire/clcd.c
 create mode 100644 arch/arm/mach-nspire/clcd.h
 create mode 100644 arch/arm/mach-nspire/mmio.h
 create mode 100644 arch/arm/mach-nspire/nspire.c
 create mode 100644 arch/arm/mach-sti/Kconfig
 create mode 100644 arch/arm/mach-sti/Makefile
 create mode 100644 arch/arm/mach-sti/board-dt.c
 create mode 100644 arch/arm/mach-sti/headsmp.S
 create mode 100644 arch/arm/mach-sti/platsmp.c
 create mode 100644 arch/arm/mach-sti/smp.h
 create mode 100644 drivers/clk/samsung/clk-exynos5420.c
