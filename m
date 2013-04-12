Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab3DLWko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 18:40:44 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17590 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab3DLWkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 18:40:43 -0400
X-IronPort-AV: E=Sophos;i="4.87,465,1363158000"; 
   d="scan'208";a="38032330"
To: arm@kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] msm cleanup for 3.10
From: David Brown <davidb@codeaurora.org>
Date: Fri, 12 Apr 2013 15:40:42 -0700
Message-ID: <8ya7gk7qsnp.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6dbe51c251a327e012439c4772097a13df43c5b8:

  Linux 3.9-rc1 (2013-03-03 15:11:05 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git tags/msm-cleanup-3.10

for you to fetch changes up to 641f71699ec96fb742cc891b9ea4f3a46c60050e:

  ARM: msm: Remove unused cpu.h header file (2013-03-05 12:05:43 -0800)

----------------------------------------------------------------
Cleanups for MSM for 3.10

These are some patches for various parts of MSM that gradually bring
us closer to being part of single zimage.

----------------------------------------------------------------
Stephen Boyd (4):
      ARM: msm: Move dma.h #defines that are private to dma.c
      mmc: msm_sdcc: Remove unnecessary include
      gpio: Make gpio-msm-v1 into a platform driver
      ARM: msm: Remove unused cpu.h header file

 arch/arm/mach-msm/board-halibut.c    |   1 +
 arch/arm/mach-msm/board-msm7x30.c    |   1 +
 arch/arm/mach-msm/board-qsd8x50.c    |   1 +
 arch/arm/mach-msm/board-trout.c      |   1 +
 arch/arm/mach-msm/devices-msm7x00.c  |  31 +++++
 arch/arm/mach-msm/devices-msm7x30.c  |  31 +++++
 arch/arm/mach-msm/devices-qsd8x50.c  |  31 +++++
 arch/arm/mach-msm/devices.h          |   4 +
 arch/arm/mach-msm/dma.c              |  26 +++++
 arch/arm/mach-msm/include/mach/cpu.h |  54 ---------
 arch/arm/mach-msm/include/mach/dma.h |  26 -----
 drivers/gpio/gpio-msm-v1.c           | 220 ++++++++++++++++++++++++-----------
 drivers/mmc/host/msm_sdcc.c          |   1 -
 13 files changed, 276 insertions(+), 152 deletions(-)
 delete mode 100644 arch/arm/mach-msm/include/mach/cpu.h

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
