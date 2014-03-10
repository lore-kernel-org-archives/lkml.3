Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbaCJScj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 14:32:39 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:40952 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbaCJScg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 14:32:36 -0400
Message-ID: <531E0542.7020701@linaro.org>
Date: Mon, 10 Mar 2014 11:32:34 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Greg Hackmann <ghackmann@google.com>,
        Rashika Kheria <rashika.kheria@gmail.com>
Subject: [GIT PULL] Timekeeping changes for 3.15
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas, Ingo,

 My queue is pretty short (and small) for 3.15, but I wanted to send it
along for tip/timers/core.

Let me know if you have any feedback or objections.

thanks
-john


The following changes since commit 03d11a0e458d7008192585124e4c3313c2829046:

  Merge tag 'for-v3.14' of git://git.infradead.org/battery-2.6
(2014-01-21 11:36:20 -0800)

are available in the git repository at:


  git://git.linaro.org/people/john.stultz/linux.git fortglx/3.15/time

for you to fetch changes up to 64e8d20bd39b81994d9cd60e7b42f8ec8652f5af:

  kernel: Include appropriate header file in time/timekeeping_debug.c
(2014-03-02 20:52:58 -0800)

----------------------------------------------------------------
Greg Hackmann (1):
      timerfd: support CLOCK_BOOTTIME clock

Rashika Kheria (1):
      kernel: Include appropriate header file in time/timekeeping_debug.c

 fs/timerfd.c                    | 1 +
 kernel/time/timekeeping_debug.c | 2 ++
 2 files changed, 3 insertions(+)

