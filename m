Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbaLTUVr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 15:21:47 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:41627 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaLTUVo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 15:21:44 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org
User-Agent: alot/0.3.5
To: torvalds@linux-foundation.org
Message-ID: <20141220202135.29014.62376@quantum>
Subject: [GIT PULL] clk: changes for 3.19
Date: Sat, 20 Dec 2014 12:21:35 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 206c5f60a3d902bc4b56dab2de3e88de5eb06108:

  Linux 3.18-rc4 (2014-11-09 14:55:29 -0800)

are available in the git repository at:

  https://git.linaro.org/people/mike.turquette/linux.git tags/clk-for-linus-3.19

for you to fetch changes up to f1e9203e2366164b832d8a6ce10134de8c575178:

  clk: samsung: Fix Exynos 5420 pinctrl setup and clock disable failure due to domain being gated (2014-12-17 07:31:51 -0800)

----------------------------------------------------------------
Please consider pulling the clk framework changes toward 3.19. It is
much later than usual due to several last minute bugs that had to be
addressed. As usual the majority of changes are new drivers and
modifications to existing drivers. The core recieved many fixes along
with the groundwork for several large changes coming in the future which
will better parition clock providers from clock consumers.

----------------------------------------------------------------
Abhilash Kesavan (1):
      clk: samsung: exynos7: add gate clock for ADC block

Alexandru M Stan (2):
      clk: rockchip: add bindings for the mmc clocks
      clk: rockchip: Add support for the mmc clock phases using the framework

Andrzej Hajda (1):
      clk: samsung: exynos4: set parent of sclk_hdmiphy to hdmi

Bintian Wang (1):
      clk: hi3620: Move const initdata into correct code section

Boris Brezillon (2):
      clk: at91: usb: fix at91rm9200 round and set rate
      clk: at91: usb: fix at91sam9x5 recalc, round and set rate

Chanwoo Choi (6):
      clk: samsung: Document binding for Exynos4415 clock controller
      clk: samsung: exynos4415: Add clocks using common clock framework
      mfd: sec-core: Add support for S2MPS13 device
      regulator: s2mps11: Add support S2MPS13 regulator device
      clk: s2mps11: Add the support for S2MPS13 PMIC clock
      mfd: s2mps11: Add binding documentation for Samsung S2MPS13 PMIC

Chao Xie (13):
      clk: mmp: add prefix "mmp" for structures defined for clk-frac
      clk: mmp: add spin lock for clk-frac
      clk: mmp: add init callback for clk-frac
      clk: mmp: move definiton of mmp_clk_frac to clk.h
      clk: mmp: add clock type mix
      clk: mmp: add mmp private gate clock
      clk: mmp: add basic support functions for DT support
      clk: mmp: add reset support
      clk: mmp: add pxa168 DT support for clock driver
      clk: mmp: add pxa910 DT support for clock driver
      clk: mmp: add mmp2 DT support for clock driver
      arm: mmp: Make all the dts file to be compiled by Makefile
      arm: mmp: Make use of the DT supported clock

Chen-Yu Tsai (7):
      clk: sunxi: make factors clock mux mask configurable
      clk: sunxi: Add support for A80 basic bus clocks
      clk: sunxi: Add support for bus clock gates on Allwinner A80 SoC
      ARM: dts: sunxi: Use sun4i-a10-apb1-clk for sun6i/sun8i apb2 clocks.
      clk: sunxi: Removed unused/incorrect sun6i-a31-apb2-clk driver
      clk: sunxi: Specify number of child clocks for divs clocks
      clk: sunxi: Implement A31 PLL6 as a divs clock for 2x output

Chris Zhong (1):
      clk: rockchip: rk3288: add suspend and resume

Dmitry Torokhov (1):
      clk: rockchip: ensure HCLK_VIO2_H2P and PCLK_VIO2_H2P stay enabled

Doug Anderson (1):
      clk: rockchip: Add CLK_SET_RATE_PARENT to aclk_cpu_pre

