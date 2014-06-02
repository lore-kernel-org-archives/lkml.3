Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbaFBViN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 17:38:13 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:58731 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbaFBViI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 17:38:08 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 5/7] ARM: SoC defconfig updates for 3.16
Date: Mon,  2 Jun 2014 14:04:08 -0700
Message-Id: <1401743050-7379-6-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401743050-7379-1-git-send-email-olof@lixom.net>
References: <1401743050-7379-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A number of defconfig updates for 3.16. We have quite a few of these as
new SoCs and drivers get supported, and we've started collecting them
in one shared branch.

We started halfway through the merge window so there'll be some small
conflicts with other branches on nearby changes, but nothing major. Next
cycle should be smoother.


Conflicts:

arch/arm/configs/multi_v7_defconfig:
	Messed up ordering when resolving a conflict before. Remove the HEAD
	version. We'll regenerate this defconfig right around -rc1 anyway, so
	it might re-sort a bit then.

----------------------------------------------------------------

The following changes since commit 24121ba2f9203bf583444359b20e0c05210f0ea3:

  Merge tag 'boards-for-3.16' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/defconfig-for-3.16

for you to fetch changes up to c6ac44878d9a254f2bad2d2150c88de83c231ddf:

  ARM: multi_v7_defconfig: Enable Exynos platform

----------------------------------------------------------------

Arnd Bergmann (4):
      Merge tag 'mvebu-defconfig-3.16-2' of git://git.infradead.org/linux-mvebu into next/defconfig
      Merge tag 'sunxi-defconfig-for-3.16-2' of https://github.com/mripard/linux into next/defconfig
      Merge tag 'qcom-defconfig-for-3.16' of git://git.kernel.org/.../galak/linux-qcom into next/defconfig
      Merge prior defconfig changes into next/defconfig

Gregory CLEMENT (2):
      ARM: configs: enable XHCI mvebu support in mvebu_v7_defconfig
      ARM: configs: enable XHCI mvebu support in multi_v7_defconfig

Kumar Gala (1):
      ARM: qcom: Enable GSBI driver in defconfig

Maxime Ripard (3):
      ARM: sunxi: Add A31 reset driver to sunxi_defconfig
      ARM: multi_v7: Add Allwinner reset drivers to multi_v7_defconfig
      ARM: configs: update Allwinner options

Olof Johansson (2):
      Merge tag 'v3.15-rc6' into next/defconfig
      Merge tag 'qcom-defconfig-for-3.16-2' of git://git.kernel.org/.../galak/linux-qcom into next/defconfig

Sachin Kamat (1):
      ARM: multi_v7_defconfig: Enable Exynos platform

Soren Brinkmann (1):
      ARM: multi_v7_defconfig: Enable Zynq peripheral drivers

Stefan Agner (1):
      ARM: add drivers for Colibri T30 to multi_v7_defconfig

Stephen Boyd (2):
      ARM: config: Add qcom_defconfig
      ARM: config: Update msm_defconfig

Thomas Petazzoni (2):
      ARM: mvebu: enable MSI support in mvebu_v7_defconfig
      ARM: configs: add CONFIG_MMC_SDHCI_PXAV3 to the multi_v7_defconfig

Wenyou Yang (1):
      ARM: at91/defconfig: sama5_defconfig: updated


 arch/arm/configs/msm_defconfig      |  25 +----
 arch/arm/configs/multi_v7_defconfig |  39 ++++++--
 arch/arm/configs/mvebu_v7_defconfig |   2 +
 arch/arm/configs/qcom_defconfig     | 165 +++++++++++++++++++++++++++++++
 arch/arm/configs/sama5_defconfig    |   2 +
 arch/arm/configs/sunxi_defconfig    |  43 +++++++-
 6 files changed, 245 insertions(+), 31 deletions(-)
 create mode 100644 arch/arm/configs/qcom_defconfig
