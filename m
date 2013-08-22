Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab3HVVL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 17:11:27 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:44438 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505Ab3HVVL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 17:11:26 -0400
Message-ID: <52167E7B.7060606@linaro.org>
Date: Thu, 22 Aug 2013 14:11:23 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Timekeeping changes for 3.12
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
    Just wanted to send you my fortglx/3.12/time branch for tip/timers/core.

There's also the fortglx/3.12/sched-clock64-base branch, which I sent
you an earlier pull request, but haven't seen anything on.

Let me know if you have any objections or comments.

thanks
-john



The following changes since commit 07862c1cd6675cde2dd4bd64e64d704ea2185b79:

  ARM: clocksource: Add support for MOXA ART SoCs (2013-07-18 15:27:47
+0200)

are available in the git repository at:

  git://git.linaro.org/people/jstultz/linux.git fortglx/3.12/time

for you to fetch changes up to a97ad0c4b447a132a322cedc3a5f7fa4cab4b304:

  ntp: Make periodic RTC update more reliable (2013-08-22 12:33:38 -0700)

----------------------------------------------------------------
Miroslav Lichvar (1):
      ntp: Make periodic RTC update more reliable

Prarit Bhargava (1):
      clocksource: Fix !CONFIG_CLOCKSOURCE_WATCHDOG compile

Zoran Markovic (1):
      rtc: Keep system awake until all expired RTC timers are handled

 drivers/rtc/interface.c   | 13 +++++++++----
 kernel/time/clocksource.c |  1 +
 kernel/time/ntp.c         |  3 ++-
 3 files changed, 12 insertions(+), 5 deletions(-)
