Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab3DLWnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 18:43:47 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45914 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737Ab3DLWnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 18:43:45 -0400
X-IronPort-AV: E=Sophos;i="4.87,465,1363158000"; 
   d="scan'208";a="38032762"
To: arm@kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] msm fixes for 3.10
In-Reply-To: <8ya7gk7qsnp.fsf@huya.qualcomm.com>
From: David Brown <davidb@codeaurora.org>
Date: Fri, 12 Apr 2013 15:43:44 -0700
Message-ID: <8yar4ifpdy7.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f6161aa153581da4a3867a2d1a7caf4be19b6ec9:

  Linux 3.9-rc2 (2013-03-10 16:54:19 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git tags/msm-fix-3.10

for you to fetch changes up to 73a8c28f167c9e7bc42eafc0bcbd298031709430:

  ARM: msm: Fix uncompess.h tx underrun check (2013-04-11 09:40:35 -0700)

----------------------------------------------------------------
Some minor fixes for MSM for 3.10

  - Fix a timer problem that causes missed ticks and hangs.

  - Fix a problem with the decompressor UART dropping characters.

----------------------------------------------------------------
Stephen Boyd (2):
      ARM: msm: Stop counting before reprogramming clockevent
      ARM: msm: Fix uncompess.h tx underrun check

 arch/arm/mach-msm/include/mach/uncompress.h | 2 +-
 arch/arm/mach-msm/timer.c                   | 5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
