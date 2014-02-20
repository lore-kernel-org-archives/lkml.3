Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbaBTMvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 07:51:53 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:48495 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181AbaBTMvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 07:51:47 -0500
Message-ID: <5305FA60.7040904@linaro.org>
Date: Thu, 20 Feb 2014 13:51:44 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org
CC: khilman@linaro.org, arnd@arndb.de, linux-sh@vger.kernel.org,
        horms@verge.net.au, john.stultz@linaro.org, olof@lixom.net,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH V7 0/3] clocksource: Consolidate SH and ARM mach-shmobile
 Kconfig bits
References: <1392897287-11614-1-git-send-email-wsa@the-dreams.de>
In-Reply-To: <1392897287-11614-1-git-send-email-wsa@the-dreams.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2014 12:54 PM, Wolfram Sang wrote:
> This is V7 of the SH and ARM mach-shmobile clocksource Kconfig consolidation
> series. It is a rebased version of V5 on top of timers/core. This series is not
> just an optimization, it also makes it possible to enable the clocksource for
> the r7s72100 platform. I successfully tested the patches on r7s72100 and
> r8a7791 platforms. The branch can be found here:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git renesas/rework-clock-config-for-daniel

Thanks Wolfram,

applied to my tree for 3.15

   -- Daniel


> Changes since V6:
>
>   - rebased on top timers/core
>
> Changes since V5:
>
>   - rebased on top of renesas-devel-v3.14-rc3-20140217
>
> Signed-off-by: Wolfram Sang <wsa@sang-engineering.com>
>
>
> === original cover letter
>
> By sharing Kconfig entires in drivers/clocksource/Kconfig we
> can get rid of duplicated bits that do not belong under arch/.
>
> With this series applied it is possible to build the timer
> drivers for CMT, MTU2, TMU and STI in case of SH or ARM. The timer
> drivers are automatically selected by default. It is also possible
> to select and/or deselect freely when COMPILE_TEST has been selected.
>
> Many thanks to Olof, John, Daniel and Arnd for feedback!
>
> Changes since V4:
>   - Use SYS_SUPPORTS_SH/EM to avoid name space pollution, thanks Olof!
>   - Remove old SH entries for SYS_SUPPORTS_xxx, use above SH prefix instead
>
> Changes since V3:
>   - Updated patch 1/3 with more detailed help texts
>   - Updated patch 2/3 to fit latest renesas-devel tag, see below
>   - Included acks from John Stultz for patch 2/3 and 3/3
>
> Signed-off-by: Magnus Damm <damm@opensource.se>
>
>
> Magnus Damm (3):
>    clocksource: Add Kconfig entries for CMT, MTU2, TMU and STI
>    ARM: shmobile: Remove CMT, TMU and STI Kconfig entries
>    sh: Remove Kconfig entries for TMU, CMT and MTU2
>
>   arch/arm/mach-shmobile/Kconfig | 36 ++++++++++----------
>   arch/sh/Kconfig                | 76 +++++++++++++-----------------------------
>   drivers/clocksource/Kconfig    | 44 ++++++++++++++++++++++++
>   3 files changed, 85 insertions(+), 71 deletions(-)
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

