Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbaGGX0D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 19:26:03 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:44129 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbaGGX0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:26:01 -0400
Message-ID: <53BB2C81.7000108@samsung.com>
Date: Tue, 08 Jul 2014 08:25:53 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Tomasz Figa <t.figa@samsung.com>
CC: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH 0/6] Various Samsung fixes for v3.16-rc3
References: <1403618235-19353-1-git-send-email-t.figa@samsung.com> <53B2BD99.5080704@samsung.com>
In-Reply-To: <53B2BD99.5080704@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/14 22:54, Tomasz Figa wrote:
> Hi,
>
> On 24.06.2014 15:57, Tomasz Figa wrote:
>> This series inteds to fix various issues spotted while testing v3.16-rc2.
>> The patches should be reasonably independent from each other and so could be
>> picked to respective trees. See descriptions of individual patches for more
>> information.
>>
>> Tested on Exynos4412-based Trats2 and Exynos4210-based Trats boards.
>>
>> AFAIK there is no need to backport those fixes to stable.
>>
>> Tomasz Figa (6):
>>    mmc: sdhci-s3c: Fix local I/O clock gating
>>    ARM: EXYNOS: Fix core ID used by platsmp and hotplug code
>>    clk: samsung: exynos4: Remove SRC_MASK_ISP gates
>>    ARM: SAMSUNG: Restore Samsung PM Debug functionality
>>    ARM: EXYNOS: Fix suspend/resume sequencies
>>    ARM: EXYNOS: Register cpuidle device only on Exynos4210 and 5250
>>
>>   arch/arm/mach-exynos/exynos.c     |  6 ++----
>>   arch/arm/mach-exynos/hotplug.c    | 10 ++++++----
>>   arch/arm/mach-exynos/platsmp.c    | 34 +++++++++++++++++++---------------
>>   arch/arm/mach-exynos/pm.c         | 20 ++++----------------
>>   arch/arm/plat-samsung/Kconfig     |  8 +++++++-
>>   arch/arm/plat-samsung/pm-debug.c  |  1 +
>>   drivers/clk/samsung/clk-exynos4.c | 16 ++++------------
>>   drivers/mmc/host/sdhci-s3c.c      | 17 ++++++++++-------
>>   8 files changed, 53 insertions(+), 59 deletions(-)
>>
>
> Gentle ping.
>
Oops, I missed this fixes from 2nd samsung fixes for 3.16...let me have 
a look this series today then will send again soon...

Thanks,
Kukjin
