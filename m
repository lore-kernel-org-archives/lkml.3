Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab3G2UQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 16:16:54 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:40885 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab3G2UQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 16:16:53 -0400
Message-ID: <51F6CDB1.4070408@linaro.org>
Date: Mon, 29 Jul 2013 13:16:49 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Baruch Siach <baruch@tkos.co.il>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [GIT PULL] Generic sched_clock fix for 3.11
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
     Just one small fix against tip/timers/urgent for 3.11.

thanks
-john


The following changes since commit b0ec636c93ddd77235bf0f023a8a95d78cb6cafe:

   Merge branch 'timers/clockevents' of 
git://git.linaro.org/people/dlezcano/clockevents into timers/urgent 
(2013-07-12 17:10:30 +0200)

are available in the git repository at:


   git://git.linaro.org/people/jstultz/linux.git fortglx/3.11/time

for you to fetch changes up to 53c035204253efe373d9ff166fae6147e8c693b6:

   sched_clock: Fix integer overflow (2013-07-22 16:24:22 -0700)

----------------------------------------------------------------
Baruch Siach (1):
       sched_clock: Fix integer overflow

  kernel/time/sched_clock.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)
