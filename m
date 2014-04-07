Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbaDGJf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 05:35:58 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41890 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbaDGJfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 05:35:52 -0400
Message-ID: <53427171.5080602@ti.com>
Date: Mon, 7 Apr 2014 12:35:45 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-fbdev <linux-fbdev@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>
Subject: [GIT PULL] fbdev changes for 3.15 (OMAP related)
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="4wd9LfIt31vlnhKehEp1KkhsUOlTVD2Bf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--4wd9LfIt31vlnhKehEp1KkhsUOlTVD2Bf
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull OMAP related fbdev changes for 3.15.

This is based on the already pulled fbdev-main changes, and this also mer=
ges
=2Edts branch from Tony Lindgren (which has also been pulled), so that I =
was able
to add the display related .dts changes.

The shortlog generated below by git-request-pull is ok, but the diff stat=
 is
not. I guess the branch I have is not something that git diff can handle.=


Maybe I could've sent the OMAP driver changes (the '3.15/dss-dt' branch) =
and
the .dts changes (the '3.15/dss-dt-dts' branch) in a separate pull reques=
ts,
but I wanted to merge them both, as I have patches on top of those that a=
re
only valid after both branches are merged.

 Tomi

The following changes since commit b7e4ab50418d5b34ab0dae95193dd71190e1fb=
50:

  Video: atmel: avoid the id of fix screen info is overwritten (2014-03-1=
9 13:03:53 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux.git tags/fbde=
v-omap-3.15

for you to fetch changes up to 0f5d9d2e7d234acb26bc98dd820cc8dd178774d6:

  OMAPDSS: HDMI: fix interlace output (2014-04-04 09:56:19 +0300)

----------------------------------------------------------------
fbdev changes for 3.15 (OMAP)

This contains OMAP related fbdev changes for 3.15. The bulk of the patche=
s are
for adding Device Tree support for OMAP Display Subsystem:

* SoCs: OMAP2/3/4

* Boards: OMAP4 Panda, OMAP4 SDP, OMAP3 Beagle, OMAP3 Beagle-xM, OMAP3
  IGEP0020, OMAP3 N900

* Devices: TFP410 Encoder, tpd12s015 HDMI companion chip, Sony acx565akm =
panel,
  MIPI DSI Command mode panel and HDMI, DVI and Analog TV connectors

----------------------------------------------------------------
Javier Martinez Canillas (1):
      ARM: omap3-igep0020.dts: add display information

Sebastian Reichel (1):
      OMAPDSS: acx565akm: Add DT support

Tomi Valkeinen (45):
      ARM: dts: fix omap3 dss clock handle names
      ARM: dts: fix DPLL4 x2 clkouts on 3630
      ARM: dts: use ti,fixed-factor-clock for dpll4_m4x2_mul_ck
      ARM: dts: set 'ti,set-rate-parent' for dpll4_m4 path
      ARM: omap2.dtsi: add omapdss information
      ARM: omap3.dtsi: add omapdss information
      ARM: omap4.dtsi: add omapdss information
      ARM: omap4-panda.dts: add display information
      ARM: OMAP2+: add omapdss_init_of()
      ARM: OMAP2+: DT 'compatible' tweak for displays
      OMAPDSS: add 'label' support for DT
      OMAPDSS: get dssdev->alias from DT alias
      OMAPFB: clean up default display search
      OMAPFB: search for default display with DT alias
      OMAPDSS: add of helpers
      OMAPDSS: Improve regulator names for DT
      OMAPDSS: Add DT support to DSS
      OMAPDSS: Add DT support to DISPC
      OMAPDSS: Add DT support to HDMI
      OMAPDSS: Add DT support to VENC
      OMAPDSS: Add DT support to DSI
      OMAPDSS: panel-dsi-cm: Add DT support
      OMAPDSS: encoder-tfp410: Add DT support
      OMAPDSS: connector-dvi: Add DT support
      OMAPDSS: encoder-tpd12s015: Add DT support
      OMAPDSS: hdmi-connector: Add DT support
      OMAPDSS: connector-analog-tv: Add DT support
      Doc/DT: Add DT binding documentation for OMAP DSS
      ARM: omap4-sdp.dts: add display information
      ARM: omap3-beagle.dts: add display information
      ARM: omap3-beagle-xm.dts: add display information
      ARM: omap3-n900.dts: add display information
      Doc/DT: Add DT binding documentation for Analog TV Connector
      Doc/DT: Add DT binding documentation for DVI Connector
      Doc/DT: Add DT binding documentation for HDMI Connector
      Doc/DT: Add DT binding documentation for MIPI DSI CM Panel
      Doc/DT: Add DT binding documentation for Sony acx565akm panel
      Doc/DT: Add DT binding documentation for TFP410 encoder
      Doc/DT: Add DT binding documentation for tpd12s015 encoder
      Merge branch '3.15/dss-dt' into 3.15/fbdev
      Merge branch '3.15/dss-dt-dts' into 3.15/fbdev
      OMAPDSS: remove DT hacks for regulators
      ARM: OMAP2+: remove pdata quirks for displays
      OMAPDSS: add missing __init for dss_init_ports
      OMAPDSS: HDMI: fix interlace output

 .gitignore                                         |   3 +
 Documentation/00-INDEX                             |  24 +-
 Documentation/PCI/MSI-HOWTO.txt                    | 119 ++-
 Documentation/RCU/00-INDEX                         |   2 +
 Documentation/arm/00-INDEX                         |  14 +
 Documentation/blackfin/00-INDEX                    |   6 +-
 Documentation/block/00-INDEX                       |   2 +
 Documentation/devicetree/00-INDEX                  |   2 +
 Documentation/devicetree/bindings/arm/omap/dmm.txt |  22 +
 .../devicetree/bindings/arm/omap/omap.txt          |   8 +-
 .../devicetree/bindings/mmc/atmel-hsmci.txt        |   5 +
 .../bindings/net/allwinner,sun4i-emac.txt          |   5 +-
 .../bindings/net/allwinner,sun4i-mdio.txt          |   5 +-
 .../devicetree/bindings/net/sti-dwmac.txt          |  58 ++
 .../devicetree/bindings/power/bq2415x.txt          |  47 ++
 .../devicetree/bindings/spi/spi_atmel.txt          |   5 +
 .../devicetree/bindings/usb/ehci-omap.txt          |   2 +-
 .../devicetree/bindings/usb/ohci-omap3.txt         |   2 +-
 .../devicetree/bindings/vendor-prefixes.txt        |   6 +-
 .../bindings/video/analog-tv-connector.txt         |  25 +
 .../devicetree/bindings/video/dvi-connector.txt    |  35 +
 .../devicetree/bindings/video/hdmi-connector.txt   |  28 +
 .../devicetree/bindings/video/panel-dsi-cm.txt     |  29 +
 .../devicetree/bindings/video/sony,acx565akm.txt   |  30 +
 .../devicetree/bindings/video/ti,omap-dss.txt      | 211 +++++
 .../devicetree/bindings/video/ti,omap2-dss.txt     |  54 ++
 .../devicetree/bindings/video/ti,omap3-dss.txt     |  83 ++
 .../devicetree/bindings/video/ti,omap4-dss.txt     | 111 +++
 .../devicetree/bindings/video/ti,tfp410.txt        |  41 +
 .../devicetree/bindings/video/ti,tpd12s015.txt     |  44 +
 Documentation/fb/00-INDEX                          |   6 +
 Documentation/filesystems/00-INDEX                 |   2 +
 Documentation/filesystems/nfs/00-INDEX             |   4 +-
 Documentation/i2c/instantiating-devices            |  41 +-
 Documentation/ide/00-INDEX                         |   2 +
 Documentation/laptops/00-INDEX                     |   6 +-
 Documentation/leds/00-INDEX                        |   8 +
 Documentation/m68k/00-INDEX                        |   2 +
 Documentation/networking/00-INDEX                  |  30 +-
 Documentation/networking/3c505.txt                 |  45 --
 Documentation/phy.txt                              |  26 +-
 Documentation/power/00-INDEX                       |   6 +-
 Documentation/ptp/testptp.c                        |  11 +-
 Documentation/s390/00-INDEX                        |   8 +-
 Documentation/scheduler/00-INDEX                   |   2 +
 Documentation/scsi/00-INDEX                        |  16 +
 Documentation/serial/00-INDEX                      |   6 +-
 Documentation/spi/00-INDEX                         |  22 +
 Documentation/spi/spi-summary                      |  17 +-
 Documentation/timers/00-INDEX                      |   2 +
 Documentation/virtual/kvm/00-INDEX                 |   2 +
 Documentation/vm/00-INDEX                          |   4 +-
 Documentation/w1/masters/00-INDEX                  |   4 +-
 Documentation/w1/slaves/00-INDEX                   |   2 +
 Documentation/x86/00-INDEX                         |  18 +-
 Documentation/zh_CN/arm64/booting.txt              |  65 +-
 Documentation/zh_CN/arm64/memory.txt               |  46 +-
 Documentation/zh_CN/arm64/tagged-pointers.txt      |  52 ++
 MAINTAINERS                                        |  21 +-
 Makefile                                           |   2 +-
 arch/arm/boot/dts/Makefile                         |  12 +-
 arch/arm/boot/dts/am335x-evm.dts                   |  60 +-
 arch/arm/boot/dts/am335x-evmsk.dts                 |  67 +-
 arch/arm/boot/dts/am33xx.dtsi                      |  13 +-
 arch/arm/boot/dts/am3517-craneboard.dts            | 174 ++++
 arch/arm/boot/dts/am4372.dtsi                      |  46 ++
 arch/arm/boot/dts/am437x-gp-evm.dts                | 127 +++
 arch/arm/boot/dts/am43x-epos-evm.dts               | 183 +++++
 arch/arm/boot/dts/armada-xp-mv78260.dtsi           |   3 +-
 arch/arm/boot/dts/at91-sama5d3_xplained.dts        | 229 ++++++
 arch/arm/boot/dts/at91sam9263.dtsi                 |   2 +-
 arch/arm/boot/dts/at91sam9n12ek.dts                |   4 +
 arch/arm/boot/dts/dove.dtsi                        |  11 -
 arch/arm/boot/dts/dra7.dtsi                        | 151 ++++
 arch/arm/boot/dts/imx6dl-hummingboard.dts          |  10 +-
 arch/arm/boot/dts/imx6qdl-cubox-i.dtsi             |  10 +-
 arch/arm/boot/dts/omap2.dtsi                       |  31 +
 arch/arm/boot/dts/omap2420.dtsi                    |   2 +
 arch/arm/boot/dts/omap2430.dtsi                    |   5 +
 arch/arm/boot/dts/omap3-beagle-xm.dts              | 142 +++-
 arch/arm/boot/dts/omap3-beagle.dts                 | 139 ++++
 arch/arm/boot/dts/omap3-cm-t3517.dts               | 136 ++++
 arch/arm/boot/dts/omap3-cm-t3530.dts               |  48 ++
 arch/arm/boot/dts/omap3-cm-t3730.dts               |  57 +-
 arch/arm/boot/dts/omap3-cm-t3x.dtsi                | 110 +++
 arch/arm/boot/dts/omap3-cm-t3x30.dtsi              |  74 +-
 arch/arm/boot/dts/omap3-devkit8000.dts             |  16 +-
 arch/arm/boot/dts/omap3-gta04.dts                  |  57 +-
 arch/arm/boot/dts/omap3-igep.dtsi                  |   1 +
 arch/arm/boot/dts/omap3-igep0020.dts               |  58 +-
 arch/arm/boot/dts/omap3-lilly-a83x.dtsi            | 459 +++++++++++
 arch/arm/boot/dts/omap3-lilly-dbb056.dts           | 170 ++++
 arch/arm/boot/dts/omap3-n9.dts                     |   2 +-
 arch/arm/boot/dts/omap3-n900.dts                   | 171 +++-
 arch/arm/boot/dts/omap3-n950.dts                   |   2 +-
 arch/arm/boot/dts/omap3-overo-storm-tobi.dts       |  22 +
 ...omap3-tobi.dts =3D> omap3-overo-tobi-common.dtsi} |   3 -
 arch/arm/boot/dts/omap3-overo-tobi.dts             |  22 +
 arch/arm/boot/dts/omap3-overo.dtsi                 |   7 +-
 arch/arm/boot/dts/omap3-sb-t35.dtsi                |  29 +-
 arch/arm/boot/dts/omap3-sbc-t3517.dts              |  43 +
 arch/arm/boot/dts/omap3-sbc-t3530.dts              |  36 +
 arch/arm/boot/dts/omap3-sbc-t3730.dts              |  23 +-
 arch/arm/boot/dts/omap3.dtsi                       |  81 +-
 arch/arm/boot/dts/omap3430-sdp.dts                 |   7 +-
 arch/arm/boot/dts/omap3430es1-clocks.dtsi          |  16 +-
 .../omap36xx-am35xx-omap3430es2plus-clocks.dtsi    |   6 +-
 arch/arm/boot/dts/omap36xx-clocks.dtsi             |  20 +
 .../boot/dts/omap36xx-omap3430es2plus-clocks.dtsi  |  10 +-
 arch/arm/boot/dts/omap36xx.dtsi                    |  28 +-
 arch/arm/boot/dts/omap3xxx-clocks.dtsi             |   8 +-
 arch/arm/boot/dts/omap4-duovero-parlor.dts         | 146 ++++
 arch/arm/boot/dts/omap4-duovero.dtsi               | 252 ++++++
 arch/arm/boot/dts/omap4-panda-common.dtsi          | 146 +++-
 arch/arm/boot/dts/omap4-sdp.dts                    | 146 +++-
 arch/arm/boot/dts/omap4.dtsi                       | 143 +++-
 arch/arm/boot/dts/omap443x.dtsi                    |  26 +
 arch/arm/boot/dts/omap4460.dtsi                    |  37 +
 arch/arm/boot/dts/omap5-uevm.dts                   |   8 +-
 arch/arm/boot/dts/omap5.dtsi                       |  43 +-
 arch/arm/boot/dts/sama5d3.dtsi                     |   2 +-
 arch/arm/boot/dts/ste-href.dtsi                    |   1 -
 arch/arm/boot/dts/sun4i-a10.dtsi                   |   4 +-
 arch/arm/boot/dts/sun5i-a10s.dtsi                  |   4 +-
 arch/arm/boot/dts/sun7i-a20.dtsi                   |   4 +-
 arch/arm/boot/dts/tegra114.dtsi                    |   4 +
 arch/arm/boot/dts/tegra20.dtsi                     |   4 +
 arch/arm/boot/dts/tegra30-cardhu.dtsi              |   2 +-
 arch/arm/boot/dts/tegra30.dtsi                     |   4 +
 arch/arm/boot/dts/testcases/tests.dtsi             |   2 -
 arch/arm/boot/dts/tps65910.dtsi                    |   5 +
 arch/arm/boot/dts/twl4030.dtsi                     |   7 +
 arch/arm/boot/dts/versatile-pb.dts                 |   4 +-
 arch/arm/configs/multi_v7_defconfig                |   1 +
 arch/arm/include/asm/cacheflush.h                  |   1 +
 arch/arm/include/asm/pgtable-3level.h              |  15 +-
 arch/arm/include/asm/spinlock.h                    |  15 +-
 arch/arm/kernel/setup.c                            |   2 +-
 arch/arm/mach-hisi/Kconfig                         |   2 +-
 arch/arm/mach-imx/Makefile                         |   2 -
 arch/arm/mach-imx/clk-imx6q.c                      |   3 +
 arch/arm/mach-imx/clk-imx6sl.c                     |   3 +
 arch/arm/mach-imx/common.h                         |   4 +-
 arch/arm/mach-imx/pm-imx6q.c                       |   2 -
 arch/arm/mach-moxart/Kconfig                       |   1 -
 arch/arm/mach-omap1/board-nokia770.c               |   1 +
 arch/arm/mach-omap2/Kconfig                        |  10 +-
 arch/arm/mach-omap2/board-generic.c                |   4 +
 arch/arm/mach-omap2/clockdomains3xxx_data.c        |   2 +-
 arch/arm/mach-omap2/common.h                       |   3 +
 arch/arm/mach-omap2/devices.c                      |   3 +
 arch/arm/mach-omap2/display.c                      | 166 ++++
 arch/arm/mach-omap2/display.h                      |   3 +
 arch/arm/mach-omap2/dss-common.c                   | 224 +-----
 arch/arm/mach-omap2/gpmc-nand.c                    |  31 +-
 arch/arm/mach-omap2/gpmc.c                         |   4 +-
 arch/arm/mach-omap2/io.c                           |   9 -
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |  12 +-
 arch/arm/mach-omap2/omap_hwmod_54xx_data.c         |  83 ++
 arch/arm/mach-omap2/pdata-quirks.c                 | 120 ++-
 arch/arm/mach-pxa/am300epd.c                       |   1 +
 arch/arm/mach-pxa/include/mach/balloon3.h          |   2 +
 arch/arm/mach-pxa/include/mach/corgi.h             |   1 +
 arch/arm/mach-pxa/include/mach/csb726.h            |   2 +
 arch/arm/mach-pxa/include/mach/gumstix.h           |   1 +
 arch/arm/mach-pxa/include/mach/idp.h               |   1 +
 arch/arm/mach-pxa/include/mach/palmld.h            |   2 +
 arch/arm/mach-pxa/include/mach/palmt5.h            |   2 +
 arch/arm/mach-pxa/include/mach/palmtc.h            |   2 +
 arch/arm/mach-pxa/include/mach/palmtx.h            |   2 +
 arch/arm/mach-pxa/include/mach/pcm027.h            |   2 +
 arch/arm/mach-pxa/include/mach/pcm990_baseboard.h  |   1 +
 arch/arm/mach-pxa/include/mach/poodle.h            |   2 +
 arch/arm/mach-pxa/include/mach/spitz.h             |   2 +-
 arch/arm/mach-pxa/include/mach/tosa.h              |   2 +
 arch/arm/mach-pxa/include/mach/trizeps4.h          |   2 +
 arch/arm/mach-pxa/mioa701.c                        |   9 +
 arch/arm/mach-shmobile/Kconfig                     |   2 +-
 arch/arm/mach-tegra/pm.c                           |   1 +
 arch/arm/mach-tegra/tegra.c                        |  10 +
 arch/arm/mach-zynq/common.c                        |  14 +
 arch/arm/mm/dma-mapping.c                          |   2 +-
 arch/arm/mm/mm.h                                   |   1 +
 arch/arm/mm/mmu.c                                  |   7 +-
 arch/arm/mm/proc-v6.S                              |   3 +-
 arch/arm/mm/proc-v7.S                              |   2 +-
 arch/arm/plat-omap/Kconfig                         |   3 -
 arch/arm64/include/uapi/asm/kvm.h                  |   9 +
 arch/avr32/Makefile                                |   2 +-
 arch/avr32/boards/mimc200/fram.c                   |   1 +
 arch/avr32/include/asm/Kbuild                      |   1 +
 arch/avr32/include/asm/io.h                        |   2 +
 arch/microblaze/include/asm/delay.h                |   2 +
 arch/microblaze/include/asm/io.h                   |   6 +
 arch/microblaze/kernel/head.S                      |   2 +-
 arch/powerpc/include/asm/dma-mapping.h             |   1 +
 arch/powerpc/include/asm/eeh.h                     |  21 +-
 arch/powerpc/include/asm/hugetlb.h                 |   2 +-
 arch/powerpc/include/asm/iommu.h                   |   1 +
 arch/powerpc/include/asm/pgtable-ppc64.h           |  26 +-
 arch/powerpc/include/asm/pgtable.h                 |  22 +
 arch/powerpc/include/asm/sections.h                |  12 +
 arch/powerpc/include/asm/vdso.h                    |   6 +-
 arch/powerpc/kernel/dma.c                          |  10 +-
 arch/powerpc/kernel/eeh.c                          |  32 +-
 arch/powerpc/kernel/eeh_driver.c                   |   8 +-
 arch/powerpc/kernel/iommu.c                        |  12 +
 arch/powerpc/kernel/irq.c                          |   5 +
 arch/powerpc/kernel/machine_kexec.c                |  14 +-
 arch/powerpc/kernel/machine_kexec_64.c             |   6 +-
 arch/powerpc/kernel/misc_32.S                      |   5 +-
 arch/powerpc/kernel/reloc_64.S                     |   4 +-
 arch/powerpc/kernel/setup_32.c                     |   5 +
 arch/powerpc/kernel/vdso32/vdso32_wrapper.S        |   2 +-
 arch/powerpc/kernel/vdso64/vdso64_wrapper.S        |   2 +-
 arch/powerpc/mm/hash_utils_64.c                    |  14 +
 arch/powerpc/mm/pgtable_64.c                       |  12 +-
 arch/powerpc/mm/subpage-prot.c                     |   2 +-
 arch/powerpc/perf/core-book3s.c                    |   5 +-
 arch/powerpc/perf/power8-pmu.c                     | 144 ++++
 arch/powerpc/platforms/powernv/eeh-ioda.c          |  32 +-
 arch/powerpc/platforms/powernv/eeh-powernv.c       |   2 +-
 arch/powerpc/platforms/powernv/pci-ioda.c          |  84 ++
 arch/powerpc/platforms/powernv/pci.c               |  10 +
 arch/powerpc/platforms/powernv/pci.h               |   6 +-
 arch/powerpc/platforms/powernv/powernv.h           |   8 +
 arch/powerpc/platforms/powernv/setup.c             |   9 +
 arch/powerpc/platforms/pseries/Kconfig             |   1 +
 arch/powerpc/platforms/pseries/eeh_pseries.c       |   2 +-
 arch/powerpc/platforms/pseries/pci.c               |  22 +-
 arch/powerpc/platforms/pseries/setup.c             |   3 +-
 arch/powerpc/sysdev/mpic.c                         |  38 +-
 arch/powerpc/xmon/xmon.c                           |  24 +-
 arch/s390/appldata/appldata_base.c                 |   1 +
 arch/s390/kernel/head64.S                          |   7 +-
 arch/s390/mm/page-states.c                         |  10 +
 arch/sparc/Kconfig                                 |   2 +-
 arch/sparc/mm/srmmu.c                              |   2 +
 arch/x86/include/asm/efi.h                         |   2 +
 arch/x86/include/asm/pgtable.h                     |  14 +-
 arch/x86/include/asm/tsc.h                         |   2 +-
 arch/x86/kernel/cpu/common.c                       |   7 +-
 arch/x86/kernel/cpu/perf_event.c                   |   8 +-
 arch/x86/kernel/cpu/perf_event.h                   |   1 +
 arch/x86/kernel/cpu/perf_event_intel.c             |  11 +-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c      |  10 +-
 arch/x86/kernel/cpu/perf_event_p6.c                |  48 +-
 arch/x86/kernel/ftrace.c                           |  83 +-
 arch/x86/kernel/pci-dma.c                          |   4 +-
 arch/x86/kernel/tsc.c                              |  11 +-
 arch/x86/kernel/tsc_msr.c                          |  30 +-
 arch/x86/mm/fault.c                                |  14 +-
 arch/x86/platform/efi/efi-bgrt.c                   |   2 +-
 arch/x86/platform/efi/efi.c                        |   5 +-
 arch/x86/platform/efi/efi_32.c                     |   6 +
 arch/x86/platform/efi/efi_64.c                     |   9 +
 arch/x86/xen/mmu.c                                 |   4 +-
 block/blk-core.c                                   |  20 +-
 block/blk-exec.c                                   |   2 +-
 block/blk-flush.c                                  | 101 +--
 block/blk-lib.c                                    |   8 +
 block/blk-merge.c                                  |  91 ++-
 block/blk-mq-tag.c                                 |   2 +-
 block/blk-mq.c                                     | 143 ++--
 block/blk-mq.h                                     |   4 +-
 block/blk-sysfs.c                                  |   2 +
 block/blk-timeout.c                                |   2 +-
 block/blk.h                                        |   2 +-
 drivers/acpi/ac.c                                  |   2 +
 drivers/acpi/battery.c                             |   2 +
 drivers/acpi/blacklist.c                           |  58 --
 drivers/acpi/button.c                              |   2 +
 drivers/acpi/container.c                           |   5 +-
 drivers/acpi/dock.c                                |  13 +-
 drivers/acpi/fan.c                                 |   3 +
 drivers/acpi/pci_irq.c                             |   1 +
 drivers/acpi/sbs.c                                 |   4 +-
 drivers/acpi/thermal.c                             |   2 +
 drivers/acpi/video.c                               | 147 +++-
 drivers/acpi/video_detect.c                        |  16 -
 drivers/ata/Kconfig                                |   1 +
 drivers/ata/ahci.c                                 |  18 +-
 drivers/ata/libata-pmp.c                           |   7 +-
 drivers/ata/pata_imx.c                             |   8 +-
 drivers/ata/sata_mv.c                              |  16 +-
 drivers/ata/sata_sil.c                             |   1 +
 drivers/base/component.c                           |   8 +
 drivers/base/dma-buf.c                             |  25 +-
 drivers/block/null_blk.c                           |  97 +--
 drivers/block/virtio_blk.c                         |   7 +-
 drivers/block/xen-blkback/blkback.c                |  66 +-
 drivers/block/xen-blkback/common.h                 |   5 +-
 drivers/block/xen-blkback/xenbus.c                 |  14 +
 drivers/block/xen-blkfront.c                       |  11 +-
 drivers/char/Kconfig                               |   1 +
 drivers/char/raw.c                                 |   2 +-
 drivers/clocksource/bcm_kona_timer.c               |  54 +-
 drivers/cpufreq/cpufreq.c                          |   3 +-
 drivers/cpufreq/intel_pstate.c                     |  26 +-
 drivers/cpufreq/powernow-k8.c                      |  10 +-
 drivers/crypto/nx/nx-842.c                         |  29 +-
 drivers/dma/Kconfig                                |   1 +
 drivers/dma/mv_xor.c                               |  24 +-
 drivers/edac/edac_mc.c                             |  13 +-
 drivers/edac/edac_mc_sysfs.c                       |  10 +-
 drivers/edac/edac_module.h                         |   2 +-
 drivers/gpio/Kconfig                               |   1 +
 drivers/gpio/gpio-bcm-kona.c                       |   4 +-
 drivers/gpio/gpio-clps711x.c                       |   1 +
 drivers/gpio/gpio-intel-mid.c                      |   4 +-
 drivers/gpio/gpio-xtensa.c                         |  16 +
 drivers/gpu/drm/drm_ioctl.c                        |  12 +
 drivers/gpu/drm/exynos/Kconfig                     |   4 +-
 drivers/gpu/drm/exynos/exynos_drm_drv.c            |  14 +-
 drivers/gpu/drm/exynos/exynos_drm_g2d.c            |   2 +-
 drivers/gpu/drm/exynos/exynos_drm_ipp.c            |   3 +-
 drivers/gpu/drm/exynos/exynos_hdmi.c               |  66 +-
 drivers/gpu/drm/i2c/tda998x_drv.c                  |  19 +-
 drivers/gpu/drm/i915/i915_drv.h                    |   8 +
 drivers/gpu/drm/i915/i915_gpu_error.c              |   5 +-
 drivers/gpu/drm/i915/i915_irq.c                    |   3 +-
 drivers/gpu/drm/i915/intel_display.c               |  14 +
 drivers/gpu/drm/i915/intel_dp.c                    |  31 +-
 drivers/gpu/drm/i915/intel_i2c.c                   |   7 -
 drivers/gpu/drm/i915/intel_opregion.c              |   9 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c            |  21 +
 drivers/gpu/drm/i915/intel_ringbuffer.h            |   1 +
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_crtc.c           | 179 +++--
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_plane.c          |   4 +-
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c           |   7 +-
 drivers/gpu/drm/msm/msm_gem.c                      |   2 +-
 drivers/gpu/drm/msm/msm_gem_submit.c               |   9 +-
 drivers/gpu/drm/msm/msm_gpu.c                      |   3 -
 drivers/gpu/drm/nouveau/Makefile                   |   1 +
 drivers/gpu/drm/nouveau/core/engine/device/nv40.c  |  10 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nv50.c    |   2 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c    |   2 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nv50.c   |   2 +-
 drivers/gpu/drm/nouveau/core/include/subdev/mc.h   |   1 +
 drivers/gpu/drm/nouveau/core/subdev/bios/base.c    |   4 +
 drivers/gpu/drm/nouveau/core/subdev/fb/nv1a.c      |   2 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/nv04.h      |   1 +
 drivers/gpu/drm/nouveau/core/subdev/mc/nv44.c      |   2 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/nv4c.c      |  45 ++
 drivers/gpu/drm/nouveau/nouveau_acpi.c             |  26 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c               |   2 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |   3 +
 drivers/gpu/drm/nouveau/nouveau_vga.c              |   4 +-
 drivers/gpu/drm/radeon/atombios_crtc.c             |  15 +-
 drivers/gpu/drm/radeon/atombios_encoders.c         |   7 +-
 drivers/gpu/drm/radeon/btc_dpm.c                   |  32 +
 drivers/gpu/drm/radeon/btcd.h                      |   4 +
 drivers/gpu/drm/radeon/evergreen.c                 |   2 +-
 drivers/gpu/drm/radeon/kv_dpm.c                    |   2 +-
 drivers/gpu/drm/radeon/ni_dpm.c                    |  10 +-
 drivers/gpu/drm/radeon/r600.c                      |   4 +
 drivers/gpu/drm/radeon/radeon.h                    |   4 +-
 drivers/gpu/drm/radeon/radeon_asic.c               |   2 +-
 drivers/gpu/drm/radeon/radeon_asic.h               |   2 +
 drivers/gpu/drm/radeon/radeon_display.c            |   2 +
 drivers/gpu/drm/radeon/radeon_ring.c               |   2 +-
 drivers/gpu/drm/radeon/radeon_semaphore.c          |  19 +-
 drivers/gpu/drm/radeon/rv770_dpm.c                 |  14 +-
 drivers/gpu/drm/radeon/si.c                        |   4 +
 drivers/gpu/drm/radeon/si_dpm.c                    |   5 +-
 drivers/gpu/drm/radeon/sumo_dpm.c                  |   2 +-
 drivers/gpu/drm/radeon/trinity_dpm.c               |   3 +-
 drivers/gpu/drm/radeon/uvd_v2_2.c                  |   1 -
 drivers/gpu/drm/ttm/ttm_agp_backend.c              |   1 +
 drivers/gpu/drm/vmwgfx/svga3d_reg.h                | 122 +--
 drivers/gpu/drm/vmwgfx/svga3d_surfacedefs.h        |  11 +-
 drivers/gpu/drm/vmwgfx/svga_reg.h                  |   9 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_context.c            |   9 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |   3 +
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                |   1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |   9 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c              |   3 +
 drivers/gpu/drm/vmwgfx/vmwgfx_shader.c             |  16 +-
 drivers/hid/hid-apple.c                            |   3 +
 drivers/hid/hid-core.c                             |   3 +
 drivers/hid/hid-hyperv.c                           |  11 +-
 drivers/hid/hid-ids.h                              |   8 +
 drivers/hid/hid-input.c                            |   2 +-
 drivers/hid/hid-microsoft.c                        |   4 +
 drivers/hid/hid-multitouch.c                       |   5 +
 drivers/hid/hid-sensor-hub.c                       |   3 +
 drivers/hid/i2c-hid/i2c-hid.c                      |   2 +-
 drivers/hid/usbhid/hid-quirks.c                    |   1 +
 drivers/hv/connection.c                            |  13 +-
 drivers/hwmon/max1668.c                            |   2 +-
 drivers/hwmon/ntc_thermistor.c                     |   6 +-
 drivers/i2c/busses/i2c-mv64xxx.c                   |  33 +-
 drivers/iio/accel/bma180.c                         |  16 +-
 drivers/iio/adc/max1363.c                          |   2 +-
 drivers/iio/imu/adis16400.h                        |   1 +
 drivers/iio/imu/adis16400_core.c                   |  10 +-
 drivers/iio/light/tsl2563.c                        |  16 +-
 drivers/iio/magnetometer/ak8975.c                  |  16 +-
 drivers/iio/magnetometer/mag3110.c                 |   8 +-
 drivers/infiniband/hw/amso1100/c2.c                |   4 +-
 drivers/infiniband/hw/amso1100/c2_rnic.c           |   3 +-
 drivers/infiniband/hw/cxgb4/cm.c                   |   1 +
 drivers/infiniband/hw/mlx4/main.c                  | 185 +++--
 drivers/infiniband/hw/mlx5/Kconfig                 |   2 +-
 drivers/infiniband/hw/mlx5/main.c                  |  22 +-
 drivers/infiniband/hw/mlx5/qp.c                    |  18 +-
 drivers/infiniband/hw/mlx5/user.h                  |   7 +
 drivers/infiniband/hw/nes/nes.c                    |   5 +-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c         |   2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        |   4 +-
 drivers/infiniband/hw/qib/qib_iba7322.c            |   5 +
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c      |   9 +-
 drivers/infiniband/ulp/iser/iser_initiator.c       |   3 +-
 drivers/infiniband/ulp/iser/iser_verbs.c           |  10 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |   1 +
 drivers/infiniband/ulp/srpt/ib_srpt.c              |  14 +-
 drivers/iommu/arm-smmu.c                           | 105 ++-
 drivers/irqchip/irq-orion.c                        |  22 +-
 drivers/isdn/hisax/q931.c                          |   2 +-
 drivers/md/bcache/bcache.h                         |   4 +-
 drivers/md/bcache/bset.c                           |   7 +-
 drivers/md/bcache/btree.c                          |   4 +-
 drivers/md/bcache/extents.c                        |   2 +-
 drivers/md/bcache/request.c                        |   6 +-
 drivers/md/bcache/sysfs.c                          |   2 +-
 drivers/md/raid1.c                                 |  13 +-
 drivers/md/raid5.c                                 |  90 +--
 drivers/message/i2o/i2o_config.c                   |   4 +-
 drivers/mfd/da9055-i2c.c                           |  12 +-
 drivers/mfd/max14577.c                             |   2 +
 drivers/mfd/max8997.c                              |   6 +-
 drivers/mfd/max8998.c                              |   6 +-
 drivers/mfd/sec-core.c                             |   2 +
 drivers/mfd/tps65217.c                             |   4 +-
 drivers/mfd/wm8994-core.c                          |   2 +-
 drivers/misc/genwqe/card_dev.c                     |   1 +
 drivers/misc/mei/client.c                          |  15 +-
 drivers/misc/mic/host/mic_virtio.c                 |   3 +-
 drivers/misc/sgi-gru/grukdump.c                    |  11 +-
 drivers/mmc/card/queue.c                           |   2 +-
 drivers/net/Kconfig                                |   2 +-
 drivers/net/bonding/bond_3ad.c                     |   6 +-
 drivers/net/bonding/bond_3ad.h                     |   1 +
 drivers/net/bonding/bond_main.c                    |  35 +-
 drivers/net/bonding/bond_options.c                 |   2 +-
 drivers/net/can/Kconfig                            |   2 +-
 drivers/net/can/dev.c                              |  15 +-
 drivers/net/can/flexcan.c                          |   7 +-
 drivers/net/can/janz-ican3.c                       |  20 +-
 drivers/net/can/usb/kvaser_usb.c                   |   2 +
 drivers/net/can/vcan.c                             |   9 +-
 drivers/net/ethernet/3com/3c59x.c                  |   2 -
 drivers/net/ethernet/allwinner/sun4i-emac.c        |   3 +
 drivers/net/ethernet/atheros/alx/main.c            |   1 +
 drivers/net/ethernet/broadcom/bnx2.c               |   2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |   4 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h    |   4 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |  12 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c  |   6 +-
 drivers/net/ethernet/broadcom/tg3.c                |  17 +-
 drivers/net/ethernet/dec/tulip/tulip_core.c        |   1 +
 drivers/net/ethernet/ethoc.c                       | 138 +++-
 drivers/net/ethernet/freescale/fec_main.c          |   4 +-
 drivers/net/ethernet/intel/e100.c                  |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   6 +-
 drivers/net/ethernet/lantiq_etop.c                 |   2 +-
 drivers/net/ethernet/marvell/Kconfig               |   6 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |   4 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h       |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig    |   2 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.c     |   6 -
 drivers/net/ethernet/sfc/tx.c                      |   2 +
 drivers/net/ethernet/stmicro/stmmac/Kconfig        |  11 +
 drivers/net/ethernet/stmicro/stmmac/Makefile       |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c    | 330 ++++++++
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |   3 +
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |   5 +
 drivers/net/ethernet/ti/cpsw.c                     |  25 +-
 drivers/net/ethernet/tile/tilegx.c                 |   2 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |  13 +-
 drivers/net/hyperv/netvsc_drv.c                    |  53 +-
 drivers/net/irda/Kconfig                           |   7 -
 drivers/net/irda/Makefile                          |   1 -
 drivers/net/irda/ep7211-sir.c                      |  70 --
 drivers/net/irda/irtty-sir.c                       |   1 -
 drivers/net/macvlan.c                              |   5 +-
 drivers/net/phy/dp83640.c                          |  32 +-
 drivers/net/phy/mdio-sun4i.c                       |   3 +
 drivers/net/phy/phy_device.c                       |  38 +-
 drivers/net/team/team.c                            |   2 +-
 drivers/net/tun.c                                  |   2 +-
 drivers/net/usb/Kconfig                            |  15 +
 drivers/net/usb/Makefile                           |   1 +
 drivers/net/usb/asix_devices.c                     |   3 +-
 drivers/net/usb/ax88179_178a.c                     |   4 +
 drivers/net/usb/gl620a.c                           |   4 +
 drivers/net/usb/hso.c                              |  32 +-
 drivers/net/usb/mcs7830.c                          |   5 +-
 drivers/net/usb/net1080.c                          |   4 +
 drivers/net/usb/qmi_wwan.c                         |  11 +-
 drivers/net/usb/r8152.c                            |  17 +-
 drivers/net/usb/rndis_host.c                       |   4 +
 drivers/net/usb/smsc75xx.c                         |   4 +
 drivers/net/usb/smsc95xx.c                         |   4 +
 drivers/net/usb/sr9800.c                           | 874 +++++++++++++++=
