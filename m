Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479Ab3FXWyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 18:54:44 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35617 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab3FXWym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 18:54:42 -0400
Message-ID: <51C8CE2F.1050008@linaro.org>
Date: Mon, 24 Jun 2013 15:54:39 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Stephen Boyd <sboyd@codeaurora.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Timekeeping fixup for 3.11 (tip/timers/core)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
     Got one small fix for 3.11 for tip/timers/core. This works around a 
collision with changes in the arm-soc tree that is causing build 
failures, allowing for a smoother transition to the generic sched_clock 
work.

Let me know if you have any objections.

thanks
-john



The following changes since commit d3d8fee4138a06b4b9ca172d25b8412fc33ad3f3:

   Revert "dw_apb_timer_of.c: Remove parts that were picoxcell-specific" 
(2013-06-18 16:02:04 -0700)

are available in the git repository at:

   git://git.linaro.org/people/jstultz/linux.git fortglx/3.11/time

for you to fetch changes up to 629a6a2b7762a474177d08043bea094dd27e0a54:

   sched_clock: Add temporary asm/sched_clock.h (2013-06-21 10:17:44 -0700)

----------------------------------------------------------------
Stephen Boyd (1):
       sched_clock: Add temporary asm/sched_clock.h

  arch/arm/include/asm/sched_clock.h | 4 ++++
  1 file changed, 4 insertions(+)
  create mode 100644 arch/arm/include/asm/sched_clock.h
