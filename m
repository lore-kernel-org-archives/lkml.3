Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab3FFSQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 14:16:30 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:62616 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab3FFSQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 14:16:27 -0400
Message-ID: <51B0D1F6.5060202@linaro.org>
Date: Thu, 06 Jun 2013 20:16:22 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Tang <dt.tangr@gmail.com>,
        Lu Jingchang-B35083 <B35083@freescale.com>,
        Baruch Siach <baruch@tkos.co.il>
Subject: [GIT PULL] Clockevents/clocksources: new drivers and fix
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 1eaff67266b6b6c97bbd33cf2c20577822836413:

  clocksource: Implement clocksource_select_fallback() for
CONFIG_ARCH_USES_GETTIMEOFFSET=y (2013-05-28 09:48:46 +0200)

are available in the git repository at:

  git://git.linaro.org/people/dlezcano/clockevents.git timers/clockevents

The following changes since commit 1eaff67266b6b6c97bbd33cf2c20577822836413:

  clocksource: Implement clocksource_select_fallback() for
CONFIG_ARCH_USES_GETTIMEOFFSET=y (2013-05-28 09:48:46 +0200)

are available in the git repository at:

  git://git.linaro.org/people/dlezcano/clockevents.git timers/clockevents

for you to fetch changes up to 77ba83bb1bb1cdabd522d32536f8eee65a870145:

  clocksource: Add TI-Nspire timer support (2013-06-06 17:23:13 +0200)

----------------------------------------------------------------
Baruch Siach (1):
      clocksource: dw_apb: Fix error check

Daniel Tang (1):
      clocksource: Add TI-Nspire timer support

Jingchang Lu (1):
      clocksource: Add Freescale Vybrid pit timer support

 .../devicetree/bindings/timer/lsi,zevio-timer.txt  |   33 +++
 drivers/clocksource/Kconfig                        |    5 +
 drivers/clocksource/Makefile                       |    2 +
 drivers/clocksource/dw_apb_timer_of.c              |    2 +-
 drivers/clocksource/vf_pit_timer.c                 |  194
++++++++++++++++++
 drivers/clocksource/zevio-timer.c                  |  215
++++++++++++++++++++
 6 files changed, 450 insertions(+), 1 deletion(-)
 create mode 100644
Documentation/devicetree/bindings/timer/lsi,zevio-timer.txt
 create mode 100644 drivers/clocksource/vf_pit_timer.c
 create mode 100644 drivers/clocksource/zevio-timer.c

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

