Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab3CYNc3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 09:32:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50007 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757941Ab3CYNc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 09:32:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] arm-soc: bug fixes for 3.9-rc4
Date: Mon, 25 Mar 2013 13:32:13 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303251332.13859.arnd@arndb.de>
X-Provags-ID: V02:K0:FnyFvtdY3NA98fBDuNTWe/xMAzL+juu+LZjtsTAKICV
 m2HL+i8SjPRVcf2Bsi3SRlrDxB2I5TuRh9CmrVv+rHT21nOa8h
 OfI84EL6qLzJjIP6D4g2RLeo9x+wGslkrLaVaYS27eALTHveos
 XuKpfluQ/Ve6fzRc8yjDol6gzHoFCvvUhIAtqDXReacigvTtGJ
 h+SwB0cheuF1PXJu9nWDunaSPZOIjhuFENLfHO3gGUFechg/wa
 vq0kg8uKXijiu++jzJMYdNI4t3dtgdy0aUOPf93ECejm93+QxV
 lLLIdxTvSct2OpFdnOYGYTIjN18foYx0OpSCIqfBCS7rd6Y1vP
 kdp6jXjuqhzLnkhLIk9I=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit a937536b868b8369b98967929045f1df54234323:

  Linux 3.9-rc3 (2013-03-17 15:59:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes

for you to fetch changes up to c69d72aec52eb5234f433259ac5dcc3b68f1480d:

  MAINTAINERS: update email address for Kevin Hilman (2013-03-22 21:57:15 +0100)

----------------------------------------------------------------
Four patches for arm-soc this week:
- Kevin Hilman is no longer reachable under his previous email address.
  He submitted the patch earlier, but nobody felt responsible to pick
  it up.

- One Tegra fix for an incorect register address in device tree.

- IMX multiplatform support exposes a configuration option that
  leads to unbootable kernels on all other machines and that needs
  to depend on that platform.

- A nontrivial bug fix for the setup of the mxs video output.

----------------------------------------------------------------
Arnd Bergmann (2):
      Merge tag 'mxs-fixes-3.9-3' of git://git.linaro.org/people/shawnguo/linux-2.6 into fixes
      Merge tag 'imx-fixes-3.9-3' of git://git.linaro.org/people/shawnguo/linux-2.6 into fixes

Kevin Hilman (1):
      MAINTAINERS: update email address for Kevin Hilman

Laxman Dewangan (1):
      ARM: tegra: fix register address of slink controller

Marek Vasut (1):
      ARM: video: mxs: Fix mxsfb misconfiguring VDCTRL0

Shawn Guo (1):
      ARM: imx: add dependency check for DEBUG_IMX_UART_PORT

 MAINTAINERS                    |  6 +++---
 arch/arm/Kconfig.debug         |  1 +
 arch/arm/boot/dts/tegra20.dtsi |  2 +-
 arch/arm/boot/dts/tegra30.dtsi |  2 +-
 arch/arm/mach-mxs/mach-mxs.c   | 24 ++++++++++++------------
 drivers/video/mxsfb.c          |  7 +++++--
 include/linux/mxsfb.h          |  7 +++++--
 7 files changed, 28 insertions(+), 21 deletions(-)
