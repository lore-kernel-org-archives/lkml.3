Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974Ab3CYVne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 17:43:34 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8648 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758665Ab3CYVnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 17:43:33 -0400
X-IronPort-AV: E=Sophos;i="4.84,907,1355126400"; 
   d="scan'208";a="32368113"
To: arm@kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [GIT PULL] msm fix for 3.9 -- timer
From: David Brown <davidb@codeaurora.org>
Date: Mon, 25 Mar 2013 14:43:32 -0700
Message-ID: <8ya8v5b88aj.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f6161aa153581da4a3867a2d1a7caf4be19b6ec9:

  Linux 3.9-rc2 (2013-03-10 16:54:19 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git tags/msm-fix-3.9

for you to fetch changes up to 4080d2d11a2d572228c2b8d02406e997b87ba6a5:

  ARM: msm: Stop counting before reprogramming clockevent (2013-03-22 10:45:39 -0700)

----------------------------------------------------------------
This fix is intended for v3.9.  It fixes a timer bug on MSM targets
that cause system hangs.

----------------------------------------------------------------
Stephen Boyd (1):
      ARM: msm: Stop counting before reprogramming clockevent

 arch/arm/mach-msm/timer.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
