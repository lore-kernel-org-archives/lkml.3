Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbaDDRrY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 13:47:24 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:55826 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbaDDRrU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 13:47:20 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org
User-Agent: alot/0.3.5
To: torvalds@linux-foundation.org
Message-ID: <20140404174715.8250.22335@quantum>
Subject: [GIT PULL] clk: changes for 3.15
Date: Fri, 04 Apr 2014 10:47:15 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit cfbf8d4857c26a8a307fb7cd258074c9dcd8c691:

  Linux 3.14-rc4 (2014-02-23 17:40:03 -0800)

are available in the git repository at:

  git://git.linaro.org/people/mike.turquette/linux.git tags/clk-for-linus-3.15

for you to fetch changes up to e44df332f30bf3040c60c1ed6674d1431fdb48b9:

  clk: shmobile: fix setting paretn clock rate (2014-04-02 11:31:05 -0700)

----------------------------------------------------------------
The clock framework changes for 3.15 look similar to past pull requests.
Mostly clock driver updates, more Device Tree support in the form of
common functions useful across platforms and a handful of features and
fixes to the framework core.

----------------------------------------------------------------
Alex Elder (1):
      clk: support hardware-specific debugfs entries

Andrew Bresticker (3):
      clk: tegra: fix sdmmc clks on Tegra1x4
      clk: tegra: cclk_lp has a pllx/2 divider
      clk: tegra: use max divider if divider overflows

Barry Song (1):
      clk: sirf: update copyright years to 2014

Ben Dooks (3):
      clk: add clock-indices support
      clk: shmobile: rcar-gen2: fix lb/sd0/sd1/sdh clock parent to pll1
      clk: shmobile: fix setting paretn clock rate

Boris BREZILLON (2):
      clk: at91: replace prog clk round_rate with determine_rate
      clk: at91: propagate rate change on system clks

Chao Xie (3):
      clk: mmp: fix wrong mask when calculate denominator
      clk: mmp: fix the wrong calculation formula
      clk: mmp: try to use closer one when do round rate

Chen-Yu Tsai (5):
      clk: sunxi: add clock-output-names dt property support
      clk: sunxi: update clock-output-names dt binding documentation
      clk: sunxi: add names for pll5, pll6 parent clocks to factors_data
      clk: sunxi: get divs parent clock name from parent factor clock
      clk: sunxi: Add Allwinner A20/A31 GMAC clock unit

David Ung (1):
      clk: tegra: PLLD2 fixes for hdmi

Dinh Nguyen (7):
      clk: socfpga: Map the clk manager base address in the clock driver
      clk: socfpga: Look for the GPIO_DB_CLK by its offset
      clk: socfpga: Remove socfpga_init_clocks
      clk: socfpga: Add a clk-phase property to the "altr,socfpga-gate-clk"
      clk: socfpga: Fix integer overflow in clock calculation
      clk: socfpga: Support multiple parents for the pll clocks
      clk: socfpga: Fix section mismatch warning

Emilio López (3):
      clk: sunxi: fix A20 PLL4 calculation
      clk: sunxi: fix some calculations
      clk: sunxi: fix thinko in comment

Ezequiel Garcia (3):
      clk: mvebu: Fix ratio register offset on A375 SoC
      clk: mvebu: Support Armada 380 SoC on the core divider clock
      clk: mvebu: Update binding documentation for the core divider clock

Gabe Black (1):
      clk: tegra: Fix PLLP rate table

Gabriel FERNANDEZ (10):
      clk: st: Support for DIVMUX and PreDiv Clocks
      clk: st: Support for PLLs inside ClockGenA(s)
      clk: st: Support for VCC-mux and MUX clocks
      clk: st: Support for QUADFS inside ClockGenB/C/D/E/F
      clk: st: Support for ClockGenA9/DDR/GPU
      clk: st: Support for A9 MUX clocks
      clk: st: Adds divmux and prediv clock binding
      clk: st: Adds clockgen clock binding
      clk: st: Adds clockgen-vcc and clockgen-mux clock binding
      clk: st: Adds quadfs clock binding

Gregory CLEMENT (5):
      clk: mvebu: add clock support for Armada 375
      dt: Update binding information for mvebu core clocks with Armada 375
      dt: Update binding information for mvebu gating clocks with Armada 375
      clk: mvebu: add clock support for Armada 380/385
      clk: respect the clock dependencies in of_clk_init

Hans de Goede (1):
      clk: sunxi: Add support for USB clock-register reset bits

Haojian Zhuang (3):
      clk: hisi: assign missing clk to table
      clk: hip04: add clock driver
      clk: hisi: remove static variable