+++++
 drivers/net/usb/sr9800.h                           | 202 +++++
 drivers/net/usb/usbnet.c                           |  25 +-
 drivers/net/vxlan.c                                |   3 -
 drivers/net/wan/dlci.c                             |   5 -
 drivers/net/wireless/ath/ar5523/ar5523.c           |   2 +-
 drivers/net/wireless/ath/ath5k/phy.c               |   2 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |   4 +
 drivers/net/wireless/ath/ath9k/htc.h               |   2 +
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |   8 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |  63 +-
 drivers/net/wireless/ath/ath9k/hw.c                |   5 +-
 drivers/net/wireless/ath/ath9k/init.c              |   8 +-
 drivers/net/wireless/hostap/hostap_proc.c          |   2 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |  22 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c             |   2 +-
 drivers/net/wireless/iwlwifi/iwl-modparams.h       |  11 +-
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c       |   5 +
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h     |   4 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c        |  24 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c            |   5 +-
 drivers/net/wireless/iwlwifi/mvm/sta.c             |   2 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c              |  73 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c           |   2 +
 drivers/net/wireless/iwlwifi/pcie/drv.c            |   7 +-
 drivers/net/wireless/mwifiex/main.c                |   2 +-
 drivers/net/wireless/rt2x00/rt2500pci.c            |   5 +
 drivers/net/wireless/rt2x00/rt2500usb.c            |   5 +
 drivers/net/wireless/rt2x00/rt2800lib.c            |   5 +-
 drivers/net/wireless/rtl818x/rtl8180/dev.c         |  23 +-
 drivers/net/wireless/rtl818x/rtl8187/rtl8187.h     |  10 +-
 drivers/net/wireless/rtlwifi/ps.c                  |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c        |  18 +-
 drivers/net/xen-netback/common.h                   |   6 +-
 drivers/net/xen-netback/interface.c                |   1 -
 drivers/net/xen-netback/netback.c                  |  16 +-
 drivers/net/xen-netfront.c                         |   5 +-
 drivers/of/address.c                               |   5 +-
 drivers/of/base.c                                  | 128 +--
 drivers/of/of_mdio.c                               |  22 +-
 drivers/of/selftest.c                              |  67 ++
 drivers/of/testcase-data/testcases.dtsi            |   3 +
 .../of/testcase-data}/tests-interrupts.dtsi        |   0
 drivers/of/testcase-data/tests-match.dtsi          |  19 +
 .../of/testcase-data}/tests-phandle.dtsi           |   0
 drivers/pci/host/pci-mvebu.c                       |  11 +-
 drivers/pci/hotplug/acpiphp_glue.c                 |  15 +-
 drivers/pci/msi.c                                  |  10 +-
 drivers/pci/pci.c                                  |  10 +
 drivers/phy/Kconfig                                |   3 +-
 drivers/phy/phy-core.c                             |  76 +-
 drivers/phy/phy-exynos-dp-video.c                  |   8 +-
 drivers/phy/phy-exynos-mipi-video.c                |  10 +-
 drivers/phy/phy-mvebu-sata.c                       |  10 +-
 drivers/phy/phy-omap-usb2.c                        |  10 +-
 drivers/phy/phy-twl4030-usb.c                      |  10 +-
 drivers/power/ds2782_battery.c                     |   2 +-
 drivers/power/isp1704_charger.c                    |   2 -
 drivers/power/max17040_battery.c                   |   5 +-
 drivers/regulator/core.c                           |   2 +-
 drivers/regulator/da9055-regulator.c               |   4 +-
 drivers/regulator/da9063-regulator.c               |   4 +-
 drivers/regulator/max14577.c                       |  10 +-
 drivers/regulator/s5m8767.c                        |   4 +-
 drivers/s390/cio/cio.c                             |  40 +-
 drivers/s390/cio/qdio.h                            |  14 +-
 drivers/s390/cio/qdio_main.c                       |   2 +-
 drivers/sbus/char/jsflash.c                        |   1 -
 drivers/scsi/qla2xxx/qla_target.c                  |   2 -
 drivers/scsi/qla2xxx/qla_target.h                  |   1 -
 drivers/scsi/scsi_lib.c                            |   2 +-
 drivers/spi/Kconfig                                |   4 +-
 drivers/spi/spi-nuc900.c                           |   2 +
 drivers/spi/spi.c                                  |   4 +-
 drivers/staging/android/ashmem.c                   |  45 +-
 drivers/staging/android/binder.c                   |   3 +-
 drivers/staging/android/ion/compat_ion.c           |  26 +-
 drivers/staging/android/ion/ion_dummy_driver.c     |  12 +-
 drivers/staging/android/ion/ion_heap.c             |   2 +-
 drivers/staging/android/ion/ion_priv.h             |   1 +
 drivers/staging/android/ion/ion_system_heap.c      |   6 +-
 drivers/staging/android/sw_sync.h                  |  17 +
 drivers/staging/android/sync.c                     |  14 +-
 drivers/staging/bcm/Bcmnet.c                       |   2 +-
 drivers/staging/comedi/drivers.c                   |   2 -
 drivers/staging/comedi/drivers/adv_pci1710.c       |  17 +-
 drivers/staging/comedi/drivers/usbduxsigma.c       |   6 +-
 drivers/staging/dgrp/dgrp_net_ops.c                | 330 ++++----
 drivers/staging/gdm72xx/gdm_usb.c                  |   3 +
 drivers/staging/iio/Documentation/iio_utils.h      |   6 +-
 drivers/staging/iio/adc/ad799x_core.c              |  13 +-
 drivers/staging/iio/adc/mxs-lradc.c                |   6 +-
 drivers/staging/iio/impedance-analyzer/ad5933.c    |   2 +-
 drivers/staging/imx-drm/imx-drm-core.c             |  55 +-
 drivers/staging/imx-drm/imx-hdmi.c                 |  22 +-
 drivers/staging/lustre/TODO                        |   5 +-
 .../include/linux/libcfs/libcfs_kernelcomm.h       |   2 +
 .../lustre/include/linux/libcfs/libcfs_private.h   |   2 +-
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c |   2 +-
 .../staging/lustre/lnet/klnds/socklnd/socklnd_cb.c |   5 +-
 .../lustre/lustre/include/lustre/lustre_user.h     |   3 +-
 drivers/staging/lustre/lustre/llite/dir.c          |   2 +-
 drivers/staging/lustre/lustre/mdc/mdc_request.c    |   6 +-
 drivers/staging/netlogic/xlr_net.c                 |   7 +-
 drivers/staging/octeon-usb/octeon-hcd.c            | 273 +++----
 drivers/staging/ozwpan/ozproto.c                   |   3 +-
 drivers/staging/rtl8188eu/core/rtw_wlan_util.c     |  22 +-
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c     |  12 +-
 drivers/staging/rtl8188eu/os_dep/os_intfs.c        |   2 +-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c        |   2 +-
 drivers/staging/rtl8821ae/Kconfig                  |   2 +-
 drivers/staging/rtl8821ae/wifi.h                   |   2 +-
 drivers/staging/usbip/userspace/libsrc/names.c     |   8 +-
 drivers/staging/usbip/vhci_sysfs.c                 |   3 +-
 drivers/staging/wlags49_h2/wl_wext.c               |   2 +-
 drivers/target/iscsi/iscsi_target_erl1.c           |   4 +-
 drivers/target/target_core_alua.c                  |   2 +-
 drivers/target/target_core_pr.c                    |  11 +-
 drivers/target/target_core_sbc.c                   |   8 +
 drivers/target/target_core_spc.c                   |   4 +-
 drivers/target/target_core_transport.c             |   5 +-
 drivers/tty/hvc/hvc_opal.c                         |   8 +-
 drivers/tty/hvc/hvc_rtas.c                         |  12 +-
 drivers/tty/hvc/hvc_udbg.c                         |   9 +-
 drivers/tty/hvc/hvc_xen.c                          |  17 +-
 drivers/tty/n_gsm.c                                |  11 +
 drivers/tty/n_tty.c                                |  14 +-
 drivers/tty/serial/8250/8250_core.c                |  18 +
 drivers/tty/serial/8250/8250_dw.c                  |   4 +-
 drivers/tty/serial/8250/8250_pci.c                 |   3 +-
 drivers/tty/serial/omap-serial.c                   |  11 +-
 drivers/tty/serial/sirfsoc_uart.c                  |   4 +-
 drivers/tty/vt/vt.c                                |   2 +
 drivers/usb/chipidea/udc.c                         |   4 +-
 drivers/usb/core/driver.c                          |  24 +-
 drivers/usb/core/hcd.c                             |   1 -
 drivers/usb/core/hub.c                             |   7 +-
 drivers/usb/core/usb.h                             |   1 -
 drivers/usb/dwc2/core.c                            |   2 +-
 drivers/usb/dwc2/hcd.c                             |  11 -
 drivers/usb/dwc2/platform.c                        |   3 +
 drivers/usb/gadget/bcm63xx_udc.c                   |  58 +-
 drivers/usb/gadget/f_fs.c                          |   7 +-
 drivers/usb/gadget/printer.c                       |   2 +-
 drivers/usb/gadget/s3c2410_udc.c                   |   2 +-
 drivers/usb/host/ehci-hub.c                        |  26 +-
 drivers/usb/host/xhci-dbg.c                        |   6 +-
 drivers/usb/host/xhci-mem.c                        |  14 +-
 drivers/usb/host/xhci-pci.c                        |   5 +
 drivers/usb/host/xhci-ring.c                       |  68 +-
 drivers/usb/host/xhci.c                            |  38 +-
 drivers/usb/host/xhci.h                            |  41 +-
 drivers/usb/musb/musb_core.c                       |  15 +-
 drivers/usb/musb/musb_host.c                       |   3 +
 drivers/usb/musb/musb_virthub.c                    |  26 +-
 drivers/usb/musb/omap2430.c                        |   2 -
 drivers/usb/phy/phy-msm-usb.c                      |  57 +-
 drivers/usb/phy/phy.c                              |   8 +-
 drivers/usb/serial/ftdi_sio.c                      |   3 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   7 +
 drivers/usb/serial/option.c                        |   6 +-
 drivers/usb/serial/qcserial.c                      |   3 +
 drivers/usb/serial/usb-serial-simple.c             |   3 +-
 drivers/usb/storage/Kconfig                        |   4 +-
 drivers/usb/storage/scsiglue.c                     |   6 +
 drivers/usb/storage/unusual_cypress.h              |   2 +-
 drivers/usb/storage/unusual_devs.h                 |   7 +
 drivers/vhost/net.c                                |  47 +-
 drivers/video/Kconfig                              |   2 +-
 drivers/video/exynos/Kconfig                       |   3 +-
 .../video/omap2/displays-new/connector-analog-tv.c |  43 +-
 drivers/video/omap2/displays-new/connector-dvi.c   |  43 +
 drivers/video/omap2/displays-new/connector-hdmi.c  |  30 +
 drivers/video/omap2/displays-new/encoder-tfp410.c  |  43 +-
 .../video/omap2/displays-new/encoder-tpd12s015.c   |  56 ++
 drivers/video/omap2/displays-new/panel-dsi-cm.c    |  60 +-
 .../omap2/displays-new/panel-sony-acx565akm.c      |  33 +-
 drivers/video/omap2/dss/Makefile                   |   2 +-
 drivers/video/omap2/dss/dispc.c                    |  24 +-
 drivers/video/omap2/dss/display.c                  |  28 +-
 drivers/video/omap2/dss/dpi.c                      |  49 +-
 drivers/video/omap2/dss/dsi.c                      | 147 +++-
 drivers/video/omap2/dss/dss-of.c                   | 159 ++++
 drivers/video/omap2/dss/dss.c                      |  66 ++
 drivers/video/omap2/dss/dss.h                      |   6 +
 drivers/video/omap2/dss/hdmi4.c                    |  14 +-
 drivers/video/omap2/dss/hdmi_wp.c                  |   2 +
 drivers/video/omap2/dss/sdi.c                      |  47 +-
 drivers/video/omap2/dss/venc.c                     |  66 +-
 drivers/video/omap2/omapfb/omapfb-main.c           |  67 +-
 drivers/vme/bridges/vme_ca91cx42.c                 |   4 +-
 drivers/vme/bridges/vme_tsi148.c                   |   4 +-
 drivers/watchdog/w83697hf_wdt.c                    |   2 +-
 drivers/xen/Makefile                               |   1 -
 drivers/xen/events/events_base.c                   |   2 +
 drivers/xen/xencomm.c                              | 219 -----
 fs/bio-integrity.c                                 |  13 +-
 fs/bio.c                                           |  15 +-
 fs/btrfs/disk-io.c                                 |   1 -
 fs/btrfs/inode.c                                   |   2 +-
 fs/btrfs/ioctl.c                                   |  16 -
 fs/btrfs/send.c                                    |  10 +
 fs/btrfs/super.c                                   |  11 +-
 fs/btrfs/sysfs.c                                   |  10 +-
 fs/ceph/acl.c                                      |  11 +-
 fs/ceph/dir.c                                      |  23 +-
 fs/ceph/file.c                                     |   1 +
 fs/ceph/super.c                                    |  32 +-
 fs/ceph/super.h                                    |   7 +-
 fs/ceph/xattr.c                                    |  54 +-
 fs/cifs/cifsacl.c                                  |  61 +-
 fs/cifs/cifsglob.h                                 |  11 +-
 fs/cifs/cifsproto.h                                |   9 +-
 fs/cifs/cifssmb.c                                  |  15 +-
 fs/cifs/dir.c                                      |   2 +-
 fs/cifs/file.c                                     |  70 +-
 fs/cifs/inode.c                                    |  15 +-
 fs/cifs/smb1ops.c                                  |   9 +
 fs/cifs/smb2glob.h                                 |   3 +
 fs/cifs/smb2ops.c                                  |  14 +-
 fs/cifs/smb2pdu.c                                  |   9 +-
 fs/cifs/smb2proto.h                                |   3 +-
 fs/cifs/xattr.c                                    |  15 +-
 fs/ext4/ext4.h                                     |   2 +
 fs/ext4/extents.c                                  |   1 +
 fs/ext4/ioctl.c                                    |   3 +-
 fs/ext4/resize.c                                   |  34 +-
 fs/ext4/super.c                                    |  20 +-
 fs/file.c                                          |   2 +-
 fs/fscache/object-list.c                           |   5 +
 fs/fscache/object.c                                |   3 +
 fs/jbd2/transaction.c                              |   6 +-
 fs/jfs/acl.c                                       |   2 +
 fs/lockd/svclock.c                                 |   8 +
 fs/nfs/dir.c                                       |   5 +
 fs/nfs/inode.c                                     |  14 +-
 fs/nfs/internal.h                                  |  12 +-
 fs/nfs/nfs3proc.c                                  |   1 +
 fs/nfs/nfs4client.c                                |   7 +-
 fs/nfs/nfs4namespace.c                             |  12 +-
 fs/nfs/nfs4state.c                                 |   5 +-
 fs/nfsd/nfs4acl.c                                  |   9 +-
 fs/ocfs2/alloc.c                                   |   2 +-
 fs/ocfs2/file.c                                    |  52 +-
 fs/ocfs2/namei.c                                   |  17 +
 fs/proc/vmcore.c                                   |  26 +-
 fs/reiserfs/do_balan.c                             | 895 +++++----------=
