Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbbAGL0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 06:26:46 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:46918 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbbAGL0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 06:26:45 -0500
Message-ID: <54AD17F1.4010002@linaro.org>
Date: Wed, 07 Jan 2015 12:26:41 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Olof Johansson <olof@lixom.net>, Magnus Damm <magnus.damm@gmail.com>,
        Tobias Jakobi <tjakobi@math.uni-bielefeld.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL]: clockevents: 3.18 fixes
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Thomas,

this pull request provides three fixes for 3.18.

  * Magnus Damn fixed the cpumask for the sh_tmu driver in order to make 
it work on the SMP system

  * Olof Johansson fixed the __iomem annotation to prevent a sparse warning

  * Tobias Jakobi fixed the mct mask inversion which was introduced by 
commit a1ba7a7a

Thanks !

   -- Daniel

ps: happy new year ;)

The following changes since commit a5fd9733a30d18d7ac23f17080e7e07bb3205b69:

   tick/powerclamp: Remove tick_nohz_idle abuse (2014-12-19 14:05:52 +0100)

are available in the git repository at:

   http://git.linaro.org/people/daniel.lezcano/linux.git 
clockevents/3.18-fixes

for you to fetch changes up to f2a5473861cf69c03d0f0ee5d0ea1b853b9e582e:

   clocksource: sh_tmu: Set cpu_possible_mask to fix SMP broadcast 
(2015-01-05 14:43:37 +0100)

----------------------------------------------------------------
Magnus Damm (1):
       clocksource: sh_tmu: Set cpu_possible_mask to fix SMP broadcast

Olof Johansson (1):
       clocksource: kona: fix __iomem annotation

Tobias Jakobi (1):
       clocksource: exynos_mct: Fix bitmask regression for exynos4_mct_write

  drivers/clocksource/bcm_kona_timer.c | 9 ++++-----
  drivers/clocksource/exynos_mct.c     | 4 ++--
  drivers/clocksource/sh_tmu.c         | 2 +-
  3 files changed, 7 insertions(+), 8 deletions(-)


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