Emilio López (2):
      clk: sunxi: unify APB1 clock
      ARM: dts: sunxi: unify APB1 clock

Felipe Balbi (1):
      ARM: OMAP2+: hwmod: drop unnecessary list initialization

Geert Uytterhoeven (1):
      clk: shmobile: Deprecate renesas,clock-indices

Georgi Djakov (1):
      clk: qcom: Fix duplicate rbcpr clock name

Hans de Goede (2):
      clk_mux: Fix set_parent doing the wrong thing when INDEX_BIT && index >= 3
      clk: sunxi: gmac-tx-clk mux is not a CLK_MUX_INDEX_BIT mux

Heiko Stuebner (4):
      clk: rockchip: add ability to specify pll-specific flags
      clk: rockchip: setup pll_mux data earlier
      clk: rockchip: add optional sync to pll rate parameters
      clk: rockchip: add ROCKCHIP_PLL_SYNC_RATE flag to some plls

Heiko Stübner (1):
      clk: rockchip: fix rk3188 hsadc_frac definition

James Hogan (1):
      clk-divider: Fix READ_ONLY when divider > 1

Jeff Chen (2):
      clk: rockchip: add binding ID for DMC (memory controller) clocks on rk3288
      clk: rockchip: use clock ID for DMC (memory controller) on rk3288

Jianqun (1):
      clk: rockchip: rk3288: removing the CLK_SET_RATE_PARENT from i2s_clkout

Julien CHAUVEAU (3):
      clk: rockchip: fix parent clock for rk3188 hclk_lcdc1
      clk: rockchip: fix clock gate for rk3188 spdif_pre
      clk: rockchip: fix rk3188 USB HSIC PHY clock divider

Kever Yang (6):
      clk: rockchip: add 400MHz and 500MHz for rk3288 clock rate
      clk: rockchip: add npll to source of sclk_gpu
      clk: rockchip: change PLL setting for better clock jitter
      clk: rockchip: disable unused clocks
      clk: rockchip: fix rk3288 clk_usbphy480m_gate bit location in register
      clk: rockchip: fix clock select order for rk3288 usbphy480m_src

Krzysztof Kozlowski (3):
      clk: samsung: exynos4415: Fix build with PM_SLEEP disabled
      clk: samsung: Fix double add of syscore ops after driver rebind
      clk: samsung: Fix Exynos 5420 pinctrl setup and clock disable failure due to domain being gated

Michael Turquette (12):
      MAINTAINERS: add Stephen Boyd as clk co-maintainer
      MAINTAINERS: clk framework git tree moved to kernel.org
      Merge branch 'clk-next-mmp' into clk-next
      Merge tag 'v3.19-rockchip-clk1' of git://git.kernel.org/.../mmind/linux-rockchip into clk-next-rockchip
      Merge branch 'clk-next-shmobile' into clk-next
      Merge branch 'for-v3.19/exynos-clk' of git://linuxtv.org/snawrocki/samsung into clk-next-exynos
      Merge branch 'clk-fixes' into clk-next
      Merge tag 'sunxi-clocks-for-3.19' of https://git.kernel.org/.../mripard/linux into clk-next
      Merge tag 'v3.19-rockchip-clk2' of git://git.kernel.org/.../mmind/linux-rockchip into clk-next
      Merge tag 'ib-mfd-regulator-clk-v3.19' of git://git.kernel.org/.../lee/mfd into clk-next
      Merge tag 'for-v3.19-exynos-clk-2' of git://linuxtv.org/snawrocki/samsung into clk-next
      Merge tag 'for-v3.19/omap-a' of git://git.kernel.org/.../pjw/omap-pending into tmp

Naveen Krishna Ch (8):
      clk: samsung: add support for 145xx and 1460x PLLs
      clk: samsung: Factor out the common code to clk.c
      clk: samsung: Add fixed_factor_clocks field to struct exynos_cmu_info
      clk: samsung: add initial clock support for Exynos7 SoC
      clk: samsung: exynos7: add clocks for I2C block
      clk: samsung: exynos7: add clocks for MMC block
      clk: samsung: exynos7: add clocks for RTC block
      clk: samsung: exynos7: add gate clocks for WDT, TMU and PWM blocks

