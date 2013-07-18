Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028Ab3GRCj0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 22:39:26 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59029 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab3GRCjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 22:39:24 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: arm@kernel.org, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 0/3] Cleanup sched_clock.h users
Date: Wed, 17 Jul 2013 19:39:18 -0700
Message-Id: <1374115161-675-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.3.754.g9c3c367
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset cleans up the last few stragglers using the sched_clock.h
header file in asm and removes the asm header.

A new one appeared in drivers/clocksource so I'm not sure who
wants to take that one.

Stephen Boyd (3):
  clocksource: orion: Use linux/sched_clock.h
  ARM: clps711x: Use linux/sched_clock.h
  ARM: Remove temporary sched_clock.h header

 arch/arm/include/asm/sched_clock.h | 4 ----
 arch/arm/mach-clps711x/common.c    | 2 +-
 drivers/clocksource/time-orion.c   | 2 +-
 3 files changed, 2 insertions(+), 6 deletions(-)
 delete mode 100644 arch/arm/include/asm/sched_clock.h

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