Ivan Khoronzhuk (2):
      clk: keystone: gate: fix clk_init_data initialization
      ARM: keystone: dts: fix clkvcp3 control register address

Jean-Francois Moine (1):
      clk: return probe defer when DT clock not yet ready

Jean-Jacques Hiblot (2):
      clk: at91: fix programmable clk irq handling
      clk: at91: optimization of the set_rate callback

Jonas Jensen (1):
      clk: add MOXA ART SoCs clock driver

Krzysztof Kozlowski (2):
      clk: s2mps11: Fix possible NULL pointer dereference
      clk: s2mps11: Use of_get_child_by_name

Lars-Peter Clausen (1):
      clk: axi-clkgen: Add support for v2

Laurent Pinchart (6):
      clk: shmobile: rcar-gen2: Fix clock parent all non-PLL clocks
      clk: shmobile: rcar-gen2: Fix qspi divisor
      clk: shmobile: rcar-gen2: Fix clock parent for all non-PLL clocks
      clk: shmobile: rcar-gen2: Fix qspi divisor
      clk: shmobile: Fix typo in MSTP clock DT bindings
      Documentation: clk: Add locking documentation

Linus Walleij (1):
      clk: nomadik: fix multiplatform problem

Mark Zhang (1):
      clk: tegra: fix host1x clock on Tegra124

Masanari Iida (1):
      clk:at91: Fix memory leak in of_at91_clk_master_setup()

Maxime Ripard (2):
      clk: sunxi: Add support for PLL6 on the A31
      clk: sunxi: Add new clock compatibles

Michal Simek (1):
      clk: zynq: Use clk_readl/clk_writel helper function

Mike Turquette (13):
      Merge tag 'socfpga-clk-for-3.15' of git://git.rocketboards.org/linux-socfpga-next into clk-next
      Merge tag 'mvebu-clk-fixes-3.14' of git://git.infradead.org/linux-mvebu into clk-fixes
      Merge branch 'for_3.14-rcx/clk-fixes' of git://git.kernel.org/.../ssantosh/linux-keystone into clk-fixes
      Merge tag 'clk-mvebu-3xx-3.15' of git://git.infradead.org/linux-mvebu into clk-next-mvebu
      Merge branch 'clk-tegra-more-fixes-3.14' of git://nv-tegra.nvidia.com/user/pdeschrijver/linux into clk-fixes
      clk: add pr_debug & kerneldoc around clk notifiers
      Merge branch 'clocks/fixes/drivers' of git://linuxtv.org/pinchartl/fbdev into clk-fixes
      Merge branch 'clk-fixes' into clk-next
      Merge branch 'clk-fixes' into clk-next
      Merge tag 'clk-mvebu-3xx-3.15-2' of git://git.infradead.org/linux-mvebu into clk-next-mvebu
      Merge tag 'sunxi-clk-for-3.15' of https://bitbucket.org/emiliolopez/linux into clk-next-sunxi
      Merge tag 'clk-hisi' of https://git.kernel.org/.../hzhuang1/linux into clk-next-hisilcon
      MAINTAINERS: use LKML for common clk framework

Nishanth Menon (1):
      clk: ti: am335x: remove unecessary cpu0 clk node

Peter De Schrijver (3):
      clk: tegra: Add missing Tegra20 fuse clks
      clk: tegra: Fix vic03 mux index
      clk: tegra124: remove gr2d and gr3d clocks

Rhyland Klein (1):
      clk: tegra: Fix PLLD mnp table

Roman Byshko (1):
      clk: sunxi: Add USB clock register defintions

Sachin Kamat (2):
      clk: tegra: Staticize tegra_clk_periph_no_gate_ops
      clk: ux500: Staticize ux500_twocell_get

Sascha Hauer (1):
      clk: turn rate change failed warning into pr_debug

Sebastian Hesselbarth (4):
      clk: mvebu: armada-370: maintain clock init order
      clk: mvebu: armada-xp: maintain clock init order
      clk: mvebu: dove: maintain clock init order
      clk: mvebu: kirkwood: maintain clock init order

Soren Brinkmann (1):
      clk: Fix notifier documentation

Steffen Trumtrar (3):
      clk: socfpga: remove unused field
      clk: socfpga: fix define typo
      clk: socfpga: split clk code

Sylwester Nawrocki (3):
      clk: Correct handling of NULL clk in __clk_{get, put}
      clk: reverse default clk provider initialization order in of_clk_init()
      clk: Fix minor errors in of_clk_init() function comments

Tang Yuantian (1):
      clk: mpc85xx: Update the driver to align to new clock bindings

Thierry Reding (1):
      clk: tegra: Correct clock number for UARTE

