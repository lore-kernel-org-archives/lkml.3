Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab3JVXIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 19:08:16 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:48934 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087Ab3JVXIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 19:08:15 -0400
Message-ID: <5267055C.6000609@linaro.org>
Date: Tue, 22 Oct 2013 16:08:12 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] tip/timers/core: Hopefully last few timekeeping changes
 for 3.13
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas, Ingo,
    Here are a few last timekeeping changes I've got queued for 3.13,
for tip/timers/core.

This includes:

* An improved ssize_t fix for sysfs_get_uname

* Alarmtimer return fix, since ENOTSUPP isn't exported to userland

* Comment typo fixes

Let me know if you have any thoughts or concerns!

thanks
-john



The following changes since commit 4a7d3e8a9939cf8073c247286d81cbe0ae48eba2:

  clocksource: arch_timer: Do not register arch_sys_counter twice
(2013-10-16 08:30:03 +0200)

are available in the git repository at:

  git://git.linaro.org/people/jstultz/linux.git fortglx/3.13/time

for you to fetch changes up to 891292a767c2453af0e5be9465e95b06b4b29ebe:

  time: Fix signedness bug in sysfs_get_uname() and its callers
(2013-10-18 16:45:58 -0700)

----------------------------------------------------------------
KOSAKI Motohiro (1):
      alarmtimer: return EINVAL instead of ENOTSUPP if rtcdev doesn't exist

Patrick Palka (1):
      time: Fix signedness bug in sysfs_get_uname() and its callers

Xie XiuQi (1):
      timekeeping: Fix some trivial typos in comments

 kernel/time/alarmtimer.c    | 4 ++--
 kernel/time/clockevents.c   | 2 +-
 kernel/time/clocksource.c   | 2 +-
 kernel/time/tick-internal.h | 2 +-
 kernel/time/timekeeping.c   | 3 ++-
 5 files changed, 7 insertions(+), 6 deletions(-)
