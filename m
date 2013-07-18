Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758967Ab3GRNpN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 09:45:13 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:42823 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab3GRNpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 09:45:11 -0400
Message-ID: <51E7F162.1060804@linaro.org>
Date: Thu, 18 Jul 2013 15:45:06 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [GIT PULL] clocksource/clockevents : sun4i and cadence_ttc cleanups,
 new moxa driver
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 19b0a1e5ac5a7f1dafd5ee2479a5db72b330246b:

  clocksource: orion: Use linux/sched_clock.h (2013-07-17 20:28:00 -0700)

are available in the git repository at:

  git://git.linaro.org/people/dlezcano/clockevents.git
timers/clockevents-next

for you to fetch changes up to 07862c1cd6675cde2dd4bd64e64d704ea2185b79:

  ARM: clocksource: Add support for MOXA ART SoCs (2013-07-18 15:27:47
+0200)

----------------------------------------------------------------
John Stultz (1):
      MAINTAINERS: Add Daniel as maintainer for CLOCKSOURCE and
CLOCKEVENT Drivers

Jonas Jensen (1):
      ARM: clocksource: Add support for MOXA ART SoCs

Maxime Ripard (10):
      clocksource: sun4i: Use the BIT macros where possible
      clocksource: sun4i: Wrap macros arguments in parenthesis
      clocksource: sun4i: rename AUTORELOAD define to RELOAD
      clocksource: sun4i: Add clocksource and sched clock drivers
      clocksource: sun4i: Don't forget to enable the clock we use
      clocksource: sun4i: Fix the next event code
      clocksource: sun4i: Factor out some timer code
      clocksource: sun4i: Remove TIMER_SCAL variable
      clocksource: sun4i: Cleanup parent clock setup
      clocksource: sun4i: Fix bug when switching from periodic to
oneshot modes

Soren Brinkmann (2):
      clocksource: cadence_ttc: Remove unused header
      clocksource: cadence_ttc: Reuse clocksource as sched_clock

 .../bindings/timer/moxa,moxart-timer.txt           |   17 ++
 MAINTAINERS                                        |   10 +-
 drivers/clocksource/Makefile                       |    1 +
 drivers/clocksource/cadence_ttc_timer.c            |   13 +-
 drivers/clocksource/moxart_timer.c                 |  164
++++++++++++++++++++
 drivers/clocksource/sun4i_timer.c                  |  110 +++++++++----
 6 files changed, 280 insertions(+), 35 deletions(-)
 create mode 100644
Documentation/devicetree/bindings/timer/moxa,moxart-timer.txt
 create mode 100644 drivers/clocksource/moxart_timer.c

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

