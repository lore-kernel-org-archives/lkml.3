Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbaLIVor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 16:44:47 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:53692 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbaLIVoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 16:44:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL 8/9] ARM: SoC defconfig changes for 3.19
Date: Tue, 09 Dec 2014 22:43:38 +0100
Message-ID: <3558682.jkN2tlsPNy@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <4491193.a6KEQb1tZH@wuerfel>
References: <4491193.a6KEQb1tZH@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:A7Fv9wFTHb1dVIRS2Jv5sgEkeyqXvDoJS1K9Ir2E+YQbrrqC9uz
 HoWX+NktI6jr4Mb6xr5MlCViRQN5Bdi6OL0orsnQHvl8yD6fMpoZ2No93NT3FunKS8FdkNu
 fmnOWgXJAYUFM+1696Wg26j1iCRhYJ0b9haDia+W70anYtfwos0mm37wt8P82dYSp0zh+BR
 rUew0b1uSgQUkRJa0M/jw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:

  Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/defconfig-for-linus

for you to fetch changes up to d04169870b1022556473627f7cc3e17db5a3e29c:

  ARM: omap2plus_defconfig: enable ECAP and EHRPWM (2014-12-05 17:38:04 +0100)

----------------------------------------------------------------
ARM: SoC defconfig changes for 3.19

This is a collection of the various changes to defconfig files,
most importantly enabling some additional platforms in the
multi_v7_defconfig file. These are split out into a separate
branch to avoid most of the merge conflicts in the defconfig
files.

This also touches 12 other defconfig files for shmobile,
at91, hisilicon, keystone, mvebu, omap, and tegra.

----------------------------------------------------------------
Andrew Lunn (3):
      ARM: mvebu: Add DLINK DIR665 options to mvebu_v5_defconfig
      ARM: config: Add DLINK DIR665 options to multi_v5_defconfig
      ARM: mvebu: defconfig: Enable the mv88E6171 switch driver

Arnd Bergmann (8):
      Merge tag 'renesas-defconfig-for-v3.19' of git://git.kernel.org/.../horms/renesas into next/defconfig
      Merge tag 'hix5hd2-config-for-3.19' of git://github.com/hisilicon/linux-hisi into next/defconfig
      Merge tag 'mvebu-defconfig-3.19' of git://git.infradead.org/linux-mvebu into next/defconfig
      Merge tag 'keystone-soc' of git://git.kernel.org/.../ssantosh/linux-keystone into next/defconfig
      Merge tag 'sti-defconfig-for-v3.19-1' of git://git.stlinux.com/devel/kernel/linux-sti into next/defconfig
      Merge tag 'mvebu-defconfig-3.19-2' of git://git.infradead.org/linux-mvebu into next/defconfig
      Merge tag 'tegra-for-3.19-defconfig' of git://git.kernel.org/.../tegra/linux into next/defconfig
      Merge tag 'at91-defconfig' of git://git.kernel.org/.../nferre/linux-at91 into next/defconfig

Dmitry Lavnikevich (1):
      ARM: defconfig: imx_v6_v7_defconfig updates

Felipe Balbi (5):
      ARM: omap2plus_defconfig: remove unwanted ethernet drivers
      ARM: omap2plus_defconfig: enable EDT FT5X06 touchscreen
      ARM: omap2plus_defconfig: enable AM33XX SoC sound
      ARM: omap2plus_defconfig: enable XHCI
      ARM: omap2plus_defconfig: enable ECAP and EHRPWM

Grygorii Strashko (2):
      ARM: keystone_defconfig: enable dsp irq and gpio support
      ARM: keystone_defconfig: enable mdio and marvell eth phys

Krzysztof Kozlowski (1):
      ARM: exynos_defconfig: Use 16 minors per MMC block device

Kuninori Morimoto (3):
      ARM: shmobile: multiplatform: add R-Car DMAC support on defconfig
      ARM: shmobile: multiplatform: add Audo DMAC peri peri support on defconfig
      ARM: shmobile: multiplatform: add AK4642 support on defconfig

Ludovic Desroches (1):
      ARM: at91: sama5: update defconfig

Marcin Wojtas (2):
      ARM: mvebu: re-enable SDHCI driver for Armada 38x SoC in v7 defconfig
      ARM: mvebu: enable i2c device in mvebu_v7_defconfig

Murali Karicheri (2):
      ARM: keystone: add pcie related options
      ARM: keystone: defconfig: add options to enable PCI controller

Nicolas Ferre (4):
      ARM: at91/defconfig: add the XDMA driver
      ARM: at91/defconfig: add TCB PWM driver selection
      ARM: at91/defconfig: add QT1070 to at91_dt
      ARM: at91/defconfig: add DM9000 to at91_dt

Peter Griffin (2):
      ARM: multi_v7_defconfig: Enable st ohci and ehci HCD drivers.
      ARM: multi_v7_defconfig: Enable stih415/6 usb2 phy driver.

Ray Jui (1):
      ARM: multi_v7_defconfig: Enable Broadcom Cygnus

Scott Branden (1):
      ARM: multi_v7_defconfig: remove one level of menu from Kconfig

Simon Horman (1):
      ARM: shmobile: ape6evm: Enable PM Runtime in defconfig

Soren Brinkmann (1):
      ARM: multi_v7_defconfig: Enable cgroups

Thierry Reding (1):
      ARM: tegra: Regenerate default configuration

Thomas Petazzoni (2):
      ARM: mvebu: update mvebu_v7_defconfig for Armada 370 audio
      ARM: mvebu: add MTD_BLOCK to mvebu_v7_defconfig

Tyler Baker (1):
      ARM: multi_v7_defconfig: enable MAX77686 PMIC drivers for exynos4412-prime based SoCs

Zhangfei Gao (2):
      ARM: hisi_defconfig: add driver support for hix5hd2
      ARM: multi_v7_defconfig: add driver support for hix5hd2

 arch/arm/configs/ape6evm_defconfig   |  1 +
 arch/arm/configs/at91_dt_defconfig   |  3 +++
 arch/arm/configs/exynos_defconfig    |  1 +
 arch/arm/configs/hisi_defconfig      | 19 +++++++++++++++++++
 arch/arm/configs/imx_v6_v7_defconfig | 10 +++++++++-
 arch/arm/configs/keystone_defconfig  |  7 +++++++
 arch/arm/configs/multi_v5_defconfig  |  2 ++
 arch/arm/configs/multi_v7_defconfig  | 36 +++++++++++++++++++++++++++++++++++-
 arch/arm/configs/mvebu_v5_defconfig  |  2 ++
 arch/arm/configs/mvebu_v7_defconfig  |  9 ++++++++-
 arch/arm/configs/omap2plus_defconfig | 22 ++++++++++++++++++++++
 arch/arm/configs/sama5_defconfig     |  6 +++++-
 arch/arm/configs/shmobile_defconfig  |  3 +++
 arch/arm/configs/tegra_defconfig     |  2 --
 arch/arm/mach-keystone/Kconfig       |  2 ++
 15 files changed, 119 insertions(+), 6 deletions(-)

