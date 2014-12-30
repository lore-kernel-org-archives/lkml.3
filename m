Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607AbaL3QAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 11:00:22 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:49378 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbaL3QAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 11:00:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, catalin.marinas@arm.com,
        Mark Rutland <mark.rutland@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: ARM: SoC fixes for 3.19-rc3
Date: Tue, 30 Dec 2014 16:58:25 +0100
Message-ID: <5148069.JqHzJYRvtB@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:19R40DfBRg7sQznKZhftzex+XG5MEX1bAO+GATqvm/kr1t7yGM9
 vCDmXW36qiFGPS8rDEOAHtYy4uQXH8NhAXe2uDhGFTlB8mcXZixgBcUPRGqFrdOPz6LXoRf
 ECB0CyyZfDxGm/92oCuJOwlBZdADMWLluzYJJC2ZfQ79yRkCqAdmFm1YSg2QYXym2SSIMQ0
 zIJcj2CTbBHdHOv8HaP1w==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a few more known problems waiting for fixes, and there isn't much
in here, but arm64 is currently broken because of one missing patch, so
I'm sending this to flush our current patch queue while we're waiting
for other patches to come in, now that people start getting back to work.

	Arnd

---
The following changes since commit 97bf6af1f928216fd6c5a66e8a57bfa95a659672:

  Linux 3.19-rc1 (2014-12-20 17:08:50 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to 007487f1fd43d84f26cda926081ca219a24ecbc4:

  Add USB_EHCI_EXYNOS to multi_v7_defconfig (2014-12-30 16:03:53 +0100)

----------------------------------------------------------------
ARM: SoC fixes for 3.19-rc3

A very small set of fixes for 3.19, as everyone was out. The clocksource
patch was something I missed for the merge window after the change that
broke arm64 was merged through arm-soc. The other two patches are
a fix for an undetected merge problem in mvebu and a defconfig change
to make some exynos boards work with the normal multi_v7_defconfig.

----------------------------------------------------------------
Arnd Bergmann (1):
      Merge tag 'mvebu-fixes-3.19' of git://git.infradead.org/linux-mvebu into fixes

Catalin Marinas (1):
      clocksource: arch_timer: Only use the virtual counter (CNTVCT) on arm64

Gregory CLEMENT (1):
      ARM: mvebu: Fix pinctrl configuration for Armada 370 DB

Steev Klimaszewski (1):
      Add USB_EHCI_EXYNOS to multi_v7_defconfig

 arch/arm/boot/dts/armada-370-db.dts  | 24 ------------------------
 arch/arm/configs/multi_v7_defconfig  |  1 +
 drivers/clocksource/arm_arch_timer.c |  2 +-
 3 files changed, 2 insertions(+), 25 deletions(-)