------
 fs/xfs/xfs_iops.c                                  |  16 +-
 fs/xfs/xfs_log_cil.c                               |  19 +-
 fs/xfs/xfs_mount.c                                 |  24 +-
 fs/xfs/xfs_sb.c                                    |  10 +-
 include/asm-generic/pgtable.h                      |  39 +
 include/drm/drmP.h                                 |   3 +
 include/drm/drm_crtc.h                             |   3 +
 include/drm/ttm/ttm_page_alloc.h                   |   2 +
 include/dt-bindings/pinctrl/am43xx.h               |   1 +
 include/linux/bio.h                                |  12 +
 include/linux/blk-mq.h                             |   9 +-
 include/linux/blkdev.h                             |  11 +-
 include/linux/can/skb.h                            |  38 +
 include/linux/ceph/ceph_fs.h                       |   5 +-
 include/linux/cgroup.h                             |   2 +
 include/linux/compiler-gcc4.h                      |   6 +-
 include/linux/dma-buf.h                            |   2 +-
 include/linux/gpio/consumer.h                      |   4 +-
 include/linux/hyperv.h                             |   2 +-
 include/linux/interrupt.h                          |   5 +
 include/linux/mfd/max8997-private.h                |   2 +-
 include/linux/mfd/max8998-private.h                |   2 +-
 include/linux/mfd/tps65217.h                       |   4 +-
 include/linux/mlx5/driver.h                        |   3 +
 include/linux/netdevice.h                          |  36 +-
 include/linux/of.h                                 | 153 ++--
 include/linux/of_device.h                          |   4 +-
 include/linux/pci.h                                |  20 +
 include/linux/phy/phy.h                            |  14 +
 include/linux/skbuff.h                             |  17 +
 include/linux/smp.h                                |   3 +
 include/linux/spi/spi.h                            |   7 +-
 include/linux/syscalls.h                           |   6 +-
 include/linux/usb.h                                |   2 -
 include/linux/workqueue.h                          |   5 +-
 include/net/datalink.h                             |   2 +
 include/net/dn.h                                   |   2 +
 include/net/dn_route.h                             |   2 +
 include/net/ethoc.h                                |   1 +
 include/net/ipx.h                                  |  11 +
 include/net/net_namespace.h                        |   8 +
 include/net/netfilter/nf_conntrack.h               |   2 +
 include/net/netfilter/nf_tables.h                  |   9 +-
 include/net/netfilter/nft_reject.h                 |  25 +
 include/net/sctp/structs.h                         |  14 +-
 include/rdma/ib_verbs.h                            |   3 +-
 include/target/target_core_base.h                  |   1 -
 include/trace/events/power.h                       |   7 +-
 include/uapi/drm/drm.h                             |   2 +
 include/uapi/drm/vmwgfx_drm.h                      |   1 +
 include/uapi/linux/btrfs.h                         |   1 -
 include/uapi/linux/in6.h                           |  23 +-
 include/uapi/linux/mic_ioctl.h                     |   2 +-
 include/uapi/xen/Kbuild                            |   2 +
 include/{ =3D> uapi}/xen/gntalloc.h                  |   0
 include/{ =3D> uapi}/xen/gntdev.h                    |   0
 include/video/omapdss.h                            |  14 +
 include/xen/interface/io/blkif.h                   |  34 +-
 include/xen/interface/xencomm.h                    |  41 -
 include/xen/xencomm.h                              |  77 --
 kernel/cgroup.c                                    |  60 +-
 kernel/irq/devres.c                                |  45 ++
 kernel/irq/irqdesc.c                               |   1 +
 kernel/power/console.c                             |   1 +
 kernel/printk/printk.c                             |   2 -
 kernel/sched/core.c                                |  28 +-
 kernel/sched/cpudeadline.c                         |   6 +-
 kernel/sched/deadline.c                            |  10 +-
 kernel/sched/fair.c                                |   2 +
 kernel/sched/sched.h                               |   1 -
 kernel/time/jiffies.c                              |   6 +
 kernel/time/sched_clock.c                          |  46 +-
 kernel/time/tick-broadcast.c                       |   1 +
 kernel/trace/ring_buffer.c                         |   7 +
 kernel/user_namespace.c                            |   2 +-
 kernel/workqueue.c                                 |   7 +
 lib/percpu_ida.c                                   |   7 +-
 mm/huge_memory.c                                   |   9 +-
 mm/memory-failure.c                                |   6 +-
 mm/mprotect.c                                      |  25 +-
 mm/slub.c                                          |  38 +-
 mm/vmpressure.c                                    |   1 +
 net/9p/client.c                                    |   2 +-
 net/9p/trans_virtio.c                              |   5 +-
 net/batman-adv/bat_iv_ogm.c                        |  30 +-
 net/batman-adv/hard-interface.c                    |  22 +-
 net/batman-adv/originator.c                        |  36 +
 net/batman-adv/originator.h                        |   4 +
 net/batman-adv/routing.c                           |   4 +-
 net/batman-adv/send.c                              |   9 +-
 net/batman-adv/translation-table.c                 |  23 +-
 net/bluetooth/hidp/core.c                          |  16 +-
 net/bluetooth/hidp/hidp.h                          |   4 +
 net/bridge/br_device.c                             |  54 +-
 net/bridge/br_fdb.c                                | 137 ++--
 net/bridge/br_if.c                                 |   6 +-
 net/bridge/br_input.c                              |   4 +-
 net/bridge/br_private.h                            |  13 +-
 net/bridge/br_stp_if.c                             |   2 +
 net/bridge/br_vlan.c                               |  27 +-
 net/caif/caif_dev.c                                |   1 +
 net/caif/cfsrvl.c                                  |   1 +
 net/can/af_can.c                                   |   3 +-
 net/can/bcm.c                                      |   4 +-
 net/can/raw.c                                      |   1 +
 net/core/dev.c                                     |  28 +-
 net/core/fib_rules.c                               |   7 +
 net/core/flow_dissector.c                          |  20 +-
 net/core/netpoll.c                                 |   4 +-
 net/core/rtnetlink.c                               |  21 +-
 net/core/sock.c                                    |   6 +-
 net/dccp/ccids/lib/tfrc.c                          |   2 +-
 net/dccp/ccids/lib/tfrc.h                          |   1 +
 net/decnet/af_decnet.c                             |   5 -
 net/ieee802154/6lowpan.c                           |  23 +-
 net/ipv4/devinet.c                                 |   3 +-
 net/ipv4/ip_forward.c                              |  71 +-
 net/ipv4/ip_tunnel.c                               |  29 +-
 net/ipv4/ipconfig.c                                |   2 +-
 net/ipv4/netfilter/Kconfig                         |   5 +
 net/ipv4/netfilter/Makefile                        |   1 +
 net/ipv4/netfilter/nf_nat_h323.c                   |   5 +-
 net/ipv4/netfilter/nft_reject_ipv4.c               |  75 ++
 net/ipv4/route.c                                   |  13 +-
 net/ipv4/tcp.c                                     |   2 +-
 net/ipv4/tcp_input.c                               |  18 +-
 net/ipv4/tcp_output.c                              |  15 +-
 net/ipv4/udp_offload.c                             |  17 +-
 net/ipv6/addrconf.c                                |   2 +
 net/ipv6/icmp.c                                    |   2 +-
 net/ipv6/ip6_output.c                              |  17 +-
 net/ipv6/netfilter/Kconfig                         |   5 +
 net/ipv6/netfilter/Makefile                        |   1 +
 net/ipv6/netfilter/nft_reject_ipv6.c               |  76 ++
 net/ipx/af_ipx.c                                   |  22 +-
 net/ipx/ipx_route.c                                |   4 -
 net/mac80211/cfg.c                                 |  44 +-
 net/mac80211/ht.c                                  |   4 +-
 net/mac80211/ibss.c                                |   5 +-
 net/mac80211/iface.c                               |  33 +-
 net/mac80211/tx.c                                  |   2 +-
 net/netfilter/Kconfig                              |   6 +-
 net/netfilter/Makefile                             |   1 +
 net/netfilter/ipvs/ip_vs_conn.c                    |   8 +-
 net/netfilter/nf_conntrack_core.c                  |  55 +-
 net/netfilter/nf_synproxy_core.c                   |   5 +-
 net/netfilter/nf_tables_api.c                      |  82 +-
 net/netfilter/nf_tables_core.c                     |   6 +-
 net/netfilter/nft_ct.c                             |  16 +-
 net/netfilter/nft_log.c                            |   5 +-
 net/netfilter/nft_lookup.c                         |   1 +
 net/netfilter/nft_queue.c                          |   4 +-
 net/netfilter/nft_rbtree.c                         |  16 +-
 net/netfilter/nft_reject.c                         |  89 +-
 net/netfilter/nft_reject_inet.c                    |  63 ++
 net/netfilter/xt_CT.c                              |   7 +-
 net/openvswitch/datapath.c                         |  23 +-
 net/openvswitch/flow_table.c                       |  88 +-
 net/openvswitch/flow_table.h                       |   2 +-
 net/packet/af_packet.c                             |  26 +-
 net/sched/sch_pie.c                                |  21 +-
 net/sctp/associola.c                               |  82 +-
 net/sctp/ipv6.c                                    |   2 +
 net/sctp/sm_statefuns.c                            |   2 +-
 net/sctp/socket.c                                  |  47 +-
 net/sctp/sysctl.c                                  |  18 +-
 net/sctp/ulpevent.c                                |   8 +-
 net/sunrpc/auth_gss/auth_gss.c                     |  19 +-
 net/sunrpc/backchannel_rqst.c                      |   6 +-
 net/sunrpc/svc_xprt.c                              |   6 +-
 net/sunrpc/xprtsock.c                              |   6 +-
 net/tipc/core.h                                    |   1 +
 net/tipc/link.c                                    |   7 +
 net/wireless/core.c                                |  17 +-
 net/wireless/core.h                                |   4 +-
 net/wireless/nl80211.c                             |  32 +-
 net/wireless/nl80211.h                             |   8 +-
 net/wireless/scan.c                                |  40 +-
 net/wireless/sme.c                                 |   2 +-
 scripts/Makefile.lib                               |   1 +
 scripts/checkpatch.pl                              |   4 +-
 scripts/get_maintainer.pl                          |   2 +-
 scripts/mod/file2alias.c                           |   4 +-
 sound/pci/hda/hda_codec.c                          |  34 +-
 sound/pci/hda/hda_generic.c                        |   8 +-
 sound/pci/hda/hda_generic.h                        |   1 +
 sound/pci/hda/hda_intel.c                          |   2 +-
 sound/pci/hda/patch_ca0132.c                       |  68 +-
 sound/pci/hda/patch_conexant.c                     |   3 +-
 sound/pci/hda/patch_realtek.c                      |  16 +-
 sound/pci/hda/patch_sigmatel.c                     |  40 +-
 sound/pci/hda/thinkpad_helper.c                    |   1 +
 sound/soc/blackfin/Kconfig                         |  11 +-
 sound/soc/codecs/da9055.c                          |  11 +-
 sound/soc/codecs/max98090.c                        |  21 +-
 sound/soc/codecs/rt5640.c                          |   1 +
 sound/soc/codecs/wm8993.c                          |   1 -
 sound/soc/davinci/davinci-evm.c                    |   1 +
 sound/soc/davinci/davinci-mcasp.c                  |  83 +-
 sound/soc/fsl/fsl_esai.c                           |   4 +-
 sound/soc/fsl/fsl_esai.h                           |   2 +-
 sound/soc/fsl/imx-mc13783.c                        |   1 -
 sound/soc/fsl/imx-sgtl5000.c                       |  10 +-
 sound/soc/fsl/imx-wm8962.c                         |  11 +-
 sound/soc/samsung/Kconfig                          |   6 +-
 sound/soc/txx9/txx9aclc-ac97.c                     |   8 +-
 sound/usb/mixer_maps.c                             |   9 +
 tools/perf/builtin-trace.c                         |  22 +
 tools/perf/util/parse-events.c                     |  17 +-
 tools/perf/util/probe-event.c                      |   2 +-
 tools/perf/util/session.c                          |   6 +
 virt/kvm/arm/vgic.c                                |   1 +
 virt/kvm/coalesced_mmio.c                          |   8 +-
 964 files changed, 15201 insertions(+), 5719 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/omap/dmm.txt
 create mode 100644 Documentation/devicetree/bindings/net/sti-dwmac.txt
 create mode 100644 Documentation/devicetree/bindings/power/bq2415x.txt
 create mode 100644 Documentation/devicetree/bindings/video/analog-tv-con=
