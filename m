Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbbABTvQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 14:51:16 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43224 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbbABTvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 14:51:14 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 0/2] time: tip/timers/urgent: Validate potential mult overflows
Date: Fri,  2 Jan 2015 11:51:06 -0800
Message-Id: <1420228268-2161-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Ingo, Thomas,

 Here are two mult overflow validation fixes from Sasha for
tip/timers/urgent that I didn't manage to send out before the holidays.

Let me know if you have any objections.

thanks
-john

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>

If you want they can be pulled via:

The following changes since commit b2776bf7149bddd1f4161f14f79520f17fc1d71d:

  Linux 3.18 (2014-12-07 14:21:05 -0800)

are available in the git repository at:

  https://git.linaro.org/people/john.stultz/linux.git fortglx/3.19-stable/time

for you to fetch changes up to ac1e640cd8d3f5baf48103fdbf794788034bf50c:

  time: adjtimex: Validate the ADJ_FREQUENCY values (2014-12-19 12:07:10 -0800)

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

