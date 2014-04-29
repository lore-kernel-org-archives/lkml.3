Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbaD2NQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 09:16:11 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50899 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417AbaD2NQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 09:16:08 -0400
Message-ID: <535FA618.6080101@linaro.org>
Date: Tue, 29 Apr 2014 15:16:08 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
CC: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Alexander Shiyan <shc_work@mail.ru>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] clockevents: a couple of fixes for 3.15
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Thomas,

  * Lorenzo Pieralizi fixed an issue with the arch_arm_timer where the 
C3STOP flag for all the arch can cause some trouble by setting the flag 
only if the power domain is not always on

  * Alexander Shiyan fixed a compilation by changing the init function 
to the right prototype

Thanks
   -- Daniel

The following changes since commit 27630532ef5ead28b98cfe28d8f95222ef91c2b7:

   tick-sched: Check tick_nohz_enabled in tick_nohz_switch_to_nohz() 
(2014-04-15 20:26:58 +0200)

are available in the git repository at:

   git://git.linaro.org/people/daniel.lezcano/linux.git 
clockevents/3.15-fixes

for you to fetch changes up to 9afa27ce9414c92e271b0d7eec937bd9f5565da5:

   clocksource: nspire: Fix compiler warning (2014-04-29 15:06:43 +0200)

----------------------------------------------------------------
Alexander Shiyan (1):
       clocksource: nspire: Fix compiler warning

Lorenzo Pieralisi (1):
       clocksource: arch_arm_timer: Fix age-old arch timer C3STOP 
detection issue

  .../devicetree/bindings/arm/arch_timer.txt         |    3 +++
  drivers/clocksource/arm_arch_timer.c               |    6 +++++-
  drivers/clocksource/zevio-timer.c                  |    7 ++++++-
  3 files changed, 14 insertions(+), 2 deletions(-)


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