nector.txt
 create mode 100644 Documentation/devicetree/bindings/video/dvi-connector=
=2Etxt
 create mode 100644 Documentation/devicetree/bindings/video/hdmi-connecto=
r.txt
 create mode 100644 Documentation/devicetree/bindings/video/panel-dsi-cm.=
txt
 create mode 100644 Documentation/devicetree/bindings/video/sony,acx565ak=
m.txt
 create mode 100644 Documentation/devicetree/bindings/video/ti,omap-dss.t=
xt
 create mode 100644 Documentation/devicetree/bindings/video/ti,omap2-dss.=
txt
 create mode 100644 Documentation/devicetree/bindings/video/ti,omap3-dss.=
txt
 create mode 100644 Documentation/devicetree/bindings/video/ti,omap4-dss.=
txt
 create mode 100644 Documentation/devicetree/bindings/video/ti,tfp410.txt=

 create mode 100644 Documentation/devicetree/bindings/video/ti,tpd12s015.=
txt
 delete mode 100644 Documentation/networking/3c505.txt
 create mode 100644 Documentation/spi/00-INDEX
 create mode 100644 Documentation/zh_CN/arm64/tagged-pointers.txt
 create mode 100644 arch/arm/boot/dts/am3517-craneboard.dts
 create mode 100644 arch/arm/boot/dts/am437x-gp-evm.dts
 create mode 100644 arch/arm/boot/dts/at91-sama5d3_xplained.dts
 create mode 100644 arch/arm/boot/dts/omap3-cm-t3517.dts
 create mode 100644 arch/arm/boot/dts/omap3-cm-t3530.dts
 create mode 100644 arch/arm/boot/dts/omap3-cm-t3x.dtsi
 create mode 100644 arch/arm/boot/dts/omap3-lilly-a83x.dtsi
 create mode 100644 arch/arm/boot/dts/omap3-lilly-dbb056.dts
 create mode 100644 arch/arm/boot/dts/omap3-overo-storm-tobi.dts
 rename arch/arm/boot/dts/{omap3-tobi.dts =3D> omap3-overo-tobi-common.dt=
si} (94%)
 create mode 100644 arch/arm/boot/dts/omap3-overo-tobi.dts
 create mode 100644 arch/arm/boot/dts/omap3-sbc-t3517.dts
 create mode 100644 arch/arm/boot/dts/omap3-sbc-t3530.dts
 create mode 100644 arch/arm/boot/dts/omap4-duovero-parlor.dts
 create mode 100644 arch/arm/boot/dts/omap4-duovero.dtsi
 delete mode 100644 arch/arm/boot/dts/testcases/tests.dtsi
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/mc/nv4c.c
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c
 delete mode 100644 drivers/net/irda/ep7211-sir.c
 create mode 100644 drivers/net/usb/sr9800.c
 create mode 100644 drivers/net/usb/sr9800.h
 create mode 100644 drivers/of/testcase-data/testcases.dtsi
 rename {arch/arm/boot/dts/testcases =3D> drivers/of/testcase-data}/tests=