Pankaj Dubey (3):
      clk: samsung: Spelling s/bwtween/between/
      clk: samsung: remove unnecessary CONFIG_OF from clk.c
      clk: samsung: remove unnecessary inclusion of header files from clk.h

Robert Jarzmik (4):
      clk: add pxa25x clock drivers
      clk: pxa: fix pxa27x CCCR bit usage
      clk: pxa: declare init function and data __init
      clk: pxa: keep clocks initialization separated per variant

Sonny Rao (2):
      clk: rockchip: fix parent for spdif_8ch_frac on rk3288
      clk: rockchip: rk3288 export i2s0_clkout for use in DT

Stephen Boyd (1):
      clk: Really fix deadlock with mmap_sem

Tero Kristo (7):
      ARM: OMAP3: clock: use clk_features flags for omap3 DPLL4 checks
      ARM: OMAP3: clock: add new rate changing logic support for noncore DPLLs
      ARM: OMAP4: clock: add support for determine_rate for omap4 regm4xen DPLL
      ARM: OMAP3: clock: add support for dpll4_set_rate_and_parent
      ARM: OMAP3+: DPLL: use determine_rate() and set_rate_and_parent()
      ARM: OMAP2+: clock: fix DPLL code to use new determine rate APIs
      ARM: OMAP3: clock: fix boot breakage in legacy mode

Tomeu Vizoso (5):
      clk: Remove unused function __clk_get_prepare_count
      clk: Don't try to use a struct clk* after it could have been freed
      clk: Don't expose __clk_get_accuracy
      clk: change clk_debugfs_add_file to take a struct clk_hw
      clk: Change clk_ops->determine_rate to return a clk_hw as the best parent

Ulrich Hecht (2):
      clk: shmobile: div6: support selectable-input clocks
      clk: shmobile: document DIV6 clock parent bindings

Wei Yongjun (1):
      clk: mmp: fix sparse non static symbol warning

Zhen Lei (1):
      clk: delete a local variable's repeated assignment

