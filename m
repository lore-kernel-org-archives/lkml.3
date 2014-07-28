Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466AbaG1HnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 03:43:08 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:59923 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbaG1HnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 03:43:04 -0400
Message-ID: <53D5FF06.6080904@linaro.org>
Date: Mon, 28 Jul 2014 09:43:02 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
CC: Tomasz Figa <t.figa@samsung.com>, Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v3 0/4] ARM: EXYNOS: cpuidle: fix AFTR mode on boards
 with secure firmware enabled
References: <1404926274-18411-1-git-send-email-b.zolnierkie@samsung.com>
In-Reply-To: <1404926274-18411-1-git-send-email-b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2014 07:17 PM, Bartlomiej Zolnierkiewicz wrote:
> Hi,
>
> This patch series adds support for AFTR idle mode on boards with
> secure firmware enabled and allows EXYNOS cpuidle driver usage on
> Exynos4x12 SoCs.
>
> It has been tested on Trats2 board (using Exynos4412 SoC with secure
> firmware enabled) on which AFTR mode reduces power consumption by ~12%
> when EXYNOS cpuidle driver is enabled (in both cases the default
> exynos_defconfig config is used and CPU1-3 are offlined).


Hi Bartlomiej,

what is the status of this patchset ? Is it supposed to land for 3.17 ?

Thanks

   -- Daniel

> v3:
> - rebased on top of next-20140708 +
>    http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg32809.html
>    (with rejects fixed)
>    http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg32808.html
>    http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg32991.html
>    (with rejects fixed in patch #2)
> - addressed review comments from Tomasz Figa and Daniel Lezcano
>
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
>
>
> Bartlomiej Zolnierkiewicz (4):
>    ARM: EXYNOS: PM: replace EXYNOS_BOOT_VECTOR_* macros by static inlines
>    ARM: EXYNOS: add AFTR mode support to firmware do_idle method
>    ARM: EXYNOS: cpuidle: add secure firmware support to AFTR mode code
>    ARM: EXYNOS: cpuidle: allow driver usage on Exynos4x12 SoCs
>
>   arch/arm/include/asm/firmware.h  |  2 +-
>   arch/arm/mach-exynos/common.h    |  7 ++++++-
>   arch/arm/mach-exynos/exynos.c    |  3 ++-
>   arch/arm/mach-exynos/firmware.c  | 36 ++++++++++++++++++++++++++----------
>   arch/arm/mach-exynos/pm.c        | 39 +++++++++++++++++++++++++++++----------
>   drivers/cpuidle/cpuidle-exynos.c |  6 +++---
>   6 files changed, 67 insertions(+), 26 deletions(-)
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

