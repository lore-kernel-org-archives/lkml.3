Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbaKSJrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 04:47:47 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:35092 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbaKSJrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 04:47:45 -0500
Message-ID: <546C673F.8000502@linaro.org>
Date: Wed, 19 Nov 2014 10:47:43 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [GIT PULL] clockevents: 3.18 fix
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Thomas,

This pull request, for timers/urgent, contains one fix for the sun4i 
board where the interrupt handler was registered before the timer 
itself, thus opening a window where the interrupt could be fired and 
leading to an uninitialized data access.

Thanks !

   -- Daniel


The following changes since commit 59aa896db80479dec29f471a7ca2b9eeeeb7d38e:

   ARM/ARM64: arch-timer: fix arch_timer_probed logic (2014-10-26 
20:50:00 +0100)

are available in the git repository at:

   http://git.linaro.org/git-ro/people/daniel.lezcano/linux.git 
clockevents/3.18-fixes

for you to fetch changes up to 6bab4a8a1888729f17f4923cc5867e4674f66333:

   clockevent: sun4i: Fix race condition in the probe code (2014-11-19 
10:43:51 +0100)

----------------------------------------------------------------
Maxime Ripard (1):
       clockevent: sun4i: Fix race condition in the probe code

  drivers/clocksource/sun4i_timer.c | 12 ++++++------
  1 file changed, 6 insertions(+), 6 deletions(-)


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