kbuild test robot (1):
      clk: clk-s2mps11: fix semicolon.cocci warnings

 Documentation/clk.txt                              |    2 +-
 .../devicetree/bindings/clock/exynos4415-clock.txt |   38 +
 .../devicetree/bindings/clock/exynos7-clock.txt    |   93 ++
 .../devicetree/bindings/clock/marvell,mmp2.txt     |   21 +
 .../devicetree/bindings/clock/marvell,pxa168.txt   |   21 +
 .../devicetree/bindings/clock/marvell,pxa910.txt   |   21 +
 .../bindings/clock/renesas,cpg-div6-clocks.txt     |   18 +-
 .../bindings/clock/renesas,cpg-mstp-clocks.txt     |    8 +-
 Documentation/devicetree/bindings/clock/sunxi.txt  |   31 +-
 Documentation/devicetree/bindings/mfd/s2mps11.txt  |   22 +-
 MAINTAINERS                                        |    3 +-
 arch/arm/boot/dts/Makefile                         |    3 +
 arch/arm/boot/dts/mmp2-brownstone.dts              |    2 +-
 arch/arm/boot/dts/mmp2.dtsi                        |   29 +-
 arch/arm/boot/dts/pxa168-aspenite.dts              |    2 +-
 arch/arm/boot/dts/pxa168.dtsi                      |   27 +-
 arch/arm/boot/dts/pxa910-dkb.dts                   |    2 +-
 arch/arm/boot/dts/pxa910.dtsi                      |   28 +-
 arch/arm/boot/dts/sun4i-a10.dtsi                   |   12 +-
 arch/arm/boot/dts/sun5i-a10s.dtsi                  |   12 +-
 arch/arm/boot/dts/sun5i-a13.dtsi                   |   12 +-
 arch/arm/boot/dts/sun6i-a31.dtsi                   |   12 +-
 arch/arm/boot/dts/sun7i-a20.dtsi                   |   12 +-
 arch/arm/boot/dts/sun8i-a23.dtsi                   |   12 +-
 arch/arm/mach-mmp/Kconfig                          |   12 +-
 arch/arm/mach-mmp/mmp-dt.c                         |   57 +-
 arch/arm/mach-mmp/mmp2-dt.c                        |   26 +-
 arch/arm/mach-omap2/cclock3xxx_data.c              |   29 +-
 arch/arm/mach-omap2/clock.c                        |    4 +
 arch/arm/mach-omap2/clock.h                        |    1 +
 arch/arm/mach-omap2/clock3xxx.c                    |   38 +-
 arch/arm/mach-omap2/dpll3xxx.c                     |  179 ++-
 arch/arm/mach-omap2/dpll44xx.c                     |   41 +
 arch/arm/mach-omap2/omap_hwmod.c                   |    2 -
 arch/mips/alchemy/common/clock.c                   |   10 +-
 drivers/clk/at91/clk-programmable.c                |    4 +-
 drivers/clk/at91/clk-usb.c                         |   35 +-
 drivers/clk/bcm/clk-kona.c                         |    4 +-
 drivers/clk/clk-composite.c                        |    9 +-
 drivers/clk/clk-divider.c                          |   18 +-
 drivers/clk/clk-mux.c                              |    2 +-
 drivers/clk/clk-s2mps11.c                          |   26 +-
 drivers/clk/clk.c                                  |   42 +-
 drivers/clk/hisilicon/clk-hi3620.c                 |   72 +-
 drivers/clk/mmp/Makefile                           |    7 +-
 drivers/clk/mmp/clk-frac.c                         |   74 +-
 drivers/clk/mmp/clk-gate.c                         |  133 +++
 drivers/clk/mmp/clk-mix.c                          |  513 +++++++++
 drivers/clk/mmp/clk-mmp2.c                         |    6 +-
 drivers/clk/mmp/clk-of-mmp2.c                      |  334 ++++++
 drivers/clk/mmp/clk-of-pxa168.c                    |  279 +++++
 drivers/clk/mmp/clk-of-pxa910.c                    |  301 +++++
 drivers/clk/mmp/clk-pxa168.c                       |    6 +-
 drivers/clk/mmp/clk-pxa910.c                       |    6 +-
 drivers/clk/mmp/clk.c                              |  192 ++++
 drivers/clk/mmp/clk.h                              |  226 +++-
 drivers/clk/mmp/reset.c                            |   99 ++
 drivers/clk/mmp/reset.h                            |   31 +
 drivers/clk/pxa/Makefile                           |    1 +
 drivers/clk/pxa/clk-pxa.c                          |   45 +-
 drivers/clk/pxa/clk-pxa.h                          |    9 +-
 drivers/clk/pxa/clk-pxa25x.c                       |  273 +++++
 drivers/clk/pxa/clk-pxa27x.c                       |   13 +-
 drivers/clk/qcom/clk-pll.c                         |    2 +-
 drivers/clk/qcom/clk-rcg.c                         |   20 +-
 drivers/clk/qcom/clk-rcg2.c                        |   28 +-
 drivers/clk/qcom/mmcc-apq8084.c                    |    2 +-
 drivers/clk/rockchip/Makefile                      |    1 +
 drivers/clk/rockchip/clk-mmc-phase.c               |  154 +++
 drivers/clk/rockchip/clk-pll.c                     |   81 +-
 drivers/clk/rockchip/clk-rk3188.c                  |   79 +-
 drivers/clk/rockchip/clk-rk3288.c                  |  246 +++--
 drivers/clk/rockchip/clk.c                         |   24 +-
 drivers/clk/rockchip/clk.h                         |   45 +-
 drivers/clk/samsung/Makefile                       |    2 +
 drivers/clk/samsung/clk-exynos-audss.c             |   33 +-
 drivers/clk/samsung/clk-exynos4.c                  |    2 +-
 drivers/clk/samsung/clk-exynos4415.c               | 1144 ++++++++++++++++++++
 drivers/clk/samsung/clk-exynos5260.c               |  185 +---
 drivers/clk/samsung/clk-exynos7.c                  |  743 +++++++++++++
 drivers/clk/samsung/clk-pll.c                      |   25 +-
 drivers/clk/samsung/clk-pll.h                      |    4 +
 drivers/clk/samsung/clk.c                          |  102 +-
 drivers/clk/samsung/clk.h                          |   43 +-
 drivers/clk/shmobile/clk-div6.c                    |  113 +-
 drivers/clk/sunxi/Makefile                         |    1 +
 drivers/clk/sunxi/clk-a20-gmac.c                   |    7 +-
 drivers/clk/sunxi/clk-factors.c                    |    6 +-
 drivers/clk/sunxi/clk-factors.h                    |    3 +-
 drivers/clk/sunxi/clk-mod0.c                       |    1 +
 drivers/clk/sunxi/clk-sun6i-ar100.c                |    4 +-
 drivers/clk/sunxi/clk-sun8i-mbus.c                 |    1 +
 drivers/clk/sunxi/clk-sun9i-core.c                 |  271 +++++
 drivers/clk/sunxi/clk-sunxi.c                      |   85 +-
 drivers/clk/ti/dpll.c                              |   15 +
 drivers/mfd/sec-core.c                             |   29 +
 drivers/mfd/sec-irq.c                              |   23 +-
 drivers/regulator/Kconfig                          |   10 +-
 drivers/regulator/s2mps11.c                        |  102 +-
 include/dt-bindings/clock/exynos4415.h             |  360 ++++++
 include/dt-bindings/clock/exynos7-clk.h            |   92 ++
 include/dt-bindings/clock/marvell,mmp2.h           |   74 ++
 include/dt-bindings/clock/marvell,pxa168.h         |   57 +
 include/dt-bindings/clock/marvell,pxa910.h         |   54 +
 include/dt-bindings/clock/qcom,mmcc-apq8084.h      |    2 +-
 include/dt-bindings/clock/rk3288-cru.h             |   13 +
 include/linux/clk-provider.h                       |    9 +-
 include/linux/clk/ti.h                             |   15 +
 include/linux/mfd/samsung/core.h                   |    2 +
 include/linux/mfd/samsung/s2mps13.h                |  186 ++++
 110 files changed, 7299 insertions(+), 803 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/exynos4415-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/exynos7-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/marvell,mmp2.txt
 create mode 100644 Documentation/devicetree/bindings/clock/marvell,pxa168.txt
 create mode 100644 Documentation/devicetree/bindings/clock/marvell,pxa910.txt
 create mode 100644 drivers/clk/mmp/clk-gate.c
 create mode 100644 drivers/clk/mmp/clk-mix.c
 create mode 100644 drivers/clk/mmp/clk-of-mmp2.c
 create mode 100644 drivers/clk/mmp/clk-of-pxa168.c
 create mode 100644 drivers/clk/mmp/clk-of-pxa910.c
 create mode 100644 drivers/clk/mmp/clk.c
 create mode 100644 drivers/clk/mmp/reset.c
 create mode 100644 drivers/clk/mmp/reset.h
 create mode 100644 drivers/clk/pxa/clk-pxa25x.c
 create mode 100644 drivers/clk/rockchip/clk-mmc-phase.c
 create mode 100644 drivers/clk/samsung/clk-exynos4415.c
 create mode 100644 drivers/clk/samsung/clk-exynos7.c
 create mode 100644 drivers/clk/sunxi/clk-sun9i-core.c
 create mode 100644 include/dt-bindings/clock/exynos4415.h
 create mode 100644 include/dt-bindings/clock/exynos7-clk.h
 create mode 100644 include/dt-bindings/clock/marvell,mmp2.h
 create mode 100644 include/dt-bindings/clock/marvell,pxa168.h
 create mode 100644 include/dt-bindings/clock/marvell,pxa910.h
 create mode 100644 include/linux/mfd/samsung/s2mps13.h
