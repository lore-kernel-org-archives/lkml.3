Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbaBQSpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 13:45:43 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:42920 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbaBQSpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 13:45:41 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Will Deacon <will.deacon@arm.com>,
        Josh Cartwright <joshc@codeaurora.org>
Subject: [PATCH] Generic sched_clock locking fix for tip/timers/urgent
Date: Mon, 17 Feb 2014 10:45:35 -0800
Message-Id: <1392662736-7803-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Ingo, Thomas,
	Wanted to send along this sched_clock fix from Stephen for
tip/timers/urgent. Let me know if you have any issues or concerns.

thanks
-john


Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Josh Cartwright <joshc@codeaurora.org>

Stephen Boyd (1):
  sched_clock: Prevent callers from seeing half-updated data

 kernel/time/sched_clock.c | 46 +++++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 17 deletions(-)

-- 
1.8.3.2

