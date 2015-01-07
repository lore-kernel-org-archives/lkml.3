Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbbAGSMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 13:12:40 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:61753 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350AbbAGSMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 13:12:38 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sasha.levin@oracle.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 0/2] time: tip/timers/urgent: Validate potential mult overflows
Date: Wed,  7 Jan 2015 10:12:18 -0800
Message-Id: <1420654340-3009-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Ingo, Thomas,

 Here are two mult overflow validation fixes from Sasha for
tip/timers/urgent that I didn't manage to send out before the holidays.

For v2 I've added the mili->micro fix Andy noticed.

Let me know if you have any objections.

thanks
-john

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Andy Lutomirski <luto@amacapital.net>

If you want, they can be pulled via:

The following changes since commit b2776bf7149bddd1f4161f14f79520f17fc1d71d:

  Linux 3.18 (2014-12-07 14:21:05 -0800)

are available in the git repository at:

  https://git.linaro.org/people/john.stultz/linux.git fortglx/3.19-stable/time

for you to fetch changes up to 5e5aeb4367b450a28f447f6d5ab57d8f2ab16a5f:

  time: adjtimex: Validate the ADJ_FREQUENCY values (2015-01-07 09:50:32 -0800)

----------------------------------------------------------------
Sasha Levin (2):
      time: settimeofday: Validate the values of tv from user
      time: adjtimex: Validate the ADJ_FREQUENCY values

 include/linux/time.h | 13 +++++++++++++
 kernel/time/ntp.c    |  7 +++++++
 kernel/time/time.c   |  4 ++++
 3 files changed, 24 insertions(+)

-- 
1.9.1