-interrupts.dtsi (100%)
 create mode 100644 drivers/of/testcase-data/tests-match.dtsi
 rename {arch/arm/boot/dts/testcases =3D> drivers/of/testcase-data}/tests=
-phandle.dtsi (100%)
 create mode 100644 drivers/video/omap2/dss/dss-of.c
 delete mode 100644 drivers/xen/xencomm.c
 create mode 100644 include/net/netfilter/nft_reject.h
 rename include/{ =3D> uapi}/xen/gntalloc.h (100%)
 rename include/{ =3D> uapi}/xen/gntdev.h (100%)
 delete mode 100644 include/xen/interface/xencomm.h
 delete mode 100644 include/xen/xencomm.h
 create mode 100644 net/ipv4/netfilter/nft_reject_ipv4.c
 create mode 100644 net/ipv6/netfilter/nft_reject_ipv6.c
 create mode 100644 net/netfilter/nft_reject_inet.c


--4wd9LfIt31vlnhKehEp1KkhsUOlTVD2Bf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTQnFxAAoJEPo9qoy8lh71KcAP/1Znh3+cmuRhyGMsPRIIOt65
9T5GHJKSI16yFUV3QbKhjUxjTOSO1ohuC1zc+UJWK1J43r8ITbA+wqYKaxIUtvCr
H1A2pEij69sI0Dk0c1VXKYrcowHJTuoUTNQes2NwhQ3D/8wzf6gs7EfiFAwvw15Z
t/cYuiWsMLNAbD3TBu5tw8XJdsz2GBm8BXdQSuKOWeORr9WUctypgdmWScA8fK1d
K70su0ny49imDdPKjb4x3ZtNfNvL/dkfzIWK0ObZCSfJgiYoAwAxVW9fuCrSlTrz
8cWdsv2hTLsPmsWOfzdA7FcfT5o5lb51beGTeuOB43GFg9at/8Dvtqbwm3jXDKpS
pTNod6X56Y+LNz7vH/S+Y34s8XsTc1LcHcazwPhLGTDd0s6T5YPZLc91CZUkm3Si
AeFVO9GhLQN020HwQaIErZy+w69acU4F7tr7N32fsEnURMFRmYecd1MEL8PFXGzY
RuhJCX+EcYzbDAdcgRtoqokQ5Po5FoWZUIHWY4xeF57gy4ifAN6P3uR+od2TGjXN
7HHeKgBi3C88KfWBk+n+wncKdS1C55N7f6iHXLlc/inoZClRBjm1VSIJSu7GKLis
J4MlNl5ZRCYYp7PPpZF9V9TN8ZgEvclHPDECH5kG3FVaJDw4ZqbIXISl3fzfO0Q5
rK/dWY3Vh+5RiLAg45Ij
=3+J+
-----END PGP SIGNATURE-----

--4wd9LfIt31vlnhKehEp1KkhsUOlTVD2Bf--
