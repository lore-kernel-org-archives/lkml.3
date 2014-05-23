Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203AbaEWX5G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 19:57:06 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:38955 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbaEWX5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 19:57:04 -0400
Message-ID: <537FE04D.7080106@linaro.org>
Date: Fri, 23 May 2014 16:57:01 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Fabian Frederick <fabf@skynet.be>,
        George Spelvin <linux@horizon.com>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [GIT PULL] Timekeeping items for 3.16
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas, Ingo,
  Just wanted to send in my 3.16 queue so it can get some time in -next.
Nothing particularly exciting, just a few cleanups.

Let me know if you have any objections or comments.

thanks
-john



The following changes since commit 4d0fa8a0f01272d4de33704f20303dcecdb55df1:

  Merge tag 'gpio-v3.15-2' of
git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio
(2014-04-22 09:28:02 -0700)

are available in the git repository at:


  git://git.linaro.org/people/john.stultz/linux.git fortglx/3.16/time

for you to fetch changes up to ea54bca3aab3468daf1c37d15047ee66bca8760d:

  ntp: Make is_error_status() use its argument (2014-05-12 11:01:08 -0700)

----------------------------------------------------------------
Fabian Frederick (1):
      ntp: Convert simple_strtol to kstrtol

George Spelvin (1):
      ntp: Make is_error_status() use its argument

Stephen Boyd (1):
      sched_clock: Remove deprecated setup_sched_clock() API

 include/linux/sched_clock.h |  1 -
 kernel/time/ntp.c           | 17 ++++++++++-------
 kernel/time/sched_clock.c   | 13 -------------
 3 files changed, 10 insertions(+), 21 deletions(-)

