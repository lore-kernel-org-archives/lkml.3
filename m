Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab3KOXsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 18:48:45 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:43441 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab3KOXsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 18:48:38 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, Stuart Menefy <stuart.menefy@st.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <monstr@monstr.eu>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: [PATCH 0/4] Convert setup_sched_clock() users in drivers/clocksource
Date: Fri, 15 Nov 2013 15:48:31 -0800
Message-Id: <1384559315-18699-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel,

These patches convert the remaining few users in drivers/clocksource
to the new sched_clock_register() API. These were new drivers to
this directory after I sent out the sched_clock conversion patches
a few months back. Patches are based on Linus' tip, compile tested only.

Cc: Stuart Menefy <stuart.menefy@st.com>
Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
Cc: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Stephen Boyd (4):
  clocksource: arm_global_timer: Switch to sched_clock_register()
  clocksource: cadence_ttc_timer: Switch to sched_clock_register()
  clocksource: sun4i: Switch to sched_clock_register()
  clocksource: orion: Switch to sched_clock_register()

 drivers/clocksource/arm_global_timer.c  | 4 ++--
 drivers/clocksource/cadence_ttc_timer.c | 4 ++--
 drivers/clocksource/sun4i_timer.c       | 4 ++--
 drivers/clocksource/time-orion.c        | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

