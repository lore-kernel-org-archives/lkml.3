Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbaJHUe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 16:34:56 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:53096 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbaJHUey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 16:34:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: torvalds@linux-foundation.org
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL 0/7] ARM: SoC defconfig changes for 3.18
Date: Wed, 08 Oct 2014 22:34:27 +0200
Message-ID: <2823136.Sj5FxECIHU@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1922034.HH2lvbiFi0@wuerfel>
References: <1922034.HH2lvbiFi0@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:WJIRVUZHY+AFhSnUI/Gfh0PrW/cs2HZMwE7CR3aM0QK
 o4b/hYRbRQqz1k1SYY6jeNDZra2kw6TuR3U7Sgl9tYyuqKyAjn
 0xqv9teb7bcOKhgcMokHWzSX+W4FJb4GhDPDLG9JvqKjN1STyZ
 ZW5u6j1A4Rs0DFLWhNafWT3kCdHiI53NbMhVK+ceCdQJUVk0b+
 rYL97s8VfGhDYvcRCMnc0f0xwossV+g60Cw5EiqhtHBv/PZtnm
 85L4FUFMbpURa2/z2DAggiQfpjXRFiBRTCnZ+5etjKUpDpbulD
 3ox9miBuTzhNXgTr6gN/svE7rxDOGX/yr0DGNvthZsdEMyZjES
 uGzq6hsQIKxARk23sxwU=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 52addcf9d6669fa439387610bc65c92fa0980cef:

  Linux 3.17-rc2 (2014-08-25 15:36:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/defconfig-for-linus

for you to fetch changes up to a41988a050c0d77f8100ccc576d413a28797fa79:

  Merge tag 'qcom-defconfig-for-3.18' of git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom into next/defconfig (2014-10-01 16:37:33 +0200)

----------------------------------------------------------------
ARM: SoC defconfig changes for 3.18

This is a collection of the various changes to defconfig files,
most importantly enabling some additional platforms in the
multi_v7_defconfig file.

----------------------------------------------------------------
Alexandre Belloni (7):
      ARM: at91: at91_dt: update defconfig
      ARM: at91: at91sam9260_9g20: update defconfig
      ARM: at91: at91sam9261_9g10: update defconfig
      ARM: at91: at91sam9263: update defconfig
      ARM: at91: at91sam9g45: update defconfig
      ARM: at91: at91sam9rl: update defconfig
      ARM: at91: sama5: update defconfig

Arnd Bergmann (8):
      Merge tag 'renesas-defconfig3-for-v3.18' of git://git.kernel.org/.../horms/renesas into next/defconfig
      Merge tag 'at91-defconfig' of git://github.com/at91linux/linux-at91 into next/defconfig
      Merge branch 'lpc32xx/defconfig' of git://git.antcom.de/linux-2.6 into next/defconfig
      Merge tag 'tegra-for-3.18-defconfig' of git://git.kernel.org/.../swarren/linux-tegra into next/defconfig
      Merge tag 'sunxi-defconfig-for-3.18' of git://git.kernel.org/.../mripard/linux into next/defconfig
      Merge branch 'next/defconfig' of git+ssh://ra.kernel.org/.../arm/arm-soc into next/defconfig
      ARM: configs: fix duplicate entry in multi_v7
      Merge tag 'qcom-defconfig-for-3.18' of git://git.kernel.org/.../galak/linux-qcom into next/defconfig

Bo Shen (2):
      ARM: at91/at91_dt_defconfig: enable sound support
      ARM: at91/sama5_defconfig: enable sound support

Brian Norris (1):
      ARM: at91: add MTD_SPI_NOR (new dependency for M25P80)

Carlo Caione (1):
      ARM: meson: update multi_v7_defconfig

Chen-Yu Tsai (2):
      ARM: sunxi: Add A31 RTC driver to sunxi_defconfig
      ARM: sunxi: Add A31 RTC driver to multi_v7_defconfig

Geert Uytterhoeven (8):
      ARM: shmobile: shmobile_defconfig: Enable missing hardware support
      ARM: shmobile: ape6evm_defconfig: Enable missing hardware support
      ARM: shmobile: bockw_defconfig: Enable missing hardware support
      ARM: shmobile: koelsch_defconfig: Enable missing hardware support
      ARM: shmobile: kzm9g_defconfig: Enable missing hardware support
      ARM: shmobile: lager_defconfig: Enable missing hardware support
      ARM: shmobile: marzen_defconfig: Enable missing hardware support
      ARM: shmobile: Enable Armadillo 800 EVA board in multiplatform defconfig

Kevin Hilman (1):
      ARM: shmobile: defconfig: enable initrd

Kumar Gala (2):
      ARM: qcom: Update defconfig
      ARM: qcom: Update defconfig

Lubomir Rintel (1):
      ARM: bcm2835: enable USB_DWC2_HOST in defconfig

Luc Verhaegen (1):
      ARM: sunxi_defconfig: add NLS_CODEPAGE_437 and NLS_ISO8859_1

Mark Brown (2):
      ARM: configs: Remove REGULATOR_VIRTUAL_CONSUMER from defconfigs
      ARM: configs: Enable cpufreq-cpu0 for multi_v7_defconfig

Matthias Brugger (1):
      ARM: multi_v7_defconfig: Enable Mediatek platform

Mikko Perttunen (1):
      ARM: tegra: Add options for Tegra AHCI support to tegra_defconfig

Olof Johansson (3):
      ARM: mvebu: update v7 defconfig with useful options
      Merge tag 'mvebu-defconfig-3.18' of git://git.infradead.org/linux-mvebu into next/defconfig
      Merge tag 'renesas-defconfig4-for-v3.18' of git://git.kernel.org/.../horms/renesas into next/defconfig

Roland Stigge (1):
      ARM: LPC32xx: defconfig update

Simon Horman (2):
      ARM: shmobile: bockw: Do not disable SUSPEND in defconfig
      ARM: shmobile: Enable r8a7794 SoC in shmobile_defconfig

Soren Brinkmann (1):
      ARM: multi_v7_defconfig: Enable Zynq/Xilinx drivers

Stephen Warren (2):
      ARM: tegra: enable Atmel touchpad in defconfig
      ARM: multi_v7_defconfig: add missing Tegra options

Thomas Petazzoni (2):
      ARM: mvebu: add LED class support built-in in mvebu_v7_defconfig
      ARM: mvebu: add gpio-fan to mvebu_v7_defconfig

 arch/arm/configs/ape6evm_defconfig          |  9 +++-
 arch/arm/configs/at91_dt_defconfig          | 35 ++++++++++-----
 arch/arm/configs/at91sam9260_9g20_defconfig | 13 +++---
 arch/arm/configs/at91sam9261_9g10_defconfig |  5 +--
 arch/arm/configs/at91sam9263_defconfig      | 13 +++---
 arch/arm/configs/at91sam9g45_defconfig      | 19 ++++----
 arch/arm/configs/at91sam9rl_defconfig       | 19 +++++---
 arch/arm/configs/bcm2835_defconfig          |  1 +
 arch/arm/configs/bcm_defconfig              |  1 -
 arch/arm/configs/bockw_defconfig            |  3 +-
 arch/arm/configs/ezx_defconfig              |  1 -
 arch/arm/configs/imote2_defconfig           |  1 -
 arch/arm/configs/koelsch_defconfig          | 17 ++++++++
 arch/arm/configs/kzm9g_defconfig            |  1 +
 arch/arm/configs/lager_defconfig            |  8 +++-
 arch/arm/configs/lpc32xx_defconfig          |  2 +
 arch/arm/configs/marzen_defconfig           |  1 +
 arch/arm/configs/multi_v7_defconfig         | 39 ++++++++++++++++-
 arch/arm/configs/mvebu_v7_defconfig         | 68 ++++++++++++++---------------
 arch/arm/configs/pxa3xx_defconfig           |  1 -
 arch/arm/configs/qcom_defconfig             | 14 ++++--
 arch/arm/configs/sama5_defconfig            | 18 +++++---
 arch/arm/configs/shmobile_defconfig         | 16 +++++++
 arch/arm/configs/sunxi_defconfig            |  4 +-
 arch/arm/configs/tegra_defconfig            |  5 ++-
 25 files changed, 216 insertions(+), 98 deletions(-)