Thomas Petazzoni (6):
      clk: mvebu: do not copy the contents of clk_corediv_desc
      clk: mvebu: add a little bit of documentation about data structures
      clk: mvebu: refactor corediv driver to support more SoC
      clk: mvebu: add Armada 375 support to the corediv clock driver
      dt: Update binding information for mvebu core clocks with Armada 380/385
      dt: Update binding information for mvebu gating clocks with Armada 380/385

Tomi Valkeinen (2):
      clk: divider: fix rate calculation for fractional rates
      clk: ti/divider: fix rate calculation for fractional rates

Tushar Behera (2):
      clk: clk-s2mps11: Refactor for including support for other MFD clocks
      clk: clk-s2mps11: Add support for clocks in S5M8767 MFD

Wolfram Sang (2):
      clk: shmobile: div6: use proper description in kernel doc
      clk: shmobile: add CPG driver for rz-platforms

Zhangfei Gao (2):
      clk: hisilicon: add hi3620_mmc_clks
      clk: hisilicon: fix warning from smatch

 Documentation/clk.txt                              |   34 +
 .../bindings/arm/hisilicon/hisilicon.txt           |   14 +
 .../devicetree/bindings/clock/altr_socfpga.txt     |    5 +
 .../devicetree/bindings/clock/axi-clkgen.txt       |    2 +-
 .../devicetree/bindings/clock/clock-bindings.txt   |   17 +
 .../devicetree/bindings/clock/hi3620-clock.txt     |    1 +
 .../bindings/clock/moxa,moxart-clock.txt           |   48 +
 .../devicetree/bindings/clock/mvebu-core-clock.txt |   14 +
 .../bindings/clock/mvebu-corediv-clock.txt         |    5 +-
 .../bindings/clock/mvebu-gated-clock.txt           |   65 +-
 .../bindings/clock/renesas,cpg-mstp-clocks.txt     |    4 +-
 .../bindings/clock/renesas,rz-cpg-clocks.txt       |   29 +
 .../bindings/clock/st/st,clkgen-divmux.txt         |   49 +
 .../devicetree/bindings/clock/st/st,clkgen-mux.txt |   36 +
 .../devicetree/bindings/clock/st/st,clkgen-pll.txt |   48 +
 .../bindings/clock/st/st,clkgen-prediv.txt         |   36 +
 .../devicetree/bindings/clock/st/st,clkgen-vcc.txt |   53 +
 .../devicetree/bindings/clock/st/st,clkgen.txt     |   83 ++
 .../devicetree/bindings/clock/st/st,quadfs.txt     |   45 +
 Documentation/devicetree/bindings/clock/sunxi.txt  |  102 +-
 MAINTAINERS                                        |    2 +-
 arch/arm/boot/dts/keystone-clocks.dtsi             |    2 +-
 arch/arm/boot/dts/socfpga.dtsi                     |    1 +
 arch/arm/mach-socfpga/socfpga.c                    |    5 -
 drivers/clk/Kconfig                                |    6 +-
 drivers/clk/Makefile                               |    3 +
 drivers/clk/at91/clk-master.c                      |    2 +-
 drivers/clk/at91/clk-programmable.c                |  202 ++--
 drivers/clk/at91/clk-system.c                      |   76 +-
 drivers/clk/clk-axi-clkgen.c                       |  312 +++++-
 drivers/clk/clk-divider.c                          |   10 +-
 drivers/clk/clk-moxart.c                           |   97 ++
 drivers/clk/clk-nomadik.c                          |    3 +
 drivers/clk/clk-ppc-corenet.c                      |   70 +-
 drivers/clk/clk-s2mps11.c                          |   29 +-
 drivers/clk/clk.c                                  |  144 ++-
 drivers/clk/clkdev.c                               |    2 +
 drivers/clk/hisilicon/Makefile                     |    5 +-
 drivers/clk/hisilicon/clk-hi3620.c                 |  298 +++++-
 drivers/clk/hisilicon/clk-hip04.c                  |   58 ++
 drivers/clk/hisilicon/clk.c                        |   62 +-
 drivers/clk/hisilicon/clk.h                        |   17 +-
 drivers/clk/keystone/gate.c                        |    1 +
 drivers/clk/mmp/clk-frac.c                         |   20 +-
 drivers/clk/mvebu/Kconfig                          |    8 +
 drivers/clk/mvebu/Makefile                         |    2 +
 drivers/clk/mvebu/armada-370.c                     |   21 +-
 drivers/clk/mvebu/armada-375.c                     |  184 ++++
 drivers/clk/mvebu/armada-38x.c                     |  167 ++++
 drivers/clk/mvebu/armada-xp.c                      |   20 +-
 drivers/clk/mvebu/clk-corediv.c                    |  154 ++-
 drivers/clk/mvebu/dove.c                           |   19 +-
 drivers/clk/mvebu/kirkwood.c                       |   34 +-
 drivers/clk/shmobile/Makefile                      |    1 +
 drivers/clk/shmobile/clk-div6.c                    |    2 +-
 drivers/clk/shmobile/clk-mstp.c                    |    2 +-
 drivers/clk/shmobile/clk-rcar-gen2.c               |   12 +-
 drivers/clk/shmobile/clk-rz.c                      |  103 ++
 drivers/clk/sirf/clk-atlas6.c                      |    3 +-
 drivers/clk/sirf/clk-common.c                      |    3 +-
 drivers/clk/sirf/clk-prima2.c                      |    3 +-
 drivers/clk/socfpga/Makefile                       |    3 +
 drivers/clk/socfpga/clk-gate.c                     |  263 +++++
 drivers/clk/socfpga/clk-periph.c                   |   94 ++
 drivers/clk/socfpga/clk-pll.c                      |  131 +++
 drivers/clk/socfpga/clk.c                          |  326 +-----
 drivers/clk/socfpga/clk.h                          |   57 ++
 drivers/clk/st/Makefile                            |    1 +
 drivers/clk/st/clkgen-fsyn.c                       | 1039 ++++++++++++++++++++
 drivers/clk/st/clkgen-mux.c                        |  820 +++++++++++++++
 drivers/clk/st/clkgen-pll.c                        |  698 +++++++++++++
 drivers/clk/st/clkgen.h                            |   48 +
 drivers/clk/sunxi/clk-sunxi.c                      |  305 +++++-
 drivers/clk/tegra/clk-divider.c                    |    2 +-
 drivers/clk/tegra/clk-id.h                         |    4 +
 drivers/clk/tegra/clk-periph.c                     |    2 +-
 drivers/clk/tegra/clk-tegra-periph.c               |   10 +-
 drivers/clk/tegra/clk-tegra-super-gen4.c           |    2 +-
 drivers/clk/tegra/clk-tegra114.c                   |    8 +-
 drivers/clk/tegra/clk-tegra124.c                   |   48 +-
 drivers/clk/tegra/clk-tegra20.c                    |    2 +
 drivers/clk/ti/clk-33xx.c                          |    1 -
 drivers/clk/ti/divider.c                           |    8 +-
 drivers/clk/ux500/u8500_of_clk.c                   |    3 +-
 drivers/clk/zynq/clkc.c                            |    4 +-
 drivers/clk/zynq/pll.c                             |   18 +-
 include/dt-bindings/clock/hi3620-clock.h           |    5 +
 include/dt-bindings/clock/hip04-clock.h            |   35 +
 include/dt-bindings/clock/tegra124-car.h           |    4 +-
 include/linux/clk-provider.h                       |    8 +
 include/linux/clk.h                                |   14 +
 91 files changed, 5994 insertions(+), 824 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/moxa,moxart-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/renesas,rz-cpg-clocks.txt
 create mode 100644 Documentation/devicetree/bindings/clock/st/st,clkgen-divmux.txt
 create mode 100644 Documentation/devicetree/bindings/clock/st/st,clkgen-mux.txt
 create mode 100644 Documentation/devicetree/bindings/clock/st/st,clkgen-pll.txt
 create mode 100644 Documentation/devicetree/bindings/clock/st/st,clkgen-prediv.txt
 create mode 100644 Documentation/devicetree/bindings/clock/st/st,clkgen-vcc.txt
 create mode 100644 Documentation/devicetree/bindings/clock/st/st,clkgen.txt
 create mode 100644 Documentation/devicetree/bindings/clock/st/st,quadfs.txt
 create mode 100644 drivers/clk/clk-moxart.c
 create mode 100644 drivers/clk/hisilicon/clk-hip04.c
 create mode 100644 drivers/clk/mvebu/armada-375.c
 create mode 100644 drivers/clk/mvebu/armada-38x.c
 create mode 100644 drivers/clk/shmobile/clk-rz.c
 create mode 100644 drivers/clk/socfpga/clk-gate.c
 create mode 100644 drivers/clk/socfpga/clk-periph.c
 create mode 100644 drivers/clk/socfpga/clk-pll.c
 create mode 100644 drivers/clk/socfpga/clk.h
 create mode 100644 drivers/clk/st/Makefile
 create mode 100644 drivers/clk/st/clkgen-fsyn.c
 create mode 100644 drivers/clk/st/clkgen-mux.c
 create mode 100644 drivers/clk/st/clkgen-pll.c
 create mode 100644 drivers/clk/st/clkgen.h
 create mode 100644 include/dt-bindings/clock/hip04-clock.h
