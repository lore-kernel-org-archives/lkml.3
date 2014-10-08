Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbaJHUZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 16:25:46 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:52487 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbaJHUZp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 16:25:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: torvalds@linux-foundation.org
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL 1/7] ARM: SoC non-critical bug fixes for 3.18
Date: Wed, 08 Oct 2014 22:25:06 +0200
Message-ID: <11860787.2HyTs6YqEL@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1922034.HH2lvbiFi0@wuerfel>
References: <1922034.HH2lvbiFi0@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V02:K0:eWFHAp1XwcoQIOqWUncJZXzjS2KU1EYt8JZEJ3QbteU
 KxgdGHQHO3Q6kQLk0YdP2oRB9T0YrPaZldCqzfySCGVftdEzZL
 8RP9g7xV/53KSp+OFzKTJ8riRZFoShoWiG1alaFFC/j4jjWs5n
 jSgtfclFzXhnBDPxwqybmINWjES/D1nxbCfHS6une8ubq00KMe
 xKtoilAYD0lneagnTp7oZdx2eZwCkbA2P58jFj/hXYCsyhf3f/
 I8jGN9R/8Xhox+rI7q1pBI3yLEUfCKmUkDcLizgjFdZ+vxGgCi
 POX/CGadeDE2G29OfiqIMma3wOKszTDoZzw+NlV8310HSUryFx
 cYnj2PKVVuZPLqiyLtDU=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 69e273c0b0a3c337a521d083374c918dc52c666f:

  Linux 3.17-rc3 (2014-08-31 18:23:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-nc-for-linus

for you to fetch changes up to 5df27823b5552e885e02c1ea0d2f52326d7d710c:

  MAINTAINERS: update Shawn's email address (2014-10-08 21:30:56 +0200)

----------------------------------------------------------------
ARM: SoC non-critical bug fixes for 3.18

These are bug fixes for harmless problems that were not important
enough to get fixed in 3.17. The majority of these are OMAP specific,
but there are also a couple for Marvell mvebu, cns3xxx, and others,
as well as some updates for the MAINTAINERS file.

In particular, Robert Jarzmik and Daniel Mack now volunteered to help
out maintaining the PXA platform, Krzysztof Halasa took over the
cns3xxx platform, Carlo Caione is the maintainer for the new Amlogic
meson platform, and Matthias Brugger is now listed for the mediatek
platform he recently contributed.

----------------------------------------------------------------
Andreas Henriksson (1):
      ARM: at91: fix at91sam9263ek DT mmc pinmuxing settings

Andrew Lunn (8):
      cpuidle: kirkwood: Remove ARCH_KIRKWOOD dependency
      ata: Remove ARCH_KIRKWOOD dependency
      thermal: Remove ARCH_KIRKWOOD dependency
      leds: Remove ARCH_KIRKWOOD dependency
      rtc: Remove ARCH_KIRKWOOD dependency
      watchdog: Remove ARCH_KIRKWOOD dependency
      cpufreq: Remove ARCH_KIRKWOOD dependency
      ARM: Kirkwood: Fix DT based DSA.

Arnaud Ebalard (2):
      ARM: mvebu: Netgear RN104: Use Hardware BCH ECC
      ARM: mvebu: Netgear RN2120: Use Hardware BCH ECC

Arnd Bergmann (3):
      Merge tag 'davinci-for-v3.18/board' of git://git.kernel.org/.../nsekhar/linux-davinci into next/fixes-non-critical
      Merge tag 'renesas-maintainers-for-v3.18' of git://git.kernel.org/.../horms/renesas into next/fixes-non-critical
      Merge tag 'at91-fixes-non-critical' of git://github.com/at91linux/linux-at91 into next/fixes-non-critical

Behan Webster (1):
      arm, vt8500, LLVMLlinux: Use mcr instead of mcr% for mach-vt8500

Carlo Caione (1):
      MAINTAINERS: Add entry for the Amlogic MesonX SoCs

Florian Fainelli (1):
      MAINTAINERS: add a third maintainer to mach-bcm

Krzysztof Hałasa (4):
      CNS3xxx: Fix debug UART.
      CNS3xxx: Fix logical PCIe topology.
      CNS3xxx: Fix PCIe read size limit.
      MAINTAINERS: CNS3xxx and IXP4xx update.

Ludovic Desroches (1):
      ARM: at91/PMC: don't forget to write PMC_PCDR register to disable clocks

Matthias Brugger (1):
      MAINTAINERS: Add maintainers entry for Mediatek SoCs

Nishanth Menon (9):
      ARM: dts: omap4-panda: Fix model and SoC family details
      ARM: dts: am335x-bone*: Fix model name and update compatibility information
      ARM: OMAP: DRA7: powerdomain data: fix powerdomain powerstate
      ARM: OMAP5: powerdomain data: fix powerdomain powerstate
      ARM: OMAP2+: powerdomain: pwrdm_for_each_clkdm iterate only valid clkdms
      ARM: OMAP2+: powerdomain: introduce logic for finding valid power domain
      ARM: OMAP4+: PM: Make logic state programmable
      ARM: OMAP4+: PM: use only valid low power state for suspend
      ARM: OMAP4+: PM: Use only valid low power state for CPU hotplug

Olof Johansson (2):
      Merge tag 'fixes-v3.18-not-urgent' of git://git.kernel.org/.../tmlind/linux-omap into next/fixes-non-critical
      Merge tag 'mvebu-fixes-3.17' of git://git.infradead.org/linux-mvebu into next/fixes-non-critical

Paul Bolle (1):
      ARM: spear: Remove references to PLAT_SPEAR_SINGLE

Peter Ujfalusi (2):
      ARM: davinci: board-da850-evm: Mark dcdc2 of TPS65070 as always_on
      ARM: davinci: board-da850-evm: Add needed regulators for tlv320aic3106 codec

Robert Jarzmik (1):
      MAINTAINERS: update ARM pxa maintainers

Roland Stigge (1):
      ARM: LPC32xx: Fix reset function

Shawn Guo (1):
      MAINTAINERS: update Shawn's email address

Simon Horman (1):
      ARM: shmobile: Remove genmai_defconfig from MAINTAINERS

Stephen Warren (2):
      MAINTAINERS: add Alexandre Courbot for Tegra
      MAINTAINERS: condense some Tegra related entries

Tony Lindgren (1):
      Merge branch 'pull/v3.18/powerdomain-fixes' of https://github.com/nmenon/linux-2.6-playground into omap-for-v3.18/fixes-not-urgent

Uwe Kleine-König (2):
      ARM: omap2: make arrays containing machine compatible strings const
      ARM: OMAP2+: make of_device_ids const

Xia Kaixu (1):
      ARM: cns3xxx: fix allmodconfig panic in pci driver

klightspeed@killerwolves.net (1):
      ARM: mvebu: Netgear RN102: Use Hardware BCH ECC

 MAINTAINERS                                        | 49 +++++++-------
 arch/arm/Kconfig.debug                             |  7 +-
 arch/arm/boot/dts/Makefile                         |  4 +-
 arch/arm/boot/dts/am335x-bone-common.dtsi          |  3 -
 arch/arm/boot/dts/am335x-bone.dts                  |  5 ++
 arch/arm/boot/dts/am335x-boneblack.dts             |  5 ++
 arch/arm/boot/dts/armada-370-netgear-rn102.dts     |  4 ++
 arch/arm/boot/dts/armada-370-netgear-rn104.dts     |  4 ++
 arch/arm/boot/dts/armada-xp-netgear-rn2120.dts     |  4 ++
 arch/arm/boot/dts/at91sam9263.dtsi                 |  2 +
 arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts     | 16 ++---
 arch/arm/boot/dts/kirkwood-rd88f6281-a.dts         | 43 ++++++++++++
 arch/arm/boot/dts/kirkwood-rd88f6281-a0.dts        | 26 -------
 ...-rd88f6281-a1.dts => kirkwood-rd88f6281-z0.dts} | 18 +++--
 arch/arm/boot/dts/kirkwood-rd88f6281.dtsi          | 27 ++------
 arch/arm/boot/dts/kirkwood.dtsi                    |  4 +-
 arch/arm/boot/dts/omap4-panda-common.dtsi          |  3 -
 arch/arm/boot/dts/omap4-panda-es.dts               |  5 ++
 arch/arm/boot/dts/omap4-panda.dts                  |  5 ++
 arch/arm/mach-at91/clock.c                         |  1 +
 arch/arm/mach-cns3xxx/cns3420vb.c                  |  1 +
 arch/arm/mach-cns3xxx/core.c                       |  1 +
 arch/arm/mach-cns3xxx/core.h                       |  6 ++
 arch/arm/mach-cns3xxx/pcie.c                       | 49 +++++++-------
 arch/arm/mach-davinci/board-da850-evm.c            | 15 ++++
 arch/arm/mach-lpc32xx/common.c                     | 29 ++------
 arch/arm/mach-omap2/board-generic.c                | 26 +++----
 arch/arm/mach-omap2/common.h                       |  2 +-
 arch/arm/mach-omap2/gpmc.c                         |  2 +-
 arch/arm/mach-omap2/irq.c                          |  2 +-
 arch/arm/mach-omap2/omap-mpuss-lowpower.c          |  4 ++
 arch/arm/mach-omap2/pdata-quirks.c                 |  2 +-
 arch/arm/mach-omap2/pm44xx.c                       |  9 ++-
 arch/arm/mach-omap2/powerdomain.c                  | 79 +++++++++++++++++++++-
 arch/arm/mach-omap2/powerdomain.h                  |  4 ++
 arch/arm/mach-omap2/powerdomains54xx_data.c        | 12 ++--
 arch/arm/mach-omap2/powerdomains7xx_data.c         | 14 ++--
 arch/arm/mach-omap2/prm_common.c                   |  2 +-
 arch/arm/mach-omap2/timer.c                        |  6 +-
 arch/arm/mach-spear/Kconfig                        |  9 ++-
 arch/arm/mach-vt8500/vt8500.c                      |  2 +-
 drivers/ata/Kconfig                                |  2 +-
 drivers/cpufreq/Kconfig.arm                        |  4 +-
 drivers/cpuidle/Kconfig.arm                        |  2 +-
 drivers/leds/Kconfig                               |  4 +-
 drivers/rtc/Kconfig                                |  2 +-
 drivers/thermal/Kconfig                            |  2 +-
 drivers/watchdog/Kconfig                           |  2 +-
 48 files changed, 327 insertions(+), 202 deletions(-)
 create mode 100644 arch/arm/boot/dts/kirkwood-rd88f6281-a.dts
 delete mode 100644 arch/arm/boot/dts/kirkwood-rd88f6281-a0.dts
 rename arch/arm/boot/dts/{kirkwood-rd88f6281-a1.dts => kirkwood-rd88f6281-z0.dts} (57%)

